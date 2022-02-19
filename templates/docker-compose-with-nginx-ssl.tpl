version: '3.7'
services:
  clamav:
    image: $CLAMAV_IMAGE
    restart: always
    container_name: clamav
    networks:
      - clamav-network

  clamav-api:
    image: $CLAMAV_API_IMAGE
    restart: always
    environment:
      NODE_ENV: production
      APP_PORT: 8080
      APP_MORGAN_LOG_FORMAT: combined
      CLAMD_IP: clamav
      CLAMD_PORT: 3310
      APP_FORM_KEY: $API_FORM_KEY
      APP_MAX_FILE_SIZE: $MAX_UPLOAD_FILE_SIZE
      APP_MAX_FILES_NUMBER: $MAX_UPLOAD_FILES_NUMBER
      CLAMD_TIMEOUT: $CLAMD_TIMEOUT
      AUTHTOKEN: $API_AUTH_KEY
      REDIRECT_URL: null
    container_name: clamav-api
    networks:
      - clamav-network
    depends_on:
      - clamav

  nginx:
    image: nginx:1.18.0-alpine
    restart: always
    container_name: clamav-proxy
    volumes:
      - ./nginx/errors:/var/www/errors
      - ./nginx/conf.d:/etc/nginx/conf.d
      - ./nginx/certbot/www:/var/www/certbot/:ro
      - ./nginx/certbot/conf/:/etc/nginx/ssl/:ro
    ports:
      - 80:80
      - 443:443
    networks:
      - clamav-network
    depends_on:
      - clamav
      - clamav-api

  certbot:
    image: certbot/certbot:latest
    container_name: certbot
    volumes:
      - ./nginx/certbot/www/:/var/www/certbot/:rw
      - ./nginx/certbot/conf/:/etc/letsencrypt/:rw

networks:
  clamav-network:
    driver: bridge