#!/bin/bash

# 1: geting teamit

org=Spotcap

team="Data Science"

teamid=$(curl -s -H "Authorization: token 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" "https://api.github.com/orgs/$org/teams" | \
    jq --arg team "$team" '.[] | select(.name==$team) | .id')

echo $teamid

# 2: walk throught all folders
cd datasciencespotcap
# cd ds

for repo in $(ls)
do 
    echo "Checking" $repo
        echo $repo
        echo $repo
    cd $repo
    remote=$(git remote -v)
    if [[ $remote == *"github"* ]]; then
        echo "Already on github!"
        echo "Already on github!"
        echo "Already on github!"
        echo "Already on github!"
        echo "Already on github!"
        echo "Already on github!"
    else
        echo "Uploading:"
        echo "Uploading:" 
        echo "Uploading:" 
        echo "Uploading:" 
        echo "Uploading:" 

        git remote rename origin old_origin
        git remote add origin git@github.com:Spotcap/$repo

        curl -H "Authorization: token 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" --data '{"name": "'$repo'", "private": true}' https://api.github.com/orgs/Spotcap/repos
        curl -v -H "Authorization: token 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" -d "" -X PUT "https://api.github.com/teams/$teamid/repos/$org/$repo"

        git push -u origin master
    fi
    cd ..
done


# not useful
# curl -H "Authorization: token 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" --data '{"name":"deleteme"}' https://api.github.com/user/repos


# curl -H "Authorization: token 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" --data '{"name":"ds-test-private-deleteme", "private": true}' https://api.github.com/orgs/Spotcap/repos


# org=Spotcap
# repo=ds-test-private-deleteme
# 
# team="Data Science"
# 
# teamid=$(curl -s -H "Authorization: token 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" "https://api.github.com/orgs/$org/teams" | \
#     jq --arg team "$team" '.[] | select(.name==$team) | .id')
# 
# echo $teamid
# 
# curl -v -H "Authorization: token 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" -d "" -X PUT "https://api.github.com/teams/$teamid/repos/$org/$repo"
