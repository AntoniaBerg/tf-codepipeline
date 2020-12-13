locals {
  pipeline-name = "tf-test-pipeline"
}

resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket_prefix = "artifact-bucket"
  acl           = "private"
}

data "aws_kms_alias" "s3kmskey" {
  name = "alias/demoKey"
}

resource "aws_iam_role" "codepipeline_role" {
  name               = "codepipeline-role"
  assume_role_policy = file("${path.module}/policies/codepipeline-iam-role.json")
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name   = "codepipeline_policy"
  role   = aws_iam_role.codepipeline_role.id
  policy = templatefile("${path.module}/policies/codepipeline-iam-policy.json", { TF_BUCKET = aws_s3_bucket.codepipeline_bucket.arn })
}

resource "aws_codepipeline" "codepipeline" {
  name     = local.pipeline-nname
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"

    encryption_key {
      id   = data.aws_kms_alias.s3kmskey.arn
      type = "KMS"
    }
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["gitHubRepo"]

      configuration = {
        Owner  = "my-organization"
        Repo   = "test"
        Branch = "master"
      }
    }
  }

  stage {
    name = "Plan"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["gitHubRepo"]
      version          = "1"
      output_artifacts = ["terraformPlan"]

      configuration = {
        ProjectName = "test"
      }
    }
  }

  stage {
    name = "Approval"
    action {
      category = "Approval"
      owner    = "AWS"
      version  = "1"
      provider = "Manual"
    }
  }

  stage {
    name = "Apply"

    action {
      name            = "Build"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["terraformPlan"]
      version         = "1"

      configuration = {
        ProjectName = "test"
      }
    }
  }

}

module "github-auth" {
  source        = "./modules/github-auth"
  github-repo   = var.github-repo
  github-branch = var.github-branch
  pipeline-name = local.pipeline-name
  pipeline-id   = aws_codepipeline.codepipeline.id
}