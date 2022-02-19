version: '3.7'
services:
  nginx:
    image: nginx:1.18.0-alpine
    restart: always
    container_name: nginx
    volumes:
      - ./nginx/errors:/var/www/errors:rw
      - ./nginx/conf.d:/etc/nginx/conf.d:rw
      - ./nginx/certbot/www:/var/www/certbot/:ro
      - ./nginx/certbot/conf/:/etc/nginx/ssl/:ro
    ports:
      - 80:80
      - 443:443
    networks:
      - clamav-network

  certbot:
    image: certbot/certbot:latest
    container_name: certbot
    volumes:
      - ./nginx/certbot/www/:/var/www/certbot/:rw
      - ./nginx/certbot/conf/:/etc/letsencrypt/:rw
      
networks:
  clamav-network:
    driver: bridge