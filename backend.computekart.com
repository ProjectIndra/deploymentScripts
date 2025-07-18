server {
    server_name backend.computekart.com;

    location / {
        proxy_pass http://localhost:5000;  # Proxy to backend running on port 5000
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    listen 443 ssl;
    ssl_certificate /etc/letsencrypt/live/backend.computekart.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/backend.computekart.com/privkey.pem;
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;
}

server {
    if ($host = backend.computekart.com) {
        return 301 https://$host$request_uri;
    }

    listen 80;
    server_name backend.computekart.com;
    return 404;
}
