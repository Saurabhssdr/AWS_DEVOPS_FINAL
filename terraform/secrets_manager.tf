resource "aws_secretsmanager_secret" "table_secret" {
  name = var.secret_name
}

resource "aws_secretsmanager_secret_version" "secret_version" {
  secret_id     = aws_secretsmanager_secret.table_secret.id
  secret_string = jsonencode({
    table_name = var.table_name
  })
}
