
FROM nginx:alpine

LABEL maintainer="Avinash Patil"
LABEL project="AWS DevOps Automation Platform"

COPY app/index.html /usr/share/nginx/html/index.html

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -q --spider http://127.0.0.1/ || exit 1
