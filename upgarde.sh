#!/bin/bash

# exit when any command fails
set -e

new_ver=$1

echo "new version: $new_ver"

# Simulate release of the new docker images
docker tag nginx:1.23.3 jkatergaris/nginx:$new_ver

# Push new version to dockerhub
docker push jkatergaris/nginx:$new_ver

# Create temporary folder
tmp_dir=$(mktemp -d)
echo $tmp_dir

# Clone GitHub repo
git clone https://github.com/jkatergaris/spags-public.git $tmp_dir

file=$tmp_dir/my-app/1-deployment.yaml
echo $file
# Update image tag
sed -i "s/nginx:v.*/nginx:$new_ver/" $file

# Commit and push
cd $tmp_dir
git add .
git commit -m "Update image to $new_ver"
git push

# Optionally on build agents - remove folder
rm -rf $tmp_dir