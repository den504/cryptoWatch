**To_do App**

A step by step guide on how to contribute to this project using Git and Xcode.

⚠️ Important: Nothing gets merged to main until it has been reviewed and tested. Always work on a branch.

**1. Creating a Branch in Xcode**

A branch is your own safe copy of the code to work on without affecting main.

1. Open the Source Control Navigator (press ⌘+2)
2. Click the Repositories tab
3. Right-click on main under Branches
4. Select Branch from main
5. Name your branch something descriptive — e.g. feature-add-delete-button or fix-login-bug
6. Click Create
You are now working on your own branch. Changes here will not affect main.

**2. Committing to Your Branch in Xcode**

Saving a snapshot of your work locally.
1. Make your code changes
2. Go to Integrate → Commit
3. Tick the files you want to include
4. Write a clear message describing what you changed — e.g. "Added delete button to task list"
5. Click Commit
Commit little and often. Small focused commits are easier to review and easier to undo.

**3. Pushing Your Branch to GitHub**

Sending your local commits up to the remote repo.

Go to Integrate → Push
Make sure your branch name is selected (not main)
Click Push


Your branch is now visible on GitHub for others to review.

**4. Creating a Pull Request**

Requesting your branch to be reviewed and merged into main.

1. Go to github.com/den504/To_do
2. You will see a prompt — "Compare & pull request" — click it
3. Add a clear title describing what you built or fixed
4. Add a short description of your changes in the body
5. Assign a reviewer if working with others
6. Click Create Pull Request
7. Once reviewed, approved, and tested — click Merge Pull Request


Never merge your own pull request without testing first.


**5. Pulling the Most Recent Code in Xcode**

1. Click the Repositories tab
2. Expand Branches
3. Right-click on main
4. Select Checkout - You're now on main
5. Go to Integrate → Pull
6. Click Pull

Always pull before starting new work to make sure you are building on the latest version.

**6. Resolving Git Conflicts**
A conflict happens when two branches have changed the same line of code differently. Xcode will flag this after a pull or merge.

1. The conflicting file will be highlighted in the Source Control Navigator
2. Open the file — Xcode will show both versions side by side
3. Choose which version to keep — yours, theirs, or a combination of both
4. Remove the conflict markers Xcode inserted once resolved
5. Save the file
6. Integrate → Commit the resolved file with a message like "Resolved merge conflict in TaskListView"
7. Integrate → Push

**7. Daily Workflow Summary**

Pull main → Create branch → Write code → 
Commit → Push branch → Open Pull Request → 
Review & test → Merge to main → Pull main
