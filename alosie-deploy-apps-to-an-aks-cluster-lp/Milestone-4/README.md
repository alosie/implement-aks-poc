# Milestone 4 Full Solution

The is the full solution for Milestone 4. The files and directories here include the following:

* The files from the Milestone 3 solution
* The example application helm chart in `helm-app`
* The YAML pipeline files in `pipelines`

The values in the `terraform.tfvars` file should be updated if you wish to use a different region or naming convention.

## Deploying the Solution

To deploy the solution, you should either already have the cluster and Azure DevOps project up and running or you will deploy it using this full solution. 

### Creating the AKS cluster and ADO project

If you don't already have the cluster and ADO project deployed, follow these instructions. Otherwise skip to the next section.

You will use Terraform to deploy the configuration, but before you do, you'll need to create some resources. You're going to need a personal access token from GitHub and another one from Azure DevOps. Follow the links to create each:

* [GitHub Personal Access Token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)
  * **Only need repository access**
* [Azure DevOps Personal Access Token ](https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=azure-devops&tabs=preview-page)
  * **Needs to be able to create and manage projects**

You'll also need your Azure DevOps Organization Service URL. You can find this by logging into Azure DevOps and checking the Overview page for your organization. The URL should be in the form: https://dev.azure.com/MY_ORG_NAME

To use these values in the configuration, you can set environment variables as show below.

```bash
# Mac and Linux
export AZDO_PERSONAL_ACCESS_TOKEN=YOUR_AZURE_DEVOPS_PAT
export TF_VAR_ado_github_pat=YOUR_GITHUB_PAT
export AZDO_ORG_SERVICE_URL=YOUR_AZURE_DEVOPS_ORG_URL

# PowerShell
$env:AZDO_PERSONAL_ACCESS_TOKEN="YOUR_AZURE_DEVOPS_PAT"
$env:TF_VAR_ado_github_pat="YOUR_GITHUB_PAT"
$env:AZDO_ORG_SERVICE_URL="YOUR_AZURE_DEVOPS_ORG_URL"
```

For Azure authentication, you can use integrated authentication with the Azure CLI. Just make sure you are logged in and have the correct subscription set.

```bash
az login
az account set -s YOUR_AZURE_SUBSCRIPTION_NAME
```

Then run through the standard Terraform workflow:

```bash
cd setup
terraform init
terraform apply -auto-approve
```

## Setting up the pipelines

### GitHub

Your AKS code and Helm charts will reside in GitHub along with your pipeline YAML files. The full solution includes a `pipeline` directory with five pipeline files. These should be checked into a repository in GitHub on the default branch. The pipelines are configured to track the directory structure shown in the full solution. If you decide to use a different structure, update the pipeline YAML files accordingly.

### Azure DevOps Pipelines

Once your code is checked into GitHub, in ADO Pipelines, create a new pipeline and link it to the `push.yaml` file in the `pipelines` directory of your GitHub repository. You can rename the pipeline in the UI to something friendlier, like CI Push. You will repeat this process for each of the five pipeline files.

To test the `push` pipeline, create a feature branch and make a change in the `helm-app` directory. Publish the branch to GitHub and that should kick off the pipeline.

The `pr` pipeline will be triggered when a Pull Request is created to merge the feature branch into the default branch. The `merge` pipeline will be triggered when the merge is approved and completed. The `staging` pipeline will run when the `merge` pipeline completes. The `production` pipeline will run when the staging pipeline completes.
