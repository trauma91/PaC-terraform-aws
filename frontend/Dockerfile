### Stage Build ###
FROM node:10-alpine AS builder
WORKDIR /home/node/app
COPY . .

RUN npm install
RUN npm install -g @angular/cli
RUN ng build

### Stage Serve ###
FROM nginx
COPY --from=builder --chown=nginx:nginx /home/node/app/dist/empamini /usr/share/nginx/html
COPY --from=builder --chown=nginx:nginx /home/node/app/nginx.conf /etc/nginx/nginx.conf
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log
STOPSIGNAL SIGTERM