# #!/bin/bash
while true
do
  LB_DNS=$(kubectl get svc nakama -n nakama -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
  URL=$(echo "http://${LB_DNS}:7451/#/status")
  STATUS=$(curl -s -o /dev/null -w '%{http_code}' $URL)

  if [ $STATUS -eq 200 ]; then
    echo "\nGot 200! All done!" 
    echo "********************************************************************************************"
    echo "********************************************************************************************"
    echo "\e[1;33m"${URL}"\e[1;m"
    echo "********************************************************************************************"
    echo "********************************************************************************************"
    break
  else
    echo "Got $STATUS :( Not done yet..."
  fi
  sleep 10
done