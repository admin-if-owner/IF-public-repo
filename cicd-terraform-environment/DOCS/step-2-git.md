our next step is making some changes in github so log back in if you arent already,

this step assumes you have already created a repo, if not, do that first, to restate, i'd recommend making the repo private while learning, but a private free repo will mess with a future step, but you can cross that bridge later on, ill point to it (hopefully)

once you are in github click on your repo's parent folder  and there should be serveral options in the top left of the screen, look for the settings options and click it

in the left hand column click the branches tab and click the add branch ruleset 

call the ruleset what you want, for this one ive called it require-pull-request, there are some options to add to the default

under the Target Branches, add a target for the whole branch, you can get more granular later on, and scroll down on the Branch Rules and click the box for require a pull request before merging and you will get asked for some configuraitons to that one rule, if you are a 1 person team, keep the required approvals at 0, if you set it to 1 another human must review the changes, you cannot review your own changes, so keep it at 0 till you have competant people to review

click save changes at the bottom

the purpose of this rule is to get used to the common and best practice of pulling the entirety of the code, making your changes, then pushing the code changes to be approved by someone else before they can be pushed to production

once this rule is active, you cannot push to github the "normal way" 
no more 
    git add .
    git commit -m "blah blah blah"
    git push origin main
now you will have to create a feature branch 
    git checkout -b feature/name-of-whatever-you-added-or-changed
    git add . #make sure you are in the correct folder to capture all your changes
    git commit -m "stupidly specific description of what you did"
    git push -u origin feature/name-of-whatever-you-added-or-changed
then you have to log into github
    click into your repo
    you will see a green banner saying something about a pull request
    click it, there are some additional places to set who can review and more
    you can add some additional comments as a reviewer
    then push it to main or cancel it and send it back to the coder with suggestions/changes

the next thing to do is to create the azure ad app registration, this is the azure applicaiton that will be used to connect to github to push our code over to azure to modify/update/remove things from our production/development envrironment 

back in your code editor, go to your utilties folder and run the powershell/bash script for az_ad_app_registration

Then when it completes and creates the object in azure, we then need to assign azure permissions to your account(if this is your personal account, by default alot of roles are not applied and the global admin role thats applied at default doesnt not cover all the necessary permissions to do some things, if this is an active production enviornment, you might need to get with whoever runs your Azure environment to get added to the correct roles)

*updated az_ad_app_registration to include role assignment*

