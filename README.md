# Terraform Provisioners Project – AWS EC2 Flask Application Deployment

## Project Overview

This project demonstrates how to use Terraform Provisioners to automate AWS infrastructure provisioning and deploy a Python Flask application on an Ubuntu EC2 instance.

In this project, I used:
- **File Provisioner** to transfer the Flask application from my local machine to EC2.
- **Remote-Exec Provisioner** to install dependencies and start the Flask application remotely.
- **SSH Connection** to connect Terraform to the EC2 instance.

## Project Architecture

Local Machine → Terraform → AWS VPC → Public Subnet → EC2 Instance → File Provisioner → Remote-Exec Provisioner → Flask Application

## Technologies Used

- Terraform
- AWS EC2
- AWS VPC
- AWS Subnet
- Internet Gateway
- Route Table
- Security Group
- Ubuntu Linux
- Python
- Flask
- SSH
- Git and GitHub

---

## Project Implementation – Step by Step

### Step 1: Project Folder Structure

Created the project folder with Terraform configuration, Flask application, README, Git ignore file, and screenshots.

**Screenshot:**

![Project Folder Structure](screenshots/01-project-structure.png)

### Step 2: Terraform Configuration

Configured the AWS provider and infrastructure resources, including VPC, public subnet, Internet Gateway, route table, security group, key pair, and EC2 instance.

**Screenshot:**

![Terraform Configuration](screenshots/02-terraform-configuration.png)

### Step 3: Flask Application

Created a Python Flask application to display a success message when accessed through a web browser.

**Screenshot:**

![Flask Application](screenshots/03-flask-application.png)

### Step 4: Terraform Initialization

Initialized the Terraform working directory and downloaded the required AWS provider.

**Command:**

```bash
terraform init
```

**Screenshot:**

![Terraform Initialization](screenshots/04-terraform-init.png)

### Step 5: Terraform Validation

Validated the Terraform configuration to check for syntax and configuration errors.

**Command:**

```bash
terraform validate
```

**Screenshot:**

![Terraform Validation](screenshots/05-terraform-validate.png)

### Step 6: Terraform Plan

Reviewed the execution plan to understand which AWS resources Terraform would create.

**Command:**

```bash
terraform plan
```

**Screenshot:**

![Terraform Plan](screenshots/06-terraform-plan.png)

### Step 7: Terraform Apply

Applied the Terraform configuration to create AWS infrastructure and deploy the application.

**Command:**

```bash
terraform apply
```

**Screenshot:**

![Terraform Apply](screenshots/07-terraform-apply.png)

### Step 8: AWS EC2 Instance Creation

Verified that the EC2 instance was successfully created in the AWS Management Console.

**Screenshot:**

![AWS EC2 Instance](screenshots/08-aws-ec2-instance.png)

### Step 9: File Provisioner

Used the Terraform File Provisioner to transfer the local `app.py` file to the EC2 instance.

**Terraform Configuration:**

```hcl
provisioner "file" {
  source      = "app.py"
  destination = "/home/ubuntu/app.py"
}
```

**Screenshot:**

![File Provisioner](screenshots/09-ec2-file-transfer.png)

### Step 10: Remote-Exec Provisioner

Used the Remote-Exec Provisioner to execute commands remotely on the EC2 instance.

Tasks performed:

- Updated Ubuntu packages.
- Installed Python and pip.
- Created a Python virtual environment.
- Installed Flask.
- Started the Flask application.

**Screenshot:**

![Remote-Exec Provisioner](screenshots/10-remote-exec-installation.png)

### Step 11: Flask Application in Browser

Accessed the deployed Flask application using the EC2 instance's public IPv4 address.

**Application URL:**

```text
http://<EC2-PUBLIC-IP>
```

**Screenshot:**

![Flask Application in Browser](screenshots/11-application-browser.png)

### Step 12: Application Verification

Verified that the Flask application was running successfully on the EC2 instance.

**Command:**

```bash
curl http://localhost
```

**Expected Output:**

```text
Hello, Irfan This Terraform Project is deployed and created Successfully!
```

**Screenshot:**

![Application Verification](screenshots/12-application-verification.png)

---

## AWS Resources Created

| AWS Resource | Purpose |
|---|---|
| VPC | Creates an isolated AWS network |
| Public Subnet | Hosts the EC2 instance |
| Internet Gateway | Provides internet connectivity |
| Route Table | Routes internet traffic |
| Route Table Association | Associates the route table with the subnet |
| Security Group | Controls inbound traffic |
| Key Pair | Enables SSH authentication |
| EC2 Instance | Hosts the Flask application |

## Terraform Provisioners Used

### 1. File Provisioner
Transfers application files from the local machine to the remote EC2 instance.

### 2. Remote-Exec Provisioner
Executes remote commands over SSH to install dependencies and start the Flask application.

### 3. Connection Block
Establishes SSH connectivity between Terraform and the EC2 instance.

## Key Learnings

- Provisioning AWS infrastructure using Terraform.
- Understanding Terraform File Provisioners.
- Executing remote commands using Remote-Exec Provisioners.
- Configuring SSH connections to EC2 instances.
- Deploying Python Flask applications on Ubuntu.
- Automating application deployment.

## Security Considerations

- Never upload private SSH keys to GitHub.
- Never upload Terraform state files.
- Keep AWS credentials secure.
- Restrict SSH access to trusted IP addresses instead of allowing unrestricted access.

## Cleanup

To destroy the AWS resources created by this project, run:

```bash
terraform destroy
```

Confirm the operation when prompted.

## Author
**Irfan Ahmad**  
DevOps Engineer

**Project:** Terraform Provisioners – AWS EC2 Flask Application Deployment

---
