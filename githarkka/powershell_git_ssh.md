# Git SSH in Powershell
- I use Windows 11 and powershell
- ssh has been installed automatically
```
# next command in bash
# git add . && git commit ; git pull && git push
git add . ; if ($?) { git commit } ; git pull ; if ($?) { git push }
```

# Check if key exists
```
Get-ChildItem -Path ~/.ssh/id_rsa.pub
```
# Generate key
```
ssh-keygen.exe
# I just clicked enter multiple times
```
# Copy key
```
Get-Content -Path ~/.ssh/id_rsa.pub | Clip
```
# Add it to github
- Go to github
- Open settings
- Navigate to SSH and GPG keys
- Click New SSH key


# All Done
Now you can use ssh with git

