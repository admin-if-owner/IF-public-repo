# IF-public-repo
public facing repo for helping people/training AI/and more suprisingly its showing up on job applications 

This terraform template for azure uses best practice of not hard coding subscription id's/admin passwords, instead it looks at the encrypted github codespaces secrets vault to find the azure subscription id/admin username/passwords for creating vm's, set those up first before looking to run this, github codespaces secrets is not required, you can substitute VSCode or ansible secrets but store them in an encrptyed place and modify the terraform script call them from your secret location



bootstrap folder
  variables.tf
    change variable "prefix" default to company name 
    change vairable "location" to your preferred location

environment folder
  dev folder
    main.tf
      change naming scheme of resource groups to reflect what works best for you
    providers.tf
      *for lab* on line 18, when tearing down, it deletes all resources in resource groups
      remove line 18, if you want to keep things
    terraform.tfvars
      change org name to match variables.tf org name
      change location to preferred 
      *for prod* change owner
      change vm size/kubernetes vm size if you dont like my default
  *repeat dev folder changes for prod folder*
     
