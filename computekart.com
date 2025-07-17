server {
    server_name computekart.com;  # Your domain here

    # Optional root directory, if needed
    # root /var/www/html;

    location / {
        proxy_pass http://localhost:4000;  # Proxy to your backend app on port 4000
        proxy_set_header Host $host;  # Preserve original Host header
        proxy_set_header X-Real-IP $remote_addr;  # Preserve real client IP
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;  # Preserve forwarded headers
        proxy_set_header X-Forwarded-Proto $scheme;  # Preserve original protocol (HTTP/HTTPS)
    }

    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/computekart.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/computekart.com/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

}

server {
    if ($host = computekart.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


    listen 80;
    server_name computekart.com;
    return 404; # managed by Certbot


}
