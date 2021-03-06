clear
#!/bin/bash
echo -e "______________________________________________________________________________________________"                                                                                  
echo -e " ____ _    ____ _  _ ____ _  _    ____ ____ ____ _  _ ____ ____    ____ ____ _  _ ____ _ ____ "
echo -e " |    |    |__| |\/| |__| |  |    [__  |___ |__/ |  | |___ |__/    |    |  | |\ | |___ | | __ "
echo -e " |___ |___ |  | |  | |  |  \/     ___] |___ |  \  \/  |___ |  \    |___ |__| | \| |    | |__] "
echo -e "______________________________________________________________________________________________"   
echo -e "                                                                     B Y :   R O M A R   C  . "    
echo -e "______________________________________________________________________________________________"   

#container image build of clamav version 0.103.0
export CLAMAV_IMAGE=romarcablao/clamav:0.103.0
export CLAMAV_API_IMAGE=romarcablao/clamav-api:0.103.0

#set default
DEFAULT_SERVER_NAME=clamav.thecloudspark.com
DEFAULT_API_AUTH_KEY=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 32 ; echo '')
DEFAULT_API_FORM_KEY=FILE_UPLOAD
DEFAULT_MAX_UPLOAD_FILE_SIZE=10
DEFAULT_MAX_UPLOAD_FILES_NUMBER=3
DEFAULT_CLAMD_TIMEOUT=300
USE_NGINX=No
DOCKER_COMPOSE_TEMPLATE=docker-compose-without-nginx.tpl

#override default
read -p "Enter server name (e.g. $DEFAULT_SERVER_NAME): " SERVER_NAME
read -p "Enter api authentication key (pre-generated: $DEFAULT_API_AUTH_KEY): " API_AUTH_KEY
read -p "Enter api form key (default: $DEFAULT_API_FORM_KEY): " API_FORM_KEY
read -p "Enter upload file max number (default: $DEFAULT_MAX_UPLOAD_FILES_NUMBER): " MAX_UPLOAD_FILES_NUMBER
read -p "Enter upload file max size in megabyte (default: $DEFAULT_MAX_UPLOAD_FILE_SIZE): " MAX_UPLOAD_FILE_SIZE
read -p "Enter clamav scan timeout in seconds (default: $DEFAULT_CLAMD_TIMEOUT): " CLAMD_TIMEOUT
read -p "Use Nginx as proxy? (default: $USE_NGINX) [Y/N]: " USE_NGINX

#check user input and set default value if null
[ -z "$SERVER_NAME" ] && SERVER_NAME=$DEFAULT_SERVER_NAME
[ -z "$API_AUTH_KEY" ] && API_AUTH_KEY=$DEFAULT_API_AUTH_KEY
[ -z "$API_FORM_KEY" ] && API_FORM_KEY=$DEFAULT_API_FORM_KEY
[ -z "$MAX_UPLOAD_FILE_SIZE" ] && MAX_UPLOAD_FILE_SIZE=$DEFAULT_MAX_UPLOAD_FILE_SIZE
[ -z "$MAX_UPLOAD_FILES_NUMBER" ] && MAX_UPLOAD_FILES_NUMBER=$DEFAULT_MAX_UPLOAD_FILES_NUMBER
[ -z "$CLAMD_TIMEOUT" ] && CLAMD_TIMEOUT=$DEFAULT_CLAMD_TIMEOUT

#convert
BASE=1024
CLAMD_TIMEOUT=$(($CLAMD_TIMEOUT*60))
MAX_UPLOAD_FILE_SIZE_IN_MB=$MAX_UPLOAD_FILE_SIZE
MAX_UPLOAD_FILE_SIZE=$(($MAX_UPLOAD_FILE_SIZE*$BASE*$BASE))

#print
echo -e "______________________________________________________________________________________________"
echo -e "\n\t SERVER_NAME\t\t\t: $SERVER_NAME"
echo -e "\t API_AUTH_KEY\t\t\t: $API_AUTH_KEY"
echo -e "\t API_FORM_KEY\t\t\t: $API_FORM_KEY"
echo -e "\t MAX_UPLOAD_FILE_NUMBER\t\t: $MAX_UPLOAD_FILES_NUMBER"
echo -e "\t MAX_UPLOAD_FILE_SIZE\t\t: ${MAX_UPLOAD_FILE_SIZE_IN_MB}MB"
echo -e "\t CLAMD_TIMEOUT\t\t\t: ${CLAMD_TIMEOUT}ms\n"

#export env vars
export SERVER_NAME
export API_AUTH_KEY
export API_FORM_KEY
export MAX_UPLOAD_FILE_SIZE
export MAX_UPLOAD_FILES_NUMBER
export CLAMD_TIMEOUT
[[ $USE_NGINX =~ ^[Yy]$ ]] && export DOCKER_COMPOSE_TEMPLATE=docker-compose-with-nginx.tpl

#remove existing
rm ./nginx/conf.d/default.conf
rm ./docker-compose.yaml

#substitute 
sed -e "s|%%SERVER_NAME%%|$SERVER_NAME|g; s|%%MAX_FILE_SIZE%%|$MAX_UPLOAD_FILE_SIZE_IN_MB|g;" ./templates/nginx-default.tpl > ./nginx/conf.d/default.conf
envsubst < ./templates/$DOCKER_COMPOSE_TEMPLATE > ./docker-compose.yaml

#done
echo -e "\t" Configuration files are updated.
echo -e "______________________________________________________________________________________________"
echo -e "\nYou can run 'docker-compose up' now to spin up the containers!"
[[ $USE_NGINX =~ ^[Nn]$ ]] && echo -e "API will be serving at port 8080"
echo -e "______________________________________________________________________________________________"
