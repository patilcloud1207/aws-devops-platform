
FROM nginx:alpine

LABEL maintainer="Avinash Patil"
LABEL project="AWS DevOps Automation Platform"

COPY app/index.html /usr/share/nginx/html/index.html

EXPOSE 80
