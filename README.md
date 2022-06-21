# Project templates

To install project templates build `InstallTemplates` target or run:

```
cp -R ./Meta/CustomTemplates/Combine\ Scene.xctemplate ~/Library/Developer/Xcode/Templates/File\ Templates/Custom/My\ Templates/
``` 

# The challenge consists:

1. You do your coding, solve the task and send us the results
2. We review your solution and if we like it, we will host a session where you present your solution to us.

The task is to implement a simple iOS application that solves the following two user stories:
As a freelance I want to be able to:
* Take photos of my expenses (receipts or invoices).
* Add information about the receipt (date, total, currency, etc) and store it locally
* Access the history of the photos taken (should be available offline) with the data I inputted
* The app should work even if you are offline and should maintain its state after closing
* The solution must be thread safe and should be robust enough to handle large sets of data.

Keep in mind that we do not expect your code to be production ready. We are looking to see if you have the ability to transform a set of user requirements into a working tool, preferably creating some cool and well architectured code along the way.

### We appreciate that your solution is:
* Buildable and runnable
* Structured
* Maintainable
* Testable

The solution should be published on your personal GitHub account and we prefer to see commits that reflect progress rather than one huge commit once your solution is finished.
