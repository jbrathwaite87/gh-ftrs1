#!/bin/bash

set -e

# Function to print environment variables for debugging
print_env_vars() {
  echo "GITHUB_TOKEN: $GITHUB_TOKEN"
  echo "AZURE_CLIENT_ID: $AZURE_CLIENT_ID"
  echo "AZURE_SUBSCRIPTION_ID: $AZURE_SUBSCRIPTION_ID"
  echo "AZURE_TENANT_ID: $AZURE_TENANT_ID"
  echo "WORKLOAD: $WORKLOAD"
  echo "LOCATION: $LOCATION"
  echo "ENVIRONMENTS: $ENVIRONMENTS"
  echo "GITHUB_REPOSITORY_NAME: $GITHUB_REPOSITORY_NAME"
  echo "GITHUB_REPOSITORY_DESCRIPTION: $GITHUB_REPOSITORY_DESCRIPTION"
  echo "GITHUB_ORGANISATION_TARGET: $GITHUB_ORGANISATION_TARGET"
  echo "USE_MANAGED_IDENTITY: $USE_MANAGED_IDENTITY"
}

# Set Terraform variables
set_tf_vars() {
  export TF_VAR_github_token="$GITHUB_TOKEN"
  export TF_VAR_github_repository_name="$GITHUB_REPOSITORY_NAME"
  export TF_VAR_github_repository_description="$GITHUB_REPOSITORY_DESCRIPTION"
  export TF_VAR_github_organisation_target="$GITHUB_ORGANISATION_TARGET"
  export TF_VAR_location="$LOCATION"
  export TF_VAR_workload="$WORKLOAD"
  export TF_VAR_environments="$ENVIRONMENTS"
  export TF_VAR_use_managed_identity="$USE_MANAGED_IDENTITY"
}

# Initialize Terraform
terraform_init() {
  echo "Initializing Terraform"
  terraform init
}

# Plan Terraform deployment
terraform_plan() {
  echo "Planning Terraform deployment"
  terraform plan -out=tfplan
}

# Apply Terraform deployment
terraform_apply() {
  echo "Applying Terraform deployment"
  terraform apply -input=false tfplan
}

# Destroy Terraform deployment
terraform_destroy() {
  echo "Destroying Terraform deployment"
  terraform destroy -auto-approve
}

# Main script execution
print_env_vars
set_tf_vars

# Change directory to the Terraform folder
echo "Changing directory to ../example"
cd ../example

terraform_init

if [ "$1" == "destroy" ]; then
  terraform_destroy
else
  terraform_plan
  terraform_apply

  # Capture the GitHub repository URL from Terraform output
  echo "Capturing the GitHub repository URL"
  GITHUB_REPOSITORY_URL=$(terraform output -raw github_repository_url)
  echo "GitHub Repository URL: $GITHUB_REPOSITORY_URL"

  # Extract repository name from URL
  REPO_NAME=$(basename -s .git "$GITHUB_REPOSITORY_URL")

  # Change directory back to the root
  echo "Changing directory back to the root"
  cd ..

  # Check if the repository is already cloned
  if [ -d "$REPO_NAME" ]; then
    echo "Repository already cloned. Pulling latest changes."
    cd "$REPO_NAME"
    git pull
  else
    echo "Cloning the repository"
    git clone "$GITHUB_REPOSITORY_URL"
  fi
fi
