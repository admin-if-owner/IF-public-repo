our next step is making some changes in github so log back in if you arent already,

this step assumes you have already created a repo, if not, do that first, to restate, i'd recommend making the repo private while learning, but a private free repo will mess with a future step, but you can cross that bridge later on, ill point to it (hopefully)

once you are in github click on your repo's parent folder  and there should be serveral options in the top left of the screen, look for the settings options and click it

in the left hand column click the branches tab and click the add branch ruleset 

call the ruleset what you want, for this one ive called it require-pull-request, there are some options to add to the default

under the Target Branches, add a target for the whole branch, you can get more granular later on, and scroll down on the Branch Rules and click the box for require a pull request before merging and you will get asked for some configuraitons to that one rule, change the required approvals to 1 for now

click save changes at the bottom

the purpose of this rule is to get used to the common and best practice of pulling the entirety of the code, making your changes, then pushing the code changes to be approved by someone else before they can be pushed to production


