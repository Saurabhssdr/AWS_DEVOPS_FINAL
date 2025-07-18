📄 AWS CSV Processing System
📝 Description
A fully serverless data pipeline on AWS that automates:
 
📤 Uploading CSV files via API Gateway
 
📊 Parsing and storing data in DynamoDB
 
🧹 Cleaning up files post-processing
Provisioned entirely using Terraform as Infrastructure as Code (IaC).
 
🧭 How It Works (Architecture Overview)
🟩 API Gateway
Receives file uploads from Postman or other clients.
 
🟨 Lambda
 
api-handler Lambda: Uploads the CSV to S3.
 
s3-trigger Lambda:
 
Reads uploaded CSV from S3
 
Fetches DynamoDB table name from Secrets Manager
 
Parses data and inserts into DynamoDB
 
Sends delayed message to SQS (120s)
 
sqs-trigger Lambda:
 
Deletes CSV file from S3 after delay
 
🟦 S3
Stores uploaded CSVs and triggers Lambda on file upload.
 
🟧 DynamoDB
Stores structured data extracted from CSV.
 
🟥 SQS
Acts as a delay queue before triggering cleanup Lambda.
 
🟪 Secrets Manager
Securely stores DynamoDB table name accessed by Lambda.
 
⚙️ CloudWatch
Logs all Lambda executions for monitoring and debugging.
 
🧰 AWS Services Used
Lambda (api-handler, s3-trigger, sqs-trigger)
 
API Gateway
 
Amazon S3
 
Amazon DynamoDB
 
Amazon SQS
 
AWS Secrets Manager
 
Amazon CloudWatch
 
Terraform (Infrastructure as Code)
 
🚀 How to Deploy (Getting Started)
Clone the Repo
 
bash
Copy code
git clone https://github.com/Saurabhssdr/aws-csv-processing-system.git

cd aws-csv-processing-system
Configure AWS CLI
Make sure AWS CLI is configured with appropriate IAM permissions:
 
bash
Copy code
aws configure
Initialize Terraform
 
bash
Copy code
terraform init
Deploy Infrastructure
 
bash
Copy code
terraform apply
🔧 This will create all necessary AWS resources:
 
Lambda functions
 
API Gateway
 
S3 bucket
 
DynamoDB table
 
SQS queue
 
Secrets Manager entry
 
IAM roles
 
Upload CSV via Postman
 
Use POST request to the API Gateway endpoint
 
Upload .csv file as form-data
 
📬 Output
✅ CSV data stored in DynamoDB
 
🗑️ CSV file deleted from S3 after 120 seconds
 
📄 Logs available in CloudWatch
 
