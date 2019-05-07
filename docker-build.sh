#!/usr/bin/env bash

tar --exclude=config/deployment.json --exclude=package-lock.json --exclude=node_modules --exclude=*.tar.gz --exclude=.nyc_output --exclude=tags --exclude=.git --exclude=scripts --exclude=coverage --exclude=.vscode/ --exclude=.nyc_output/ -cvf app.tar.gz ./

docker build -t counter -f Dockerfile .;

if [ $# -ne 0 ]
  then
      echo "pushing to remote repo";
      docker login -u sumanta23
      docker tag counter:latest sumanta23/counter:latest;
      docker push sumanta23/counter:latest;
fi

rm app.tar.gz
