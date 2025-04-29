variable "bucket_name" {
  default = "csv-upload-bucket-demo4"
}

variable "table_name" {
  default = "CSVUploadTable"
}

variable "queue_name" {
  default = "csv-upload-cleanup-queue"
}

variable "secret_name" {
  default = "dynamodb-table-name-secret-new"
}
