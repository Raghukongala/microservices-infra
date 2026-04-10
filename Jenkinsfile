pipeline {
    agent any

    environment {
        AWS_REGION = 'ap-south-1'
        TF_DIR     = 'terraform/envs/dev'
        GIT_REPO   = 'https://github.com/Raghukongala/microservices-infra.git'
        CLUSTER    = 'dev-eks-cluster-v2'
    }

    options {
        timestamps()
        disableConcurrentBuilds()
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main', url: "${GIT_REPO}"
            }
        }

        stage('Pre Cleanup AWS Resources') {
            steps {
                sh '''
                set +e

                echo "=== Deleting EKS Node Groups First ==="
                if aws eks describe-cluster --name $CLUSTER --region $AWS_REGION >/dev/null 2>&1; then

                    nodegroups=$(aws eks list-nodegroups \
                        --cluster-name $CLUSTER \
                        --region $AWS_REGION \
                        --query "nodegroups[*]" \
                        --output text 2>/dev/null || true)

                    for ng in $nodegroups; do
                        echo "Deleting node group: $ng"
                        aws eks delete-nodegroup \
                            --cluster-name $CLUSTER \
                            --nodegroup-name "$ng" \
                            --region $AWS_REGION || true

                        echo "Waiting for node group $ng to be deleted..."
                        aws eks wait nodegroup-deleted \
                            --cluster-name $CLUSTER \
                            --nodegroup-name "$ng" \
                            --region $AWS_REGION || true
                    done

                    echo "=== Deleting EKS Cluster ==="
                    aws eks delete-cluster --name $CLUSTER --region $AWS_REGION || true
                    aws eks wait cluster-deleted --name $CLUSTER --region $AWS_REGION || true
                else
                    echo "No EKS cluster found — skipping"
                fi

                echo "=== Deleting ECR Repositories ==="
                repos=$(aws ecr describe-repositories \
                    --region $AWS_REGION \
                    --query "repositories[*].repositoryName" \
                    --output text 2>/dev/null || true)

                for repo in $repos; do
                    echo "Deleting ECR repo: $repo"
                    aws ecr delete-repository \
                        --repository-name "$repo" \
                        --force \
                        --region $AWS_REGION || true
                done

                echo "=== Deleting KMS Alias ==="
                aws kms delete-alias \
                    --alias-name "alias/eks/$CLUSTER" \
                    --region $AWS_REGION || true

                echo "=== Deleting CloudWatch Log Group ==="
                LOG_GROUP="/aws/eks/$CLUSTER/cluster"
                aws logs delete-log-group \
                    --log-group-name "$LOG_GROUP" \
                    --region $AWS_REGION || true

                echo "=== Pre-Cleanup Complete ==="
                '''
            }
        }

        stage('Terraform Init (Clean + Upgrade)') {
            steps {
                sh '''
                set -e
                cd $TF_DIR

                echo "=== Cleaning Terraform cache ==="
                rm -rf .terraform .terraform.lock.hcl

                echo "=== Initializing Terraform with upgrade ==="
                terraform init -upgrade

                echo "=== Terraform Init Complete ==="
                '''
            }
        }

        stage('Terraform Format Check') {
            steps {
                sh '''
                set -e
                cd $TF_DIR
                terraform fmt -check || terraform fmt
                '''
            }
        }

        stage('Terraform Import (Safe)') {
            steps {
                sh '''
                set +e
                cd $TF_DIR

                echo "==== IMPORTING ECR REPOS ===="
                for repo in user-service product-service order-service api-gateway; do
                    if aws ecr describe-repositories \
                        --repository-names "$repo" \
                        --region $AWS_REGION >/dev/null 2>&1; then
                        echo "Importing ECR repo: $repo"
                        terraform import \
                            "module.ecr.aws_ecr_repository.repos[\\\"$repo\\\"]" \
                            "$repo" || true
                    else
                        echo "Skipping $repo (not found in AWS)"
                    fi
                done

                echo "==== KMS ALIAS CHECK ===="
                if aws kms list-aliases --region $AWS_REGION \
                    | grep -q "alias/eks/$CLUSTER"; then
                    echo "KMS alias still exists — skipping import"
                else
                    echo "KMS alias not found — no import needed"
                fi

                echo "==== Import Stage Complete ===="
                '''
            }
        }

        stage('Terraform Validate') {
            steps {
                sh '''
                set -e
                cd $TF_DIR

                echo "=== Running Terraform Validate ==="
                terraform validate

                echo "=== Terraform Validate Passed ==="
                '''
            }
        }

        stage('Terraform Plan') {
            steps {
                sh '''
                set -e
                cd $TF_DIR
                terraform plan -out=tfplan
                '''
            }
        }

        stage('Approval') {
            steps {
                input message: "⚠️ Review the plan above. Confirm Terraform Apply?",
                      ok: "Deploy"
            }
        }

        stage('Terraform Apply') {
            steps {
                sh '''
                set -e
                cd $TF_DIR
                terraform apply -auto-approve tfplan
                '''
            }
        }

        stage('Post Deployment Check') {
            steps {
                sh '''
                set +e
                cd $TF_DIR

                echo "==== Terraform Outputs ===="
                terraform output

                echo "==== Verifying EKS Cluster ===="
                aws eks describe-cluster \
                    --name $CLUSTER \
                    --region $AWS_REGION \
                    --query "cluster.status" \
                    --output text || true

                echo "==== Listing Node Groups ===="
                aws eks list-nodegroups \
                    --cluster-name $CLUSTER \
                    --region $AWS_REGION || true
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Deployment Completed Successfully"
        }
        failure {
            echo "❌ Pipeline Failed - Check logs above"
        }
        always {
            cleanWs()
        }
    }
}
