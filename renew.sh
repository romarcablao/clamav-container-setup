export DATE=$(date +'%m/%d/%Y %H:%M')
echo $DATE >> /certbot-renew-cron.log
docker-compose run --rm certbot renew >> /certbot-renew-cron.log