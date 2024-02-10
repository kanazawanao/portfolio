# Terraform でフロントエンドの構成管理

## 概要

terraform でフロントエンドのアプリを立ち上げる際に必要な GCP サービスや、github と GCP の連携部分を自動で構成します。
terraform は local で実行する前提になっています。

## 詳細

必要なもの
GCP のアカウント
GCP の、terraform を動かすためのサービスアカウントとアカウント key
github アカウントとリポジトリ
ドメイン

GCP 上にフロントエンドに必要なものを管理します。
DNS -> CDN -> load barancer -> Cloud Storage
SSL 証明書の発行、付与も自動で行われます。
外部でドメインを取得した場合は、作成された DNS の設定から NS の情報を設定してください。
github actions で gcs のバケットにアップロードするための設定も自動で行います。
github actions に必要な secrets 情報なども、自動で設定されます。

variables.tf に設定している情報は下記の通りです

- project_id: (gcp の projectid を設定)
- repo_name: github のリポジトリ名を設定
- github_owner: github のオーナー名を設定
- name: アプリ全体の名前を設定
- service_domain: 取得したドメイン名を設定
- credentials: GCP 上で作成した terraform 用のサービスアカウントの key を保存したファイルの場所を設定
- github_token: gh auth token で取得した値を設定

```sh
terraform init
terraform plan
terraform apply
terraform destroy
```

terraform.tfvars ファイルを作成して、`credentials` と `github_token` を追加
github token には以下の値を設定する

```sh
gh auth login
gh auth token
```

credentials には terraform のサービスアカウントキーを指定する

## 有効にする必要がある API

- Compute Engine API
- Identity and Access Management (IAM) API
- Cloud DNS API
- Cloud Resource Manager API
