server {
    listen 80;
    listen [::]:80;

    server_name %%SERVER_NAME%%;
    server_tokens off;

    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
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
