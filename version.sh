#!/bin/bash

echo "Cur version: $(cat package.json | grep version | head -1 | awk -F: '{ print $2 }' | sed 's/[ ",]//g')"

if [ -z "$1" ]; then
    echo "Please provide a version number as an argument."
    exit 1
fi

echo "New version: $1"

sed -i 's/"version": "[0-9]*\.[0-9]*\.[0-9]*"/"version": "'$1'"/g' package.json src/manifest.json

# update package-lock.json
npm install

git add package.json src/manifest.json package-lock.json
git commit -m "chore: v$1"

git tag "v$1"

git diff HEAD^ HEAD -U0

read -p "Push changes? [y/N] " -n 1 -r
echo # new line

if [[ $REPLY =~ ^[Yy]$ ]]
    echo "Pushing new version..."
    git push origin main
    git push origin --tags
fi
