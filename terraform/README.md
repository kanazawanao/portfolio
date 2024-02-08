```
terraform init
terraform plan
terraform apply
terraform destroy
```

terraform.tfvars ファイルを作成して、`credentials` と `github_token` を追加
github token には以下の値を設定する

```
brew install gh
gh auth login
gh auth token
```

credentials には terraform のサービスアカウントキーを指定する
