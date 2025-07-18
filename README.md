# 📄 AWS CSV Processing System
 
## 📝 Description
 
A fully **serverless data pipeline** on AWS that automates:
 
- 📤 Uploading CSV files via **API Gateway**
- 📊 Parsing and storing records in **DynamoDB**
- 🧹 Cleaning up uploaded files post-processing
 
Provisioned entirely using **Terraform** as Infrastructure as Code (IaC).
 ## 🧭 How It Works (Architecture Overview)
 
### 🟩 API Gateway
- Receives file uploads from **Postman** or any client.
 
### 🟨 Lambda
- `api-handler` Lambda:
  - Uploads the received CSV to **S3**
- `s3-trigger` Lambda:
  - Reads CSV file from **S3**
  - Fetches **DynamoDB** table name from **Secrets Manager**
  - Parses and stores data into **DynamoDB**
  - Sends a **120-second delayed message** to **SQS**
- `sqs-trigger` Lambda:
  - Deletes the original CSV from **S3** after the delay
 
### 🟦 S3
- Stores uploaded CSV files
- Triggers `s3-trigger` Lambda on `PutObject` event
 
### 🟧 DynamoDB
- Stores structured records parsed from CSV
 
### 🟥 SQS
- Serves as a delay queue
- Triggers cleanup Lambda after 120 seconds
 
### 🟪 Secrets Manager
- Securely stores the DynamoDB table name, accessed by Lambda
 
### ⚙️ CloudWatch
- Captures logs of all Lambda executions for monitoring and debugging
 
---
 
## 🧰 AWS Services Used
 
- **Lambda** (3 functions: `api-handler`, `s3-trigger`, `sqs-trigger`)
- **API Gateway**
- **Amazon S3**
- **Amazon DynamoDB**
- **Amazon SQS**
- **AWS Secrets Manager**
- **Amazon CloudWatch**
- **Terraform** (for Infrastructure as Code)
 
---
 
## 🚀 How to Deploy (Getting Started)
 
### 1. Clone the Repo
```bash
git clone https://github.com/Saurabhssdr/aws-csv-processing-system.git
cd aws-csv-processing-system
```
 
### 2. Configure AWS CLI
```bash
aws configure
```
 
Ensure you have the appropriate IAM permissions.
 
### 3. Initialize Terraform
```bash
terraform init
```
 
### 4. Deploy Infrastructure
```bash
terraform apply
```
 
🔧 This command provisions all required AWS resources:
- Lambda functions
- API Gateway
- S3 bucket
- DynamoDB table
- SQS queue
- Secrets Manager entry
- IAM roles
 
### 5. Upload CSV via Postman
- Use a `POST` request to the generated **API Gateway endpoint**
- Upload a `.csv` file as **form-data**
 
---
 
## 📬 Output
 
- ✅ Records from CSV inserted into **DynamoDB**
- 🗑️ CSV file deleted from **S3** after 120 seconds
- 📄 Execution logs available in **CloudWatch**
 
