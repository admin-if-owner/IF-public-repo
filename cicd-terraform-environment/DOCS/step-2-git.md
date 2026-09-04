our next step is making some changes in github so log back in if you arent already,

this step assumes you have already created a repo, if not, do that first, to restate, i'd recommend making the repo private while learning, but a private free repo will mess with a future step, but you can cross that bridge later on, ill point to it (hopefully)

once you are in github click on your repo's parent folder  and there should be serveral options in the top left of the screen, look for the settings options and click it

in the left hand column click the branches tab and click the add branch ruleset 

call the ruleset what you want, for this one ive called it require-pull-request, there are some options to add to the default

under the Target Branches, add a target for the whole branch, you can get more granular later on, and scroll down on the Branch Rules and click the box for require a pull request before merging and you will get asked for some configuraitons to that one rule, change the required approvals to 1 for now

click save changes at the bottom

the purpose of this rule is to get used to the common and best practice of pulling the entirety of the code, making your changes, then pushing the code changes to be approved by someone else before they can be pushed to production

the next thing to do is to create the azure ad app registration, this is the azure applicaiton that will be used to connect to github to push our code over to azure to modify/update/remove things from our production/development envrironment 

back in your code editor, go to your utilties folder and run the powershell/bash script for az_ad_app_registration

Then when it completes and creates the object in auzre, we then need to assign azure permissions to your account(if this is your personal account, by default alot of roles are not applied and the global admin role thats applied at default doesnt not cover all the necessary permissions to do some things, if this is an active production enviornment, you might need to get with whoever runs your Azure environemtn to get added to the correct roles)

to get the correct roles needed for the github actions, go into your utilites folder and run the az_ad_github_permissions script


