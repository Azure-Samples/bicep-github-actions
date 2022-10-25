# GitHub Actions Workflows for Bicep

This is a sample repository that shows how to build GitHub Actions workflows to manage infrastructure with Bicep. 

## Architecture

<img width="2159" alt="GitHub Actions CICD for Bicep" src="https://user-images.githubusercontent.com/1248896/189254453-439dd558-fc6c-4377-b01c-d5e54cc49403.png">

## Dataflow

1. Create a new branch and check in the needed Bicep code modifications.
2. Create a Pull Request (PR) in GitHub once you're ready to merge your changes into your environment.
3. A GitHub Actions workflow will trigger to ensure your code is well formatted. In addition, a What-If analysis should run to generate a preview of the changes that will happen in your Azure environment.
4. Once appropriately reviewed, the PR can be merged into your main branch.
5. Another GitHub Actions workflow will trigger from the main branch and execute the changes using Bicep.

## Workflows

1. [**Bicep Unit Test**](.github/workflows/bicep-unit-test.yml)
    This workflow is designed to be run on every commit and is composed of a set of unit tests on the infrastructure code. It runs [bicep build](https://docs.microsoft.com/cli/azure/bicep#az-bicep-build) to compile the bicep to an ARM template. This ensure there are no formatting errors. Next it performs a [validate](https://docs.microsoft.com/cli/azure/deployment/sub#az-deployment-sub-validate) to ensure the template is able to be deployed.

2. [**Bicep What-If / Deploy**](.github/workflows/bicep-whatif-deploy.yml)
    This workflow runs on every pull request and on each commit to the main branch. The what-if stage of the workflow is used to understand the impact of the IaC changes on the Azure environment by running [what-if](https://docs.microsoft.com/cli/azure/deployment/sub#az-deployment-sub-what-if). This report is then attached to the PR for easy review. The deploy stage runs after the what-if analysis when the workflow is triggered by a push to the main branch. This stage will [deploy](https://docs.microsoft.com/cli/azure/deployment/sub#az-deployment-sub-create) the template to Azure after a manual review has signed off.

## Getting Started

To use these workflows in your environment several prerequiste steps are required:

1. **Create GitHub Environments**
    The workflows utilizes GitHub Environments and secrets to store the azure identity information and setup an appoval process for deployments. Create an environment named `production` by following these [instructions](https://docs.github.com/actions/deployment/targeting-different-environments/using-environments-for-deployment#creating-an-environment). On the `production` environment setup a protection rule and add any required approvers you want that need to sign off on production deployments. You can also limit the environment to your main branch. Detailed instructions can be found [here](https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment#environment-protection-rules).

2. **Setup Azure Identity**:
    An Azure Active Directory application is required that has permissions to deploy within your Azure subscription. Create a single application and give it the appropriate read/write permissions in your Azure subscription. Next setup the federated credentials to allow the GitHub to utilize the identity using OIDC. See the [Azure documentation](https://docs.microsoft.com/azure/developer/github/connect-from-azure?tabs=azure-portal%2Clinux#use-the-azure-login-action-with-openid-connect) for detailed instructions. Three federated credentials will need to be added:
      - Set Entity Type to `Environment` and use the `production` environment name. 
      - Set Entity Type to `Pull Request`.
      - Set Entity Type to `Branch` and use the `main` branch name.
    
3. **Add GitHub Secrets**
    _Note: While none of the data about the Azure identities contain any secrets or credentials we still utilize GitHub Secrets as a convenient means to paramaterize the identity information per environment._

    Create the following secrets on the repository using the Azure identity:

    - _AZURE_CLIENT_ID_ : The application (client) ID of the app registration in Azure
    - _AZURE_TENANT_ID_ : The tenant ID of Azure Active Directory where the app registration is defined.
    - _AZURE_SUBSCRIPTION_ID_ : The subscription ID where the app registration is defined.
    
    Instructions to add the secrets to the repository can be found [here](https://docs.github.com/en/actions/security-guides/encrypted-secrets#creating-encrypted-secrets-for-a-repository).

## Additional Resources
A companion article detailing how to use GitHub Actions to deploy to Azure using IaC can be found at the [DevOps Resource Center](). `TODO: add link`
