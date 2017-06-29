#cd to the directory you want to set up
cd /path/to/empty/directory/

#Initialize as a git directory:
git init

#Create SSH key for GIT:
ssh-keygen -t rsa

#Copy the ssh key and add to GIT (online){Profile > Settings> SSH and GPG Keys}
cat /home/user/.ssh/id_rsa.pub 
 
#Config User connections:
git config --global user.name [USER NAME]
git config --global user.email [USER EMAIL]

#Commit the user name changes:
git commit --amend --reset-author

#Add remote Repo:
git remote add [REMOTE NAME] [LINK FROM GITHUB TO CLONE AS SSH/HTTPS]
#e.g. git remote add Blog git@github.com:PatAnong/Blog.git

#Verify the remote repo added:
git remote -v 

#Clone the branches from the online repository locally:
git fetch [REMOTE_NAME]

#Add the files on your laptop:
git add -A

#Pull the commits from remote:
git pull [REMOTE NAME] [BRANCH]

#Commit the changes:
git commit -a -m "{Comment]"

#Push your updates 
git push [REMOTE NAME] [BRANCH]

#Confirm all updates committed:
git status
