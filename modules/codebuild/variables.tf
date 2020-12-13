variable "tags" {
  description = "Tags to apply to all AWS resources (with tagging support)"
  type        = map(string)
}

variable "iam-role-arn" {
  description = "IAM Role for CodeBuild"
  type        = string
}

variable "git-repo" {
    description = "GitHub Repo to use in CodeBuild"
    type = string
}

### Optional parameters
variable "log-bucket" {
  description = "(Optional) Bucket to store logs in"
  type        = string
  default     = null
}

