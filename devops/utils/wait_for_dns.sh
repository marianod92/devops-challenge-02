# #!/bin/bash

# while true
# do

#   STATUS=$(curl -s -o /dev/null -w '%{http_code}' $(kubectl get svc nakama -n nakama -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'))
#   if [ $STATUS -eq 200 ]; then
#     echo "Got 200! All done!"
#     break
#   else
#     echo "Got $STATUS :( Not done yet..."
#   fi
#   sleep 10
# done

# Pass the name of a service to check ie: sh check-endpoint.sh staging-voting-app-vote
# Will run forever...
external_ip=""
while [ -z $external_ip ]; do
  echo "Waiting for end point..."
  external_ip=$(kubectl get svc $1 --template="{{range .status.loadBalancer.ingress}}{{.ip}}{{end}}")
  [ -z "$external_ip" ] && sleep 10
done
echo 'End point ready:' && echo $external_ip