This is a public repo for those who want to learn how to create an azure environment using githubs CI/CD pipeline and terraform, the purpose is to have the terraform documentation live in Github so you only have to modify it here and it reduces the need for manually running the commands to push any additions/subtractions from your environemnt

while im building this in VSCode on my Ubuntu machine, ill add in powershell scripts that will do the same things if you want to build this on a windows machine

At some point ill feed this ReadMe file into claude or soemthing to format and make it look pretty but for now, you get to hear my ramblings

Your first step will be to get into github and create your repo, preferably private, as somepeople prefer to hard code passwords/and other ID's into their code, my goal is to keep everything in a secret vault and have the terraform documents/scripts look thier but we will cross that bridge as we build

Once you have the repo, copy the repo into your code editor, whether VSCode, GitHub CodeSpaces, or whatever you prefer

once copied to your code editor, run the tools_install script based on your operating system in the utilities folder to get the ground work started, it will install Azure CLI and terraform, if using powershell it will install winget first before grabbing the other tools

