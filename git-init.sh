echo "# code1" >> README.md
echo "For learning and reference" >> README.md

git init
git add .
git commit -m "first commit"
git remote add origin https://github.com/coderdba-coding-org/code1.git
git push -u origin master
