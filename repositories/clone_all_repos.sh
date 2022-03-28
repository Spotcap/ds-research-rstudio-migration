#!/bin/bash
user=ilia.ozhmegov@spotcap.com:bwk.tmr7TZE3jrq0mgu


### part 1
# curl -u $user 'https://api.bitbucket.org/2.0/user/permissions/teams?pagelen=100' > teams.json

# jq -r '.values[] | .team.username' teams.json > teams.txt

### part 2
# team=datasciencespotcap
# echo $team
# # rm -rf "${team}"
# 
# # mkdir "${team}"
# 
# cd "${team}"
# 
# url="https://api.bitbucket.org/2.0/repositories/${team}?pagelen=100"
# 
# echo $url
# 
# # curl -u $user $url > repoinfo.json
# 
# jq -r '.values[] | .links.clone[1].href' repoinfo.json > repos.txt


### part 3

team=datasciencespotcap
cd "${team}"
for repo in `cat repos.txt`
do
  echo "Cloning" $repo
  git clone $repo
done

cd ..
