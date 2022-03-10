#!/bin/bash

function manual_verification {
  read -p "Continue deployment? (y/n) " answer

    if [[ $answer =~ ^[Yy]$ ]] ;
    then
        echo "continuing deployment"
    else
        exit
    fi
}

function green_deploy {
  kubectl apply -f ../apps/blue-green/index_green_html.yml
  kubectl apply -f ../apps/blue-green/green.yml
  
  ATTEMPTS=0
  ROLLOUT_STATUS_CMD="kubectl rollout status deployment/green -n udacity"
  until $ROLLOUT_STATUS_CMD || [ $ATTEMPTS -eq 60 ]; do
    $ROLLOUT_STATUS_CMD
    ATTEMPTS=$((attempts + 1))
    sleep 1
  done
  
  terraform init
  terraform plan
  terraform apply --auto-approve

  kubectl delete deploy blue
  kubectl delete cm blue-config
  
  echo "Green deployment successful!"
}


# Begin canary deployment
while [ $(kubectl get pods -n udacity | grep -c blue) -gt 0 ]
do
  manual_verification
  green_deploy
done

