This is a public repo for those who want to learn how to create an azure environment using githubs CI/CD pipeline and terraform, the purpose is to have the terraform documentation live in Github so you only have to modify it here and it reduces the need for manually running the commands to push any additions/subtractions from your environemnt

while im building this in VSCode on my Ubuntu machine, ill add in powershell scripts that will do the same things if you want to build this on a windows machine

At some point ill feed this ReadMe file into claude or soemthing to format and make it look pretty but for now, you get to hear my ramblings

Your first step will be to get into github and create your repo, preferably private, as somepeople prefer to hard code passwords/and other ID's into their code, my goal is to keep everything in a secret vault and have the terraform documents/scripts look thier but we will cross that bridge as we build

Once you have the repo, copy the repo into your code editor, whether VSCode, GitHub CodeSpaces, or whatever you prefer

once copied to your code editor, run the tools_install script based on your operating system in the utilities folder to get the ground work started, it will install Azure CLI and terraform, if using powershell it will install winget first before grabbing the other tools

If using VSCode, grab some helpful not not required extensions(vscode extensions can be malicous and understandable if you want to avoid them)
    hashicorp terraform
    azure terraform (potentially renamed to Microsoft Terraform)
    GitHub actions

Once you have the ground work scripts ran, the next step is to create 2 files, one being .gitignore file(doesnt push certain files to github, great for terraform, passwords/etc)
the 2nd is a .env file, this is where you will hard code passwords, logins/etc, its not mandatory to store passwords and such here, but its nice to see them, should you need to change them, but you are welcome to store them elsewhere, like in an ansible secret vault, or github codespaces, just make sure to add the .nv file to the .gitignore so it doesnt get pushed to your repo, and is safely stored on your local machine

make sure your .env and .ignore is directly under repo folder
    example
        ~/IF-public-repo
            cicd-terraform-environment
            .env
            .gitignore
and make just copy this below into your .gitignore file
    # Terraform state (may contain secrets) - never commit
    *.tfstate
    *.tfstate.*
    crash.log

    # Local provider plugins and lock caches
    .terraform/
    .terraform.lock.hcl

    # Secret / environment-specific variable files
    *.auto.tfvars
    secrets.tfvars
    .env

    # OS / editor noise
    .DS_Store
    Thumbs.db

make sure you git commit the work so far by using commands
    git add . # make sure you are doign this from the top repo folder, in my case its the cicd-terraform-environment folder
    git commit -m "this is where you input the commit message of the work you have done, be as specific as you can, will help you later on if you have to recall something"
    git push origin main

The next steps will be in the DOC folder, where we will work on the next steps

