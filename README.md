<h1 id="home">Devops Technical Assessment</h1>
 This project demonstrates DevOps and SRE practices using a Django web application with PostgreSQL database. It includes containerization, infrastructure as code, CI/CD pipeline, monitoring, and configuration management.

 The below sections will act as documentation of how the tasks were handled.

 ## Project Structure
 ```
 .
 |- core/                   # Django Application
 |- .github/workflows/      # Github Actions CI/CD Pipeline
 |- IaC/                    # Infrastructure as Code
 |- ansible/                # Configuration Management
 |- prometheus/             # Monitoring Configuration
 |- compose.yml             # Local Development Setup
 |- Dockerfile              # Containerization
 ```

 ## Table of Content
 1. [Project Overview](#home)
 2. [Django Application Setup](#django-app)
 3. [Containerization](#container)
 4. [Infrastucture as Code](#iac)
 5. [CI/CD Pipeline with Github Actions](#ci-cd)
 6. [Application Monitoring](#prom)
 7. [Ansible Configuration Management](#ansible)


 <h2 id="django-app">Django Application Setup</h2>
 <p>The goal of this task was to create a Git repository for the Django application that includes a simple web application. The repository was required to have commits with clear and descriptive messages and be pushed to GitHub</p>
 <p>Developed a Django application with a Postgres Database. The application was a library API that was to handle CRUD on books and author in the library.</p>


 <h2 id="container">Containerization</h2>
 <p>This task involved containerizing a Django web application using Docker and Docker Compose.</p>

 - Dockerfile: Created Dockerfile to define the base image, install necessary dependencies, copy the application code, set the working directory, and expose the necessary port (8000 for the Django development server).
 - Docker Compose: A docker-compose.yml file was created to orchestrate the application and its dependencies.
  It defined two services:
    - web: This service utilized the Dockerfile to build the application image.
    - db: This service used a pre-built PostgreSQL image from Docker Hub. <br>
    
    The docker-compose.yml file also defined a volume configuration to enable persistent storage of the data in the postgres database.


<h2 id="iac">Infrastructure as Code</h2>
<p><strong>Objective</strong>:

This task involved provisioning a basic cloud infrastructure using Terraform. 
I chose Terraform due to its extensive provider support, and strong community it has ensued over time. The objective was to define and deploy the following resources:

- Virtual Machine Instance: A virtual machine instance in the chosen cloud provider.
- Networking Components: A Virtual Private Cloud (VPC) and subnets to isolate the virtual machine and enhance security.
- Security Configuration: An appropriate security group to allow only HTTP and HTTPS traffic to the instance.
- Static IP Address: A static IP address associated with the virtual machine for consistent access.

Wrote Terraform code to define the following resources:
- VPC: Created a VPC with a defined CIDR block.
- Subnet: Created a public subnet within the VPC.
- Internet Gateway: Created an Internet Gateway and attached it to the VPC.
- Route Table: Created a route table to enable internet access for the subnet.
- Security Group: Created a security group with rules to allow incoming traffic on ports 80 (HTTP) and 443 (HTTPS) and outgoing traffic on all ports.
- EC2 Instance: Launched an EC2 instance in the specified subnet, associated with the security group.
- Elastic IP: Allocated an Elastic IP and associated it with the EC2 instance.
</p>


<h2 id="ci-cd">CI/CD Pipeline With GitHub Actions</h2>
<p><strong>Objective</strong>:

The objective of this task was to create a CI/CD pipeline to automate the build, deployment, and management of a containerized application.

Approach used:
- CI/CD Tool: GitHub Actions was chosen due to its seamless integration with GitHub repositories and its ease of use.
- Containerization: The application was containerized using Docker and pushed to Docker Hub.
- Deployment Target: The application was deployed to an EC2 instance.
- Infrastructure Provisioning: Terraform was used to provision the EC2 instance and associated infrastructure (VPC, subnets, security groups).

Challenges faced:
- Multi-Container Deployment: Deploying a multi-container application (using Docker Compose) to the EC2 instance required additional steps. This involved:
  - Transferring the docker-compose.yml file to the EC2 instance using scp (Secure Copy)
  - Installing Docker Compose on the EC2 instance.
- Security: Ensuring secure handling of sensitive information like SSH keys and AWS credentials. This was addressed by storing these credentials as secrets within the GitHub repository.
</p>

<h2 id="prom">Application Monitoring</h2>
<p><strong>Objective</strong>:

This task aimed to implement basic Site Reliability Engineering (SRE) principles by establishing monitoring and ensuring the reliability of the Django application.


**Monitoring Tool Selection**: Prometheus and Grafana were chosen as the monitoring stack.

**Application Metrics**: The application was instrumented to expose key metrics such as:
- Request latency (response time)
- Request throughput (requests per second)
- Error rates
- New Postgres connections

**System Metrics**: Collected system-level metrics, including:
- CPU usage
- Memory usage
- Disk space usage
- Network traffic


Challenges:
- Prometheus Configuration: Configuring Prometheus to effectively scrape metrics from different sources and store them efficiently.
- Grafana Dashboard Design: Designing effective dashboards that provide clear and actionable insights into application performance.
</p>

<h2 id="ansible">Configuration Management with Ansible</h2>
<p><strong>Objective</strong>:

This task involved utilizing Ansible to configure the Virtual Machine (VM) provisioned in Task 3 with the following:

- File Transfer: Copy a configuration file (config.txt) from the local machine to the server's /opt/ directory with restricted access (read/write for users in the 'devops' group).
- Software Installation: Install PostgreSQL and Nginx.
- Service Management: Ensure PostgreSQL and Nginx services are enabled and running.

Created Ansible playbook and utilized Ansible modules such as copy, apt, and service to achieve the desired configurations.

Managed the target server (EC2 instance provisioned in task 3) in the hosts file.

</p>