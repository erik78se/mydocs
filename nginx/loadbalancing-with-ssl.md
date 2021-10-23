## /etc/nginx/sites-available/my-site.com

nginx config with loadbalancer ssl

```
server {
  listen 9966 ssl;
  server_name kusama-rpc.dwellir.com;
  ssl_certificate     /etc/ssl/my-cert.crt;
  ssl_certificate_key /etc/ssl/my-cert.key;

  proxy_connect_timeout 900;
  proxy_send_timeout 900;  
  proxy_read_timeout 900;

  location / {
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Host $host;

    proxy_pass http://ws-backend;

    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
  }
}

upstream ws-backend {
  # enable sticky session based on IP
  ip_hash;

  server my-server-1:9966;
  server my-server-1:9966;
}
```
