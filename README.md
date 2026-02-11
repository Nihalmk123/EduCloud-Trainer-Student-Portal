# EduCloud – Trainer-Student Secure File Portal

EduCloud is a cloud-based platform designed to securely manage
training materials and assignment workflows between trainers
and students using AWS cloud infrastructure.

The project focuses on secure file handling, scalability,
automation, and network isolation, following real-world
cloud architecture best practices.


---

## Project Objective

The objective of the EduCloud project is to:

- Provide a secure platform for trainers to upload study materials
- Enable students to submit assignments safely
- Implement scalable and highly available AWS infrastructure
- Demonstrate real-world cloud concepts such as VPC design,
  Auto Scaling, Load Balancing, and automation using AWS services


---

## Architecture Overview

The system follows a layered cloud architecture.

User Flow:
Users → CloudFront → Application Load Balancer → EC2 (Private Subnet)

Backend & Storage:
EC2 → NFS / FTP / RDS → S3 → Glacier (Lifecycle & Backup)

Automation:
S3 Upload Event → AWS Lambda → Notifications / Logging

This architecture ensures:
- High availability
- Secure access paths
- Scalability
- Cost optimization


---

## Repository Structure

EduCloud-Trainer-Student-Portal/
│
├── README.md
│
├── architecture/
│ ├── educloud-architecture.png
│ ├── vpc-diagram.drawio
│ └── flow-diagram.drawio
│
├── linux/
│ ├── users-groups/
│ ├── permissions-acl/
│ ├── cron-jobs/
│ ├── storage/
│ ├── file-sharing/
│ └── logs/
│
├── aws/
│ ├── iam/
│ ├── s3/
│ ├── ec2/
│ ├── alb-asg/
│ ├── cloudfront/
│ ├── rds/
│ └── vpc/
│
├── automation/
│ └── lambda/
│
├── frontend/
│ ├── index.html
│ ├── upload.html
│ └── submit_assignment.html
│
├── screenshots/
│ ├── linux/
│ ├── aws/
│ └── demo/
│
├── report/
│ ├── EduCloud_Project_Report.pdf
│ └── step_by_step_implementation.docx
│
└── demo/
├── live_url.txt
└── demo_video_link.txt



---

## Architecture Diagrams

1. High-Level Architecture  
   - File: architecture/educloud-architecture.png  
   - Shows end-to-end system flow from users to storage and automation

2. VPC Design  
   - File: architecture/vpc-diagram.drawio  
   - Includes VPC, public & private subnets, IGW, NAT Gateway, EC2, and RDS

3. Flow Diagram  
   - File: architecture/flow-diagram.drawio  
   - Covers trainer uploads, student submissions, and backup workflows


---

## AWS Services Used

- Amazon VPC
- Amazon EC2
- Application Load Balancer (ALB)
- Auto Scaling Group (ASG)
- Amazon S3 & Glacier
- Amazon RDS (MySQL)
- AWS Lambda
- Amazon CloudFront
- AWS IAM


---

## Frontend Overview

The frontend consists of static HTML pages served using CloudFront.

- index.html – Landing page
- upload.html – Trainer material upload page
- submit_assignment.html – Student assignment submission page

These pages integrate securely with backend AWS services.


---

## Security Highlights

- Private subnets for application and database layers
- Controlled outbound access using NAT Gateway
- IAM roles for EC2, Lambda, and S3
- No direct public access to storage resources
- HTTPS delivery via CloudFront


---

## Demo & Live Access

- Live Application URL: demo/live_url.txt
- Demo Video: demo/demo_video_link.txt

The demo includes:
- Architecture explanation
- GitHub repository walkthrough
- Live application access
- Automation and security flow


---

## Documentation

- EduCloud_Project_Report.pdf – Final project report
- step_by_step_implementation.docx – Detailed implementation guide


---

## Project Status

- Core architecture completed
- Documentation finalized
- Live demo available
- Enhancements may be added in future updates


---

## Author

Mohammed Nihal Makandar  
Cloud Computing & AWS Trainee


---

## Note

This project is developed as part of course completion
and is intended for academic evaluation, demonstration,
and learning purposes.
