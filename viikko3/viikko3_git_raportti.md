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
![changes visible](/path/to/img.jpg "changes")
