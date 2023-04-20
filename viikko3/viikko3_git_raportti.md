# H3 Git

1. Create a new repository

- Go to github and login
- Navigate to repositories and click new
- Name "summerofgit"
- Chose box "Add a README file"
- License "GNU General Public License"
- Click "Create repository"

2. Clone repo, make and push changes

- Click Code-SSH and copy the url
- In PowerShell navigate to root folder you want.
```powershell
cd C:\Code
```
-  clone the repo
```powershell
git clone git@github.com:Seppohto/summerofgit.git
cd summerofgit
code readme.md
```
- make changes and push changes
```bash
git add . && git commit; git pull && git push
```
OR
Do like i did and use your own function that does the same [here for Bash](https://github.com/Seppohto/OllieOver/blob/main/My%20Ultimate%20Git%20Function%20for%20Bash.md) or [here for PowerShell](https://github.com/Seppohto/OllieOver/blob/main/My%20Ultimate%20Git%20Function%20for%20Powershell.md)

```powershell
gitgud 'changes'
```
- Then we have the changes in git
![changes visible](https://raw.githubusercontent.com/Seppohto/Palvelinten-hallinta-Haaga-Helia/main/viikko3/2023-04-15%2008_04_04-Seppohto_summerofgit%20-%20Personal%20-%20Microsoft%E2%80%8B%20Edge.png "changes")

3. Reverting Stupid changes with git reset --hard
```powershell
Olli PS> code .\README.md
Olli PS> git status
On branch main
Your branch is up to date with 'origin/main'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   README.md

no changes added to commit (use "git add" and/or "git commit -a")
Olli PS> git add .
Olli PS> git status
On branch main
Your branch is up to date with 'origin/main'.

Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
        modified:   README.md

Olli PS> git reset --hard
HEAD is now at 4382169 add changes
Olli PS> git status
On branch main
Your branch is up to date with 'origin/main'.

nothing to commit, working tree clean
Olli PS>
```
4. investigate logs
```powershell
Olli PS> git log
commit 4382169e68cc8c21ca8da12a38567f7b5a2316b9 (HEAD -> main, origin/main, origin/HEAD)
Author: Olli Uronen <olli.uronen@gmail.com>
Date:   Sat Apr 15 08:01:53 2023 +0300

    add changes

commit 8b803a3e4e6341f09b95181f54b5112963a36789
Author: Seppohto <48877746+Seppohto@users.noreply.github.com>
Date:   Sat Apr 15 07:48:10 2023 +0300

    Initial commit7
```


# Lähteet
Karvinen, Tero, Infra as Code course, Palvelinten Hallinta 2023 kevät https://terokarvinen.com/2023/palvelinten-hallinta-2023-kevat/


    