server {
    listen 80;
    listen [::]:80;

    server_name %%SERVER_NAME%%;
    server_tokens off;

    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }

    location / {
        return 301 https://%%SERVER_NAME%%$request_uri;
    }
}

server {
    listen 443 ssl;

    server_name %%SERVER_NAME%%;
    server_tokens off;

    ssl_certificate /etc/nginx/ssl/live/%%SERVER_NAME%%/fullchain.pem;
    ssl_certificate_key /etc/nginx/ssl/live/%%SERVER_NAME%%/privkey.pem;

    client_max_body_size %%MAX_FILE_SIZE%%M;

    location / {
        proxy_pass http://clamav-api:8080;
        proxy_redirect   off;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Host $server_name;
        proxy_set_header X-Forwarded-Proto https;
    }

    error_page 413 /413.json;
    location = /413.json {
        root   /var/www/errors;
    }

    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }
}
