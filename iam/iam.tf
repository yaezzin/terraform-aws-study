# IAM group definition
resource "aws_iam_group" "administrators" {
  name = "administrators"
}

# attatch policy to IAM group
resource "aws_iam_policy_attachment" "administrators-attach" {
  name       = "administrators-attach"
  groups     = [aws_iam_group.administrators.name]
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# user1
resource "aws_iam_user" "admin1" {
  name = "admin1"
}

# add user to IAM group
resource "aws_iam_group_membership" "administrators-users" {
  name = "administrators-users"
  users = [
      aws_iam_user.admin1.name
  ]
  group = aws_iam_group.administrators.name
}

# access key
resource "aws_iam_access_key" "admin1" {
  user = aws_iam_user.admin1.name
}

# crate permission
data "aws_iam_policy_document" "lb_ro" {
  statement {
    effect    = "Allow"
    actions   = ["ec2:Describe*"]
    resources = ["*"]
  }
}

# grant permission
resource "aws_iam_user_policy" "lb_ro" {
  name   = "tf-admin-test"
  user   = aws_iam_user.admin1.name
  policy = data.aws_iam_policy_document.lb_ro.json
}

# login profile
resource "aws_iam_user_login_profile" "example" {
  user = aws_iam_user.admin1.name
}

output "password" {
  value = aws_iam_user_login_profile.example.password
  sensitive = true
}