## NGINX Proxy Configuration

[![GitHub](https://img.shields.io/badge/GitHub-romarcablao-lightgrey)](https://github.com/romarcablao)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-romarcablao-blue)](https://linkedin.com/in/romarcablao)

### Create and Setup SSL Certificate using LetsEncrypt

1. Visit [LetsEncrypt](https://letsencrypt.org/) and install [CertBot](https://certbot.eff.org/).

2. Follow along the steps and guide provided [here](https://certbot.eff.org/lets-encrypt/pip-nginx).

3. Once the request is validated, the following files will be created/generated: `cert.pem`, `chain.pem`, `fullchain.pem`, `privkey.pem`.

4. Use `fullchain.pem` and `privkey` for nginx SSL configuration.

```bash
    listen 443 ssl;
    server_name clamav.<your_domain>.com;
    ssl_certificate /etc/nginx/certs/fullchain.pem;
    ssl_certificate_key /etc/nginx/certs/privkey.pem;
```

5. If you dont want to serve the api on port 443 (HTTPS), you may opt using the port 80(HTTP) in serving the rest api. Simply update the ports in the `docker-compose.yaml` and nginx `default.conf`.
