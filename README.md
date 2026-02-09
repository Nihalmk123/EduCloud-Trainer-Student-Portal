# EduCloud - Trainer-Student Portal (Architecture)

This repository currently contains the **architecture diagrams** for the EduCloud Trainer-Student Secure File Portal.

## Contents

- `architecture/educloud-architecture.png` – High-level system architecture (Users → CloudFront → ALB → EC2 → NFS/FTP/RDS/Lambda → S3/Glacier)
- `architecture/vpc-diagram.drawio` – VPC network design (VPC, subnets, IGW, NAT, EC2, RDS)
- `architecture/flow-diagram.drawio` – Trainer/Student end-to-end flow (uploads, downloads, assignments, backups)

More folders (linux, aws, automation, frontend, etc.) will be added later.
