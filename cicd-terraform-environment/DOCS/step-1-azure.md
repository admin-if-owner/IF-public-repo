to get started, you need to create an azure account, i wont hold your hand on that one, its pretty easy

once you have the azure account, open your code editor, im using vscode, but you can use whatever youw want, github codespaces is pretty nice, might need some settings tweaks but its decent alternative if you have limited space on a computer/laptop

first thing to we need to do is install the command line tools for interacting with azure/terraform/github 

in the utilities folder are bash/powershell scripts to get started, you will start by running the tool_install script 

if using vscode, there are some helpful extensions
    hashicorp terraform
    azure terraform(i think it was renamed Microsoft terraform)
    github actions

once the tools are installed, open a terminal and get into azure by using command
*COMMANDS CAN CHANGE AS MICROSOFT UPDATES THINGS*
    az login 

once you have logged into azure in the terminal, we need to setup a storage account for terraform to function, its a one time setup

go into the utilities folder bash for linux and powershell for windows
you will run the az_initial_storage_setup script, make sure to look over the script first, i use a default naming convention, you can change it to make sense to you but keep it the same across the board

the last thing we need to do is create a terraform file, terraform recommends a file structure like what ive used in this repository, so i'd say keep it in yours

under your parent folder create a folder called environemnts and 2 subfolders called prod and dev

in both your prod/dev folder create a file called backend.tf
this file will be used by terraform as a location to call your secerts, like passwords, ID's/etc

now we move onto the next step