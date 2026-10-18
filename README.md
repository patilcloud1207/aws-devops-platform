

\# AWS DevOps Automation Platform



\## Overview

A hands-on cloud and DevOps portfolio project demonstrating containerized web hosting and a foundation for automated deployment on AWS.



\## Current Features

\- Static web application using HTML and CSS

\- Docker image built using Nginx Alpine

\- Containerized web hosting

\- Local access through port 8080

\- Git version control



\## Technology Stack

\- Docker

\- Nginx

\- Git

\- HTML and CSS

\- AWS and Terraform (planned)

\- Jenkins CI/CD (planned)



\## Run Locally



Build the Docker image:



```bash

docker build -t aws-devops-platform:v1 .

```



Start the container:



```bash

docker run -d --name aws-devops-web -p 8080:80 aws-devops-platform:v1

```



Open http://localhost:8080



\## Roadmap

1\. Add a container health check.

2\. Add Docker Compose.

3\. Publish the source to GitHub.

4\. Implement Jenkins CI/CD.

5\. Provision AWS infrastructure with Terraform.

6\. Add monitoring and security scanning.



\## Author

Avinash Patil



