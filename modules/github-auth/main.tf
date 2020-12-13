# A shared secret between GitHub and AWS that allows AWS
# CodePipeline to authenticate the request came from GitHub.
# Would probably be better to pull this from the environment
# or something like SSM Parameter Store.
locals {
  webhook_secret = "super-secret"
}

resource "aws_codepipeline_webhook" "pipe-hook" {
  name            = format("%s-webhook", var.pipeline-name)
  authentication  = "GITHUB_HMAC"
  target_action   = "Source"
  target_pipeline = var.pipeline-id

  authentication_configuration {
    secret_token = local.webhook_secret
  }

  filter {
    json_path    = "$.ref"
    match_equals = "refs/heads/{Branch}"
  }
}

# Wire the CodePipeline webhook into a GitHub repository.
resource "github_repository_webhook" "git-hook" {
  repository = var.github-repo

  name = "web"

  configuration {
    url          = aws_codepipeline_webhook.pipe-hook.url
    content_type = "json"
    insecure_ssl = true
    secret       = local.webhook_secret
  }

  events = ["push"]
}