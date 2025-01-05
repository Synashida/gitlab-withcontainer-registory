# 目次

1. 初期環境構築
2. Runnerの登録
3. 参考資料

# 初期完了構築

## 初回起動時にSAN対応のSSLに変更してください。

./init-ssl-certificate-renew.sh
上記を実行するとSAN対応のSSLに書き換えし、再起動できます。

## 2回目以降の起動

1. docker-compose up -d
2. attach shellして、 less /etc/gitlab/initial_root_password し、初期パスワードを取得
3. https://gitlab.example.com:8929 にアクセスし、 ID: root / PW: 上記で取得したパスワード


## Gitlab Runnerの起動のために必要なSSL証明書の修正

### SNA対応の証明書作成

```
cd /etc/gitlab/ssl
cp gitlab.example.com.key gitlab.example.com.key.org 
cp gitlab.example.com.crt gitlab.example.com.crt.org

openssl req -newkey rsa:4096 -days 3650 -nodes -x509 -subj "/C=JP/ST=CHIBA/L=CHIBA/O=NAN/OU=NAN/CN=gitlab.example.com" -extensions v3_ca -config <( cat /opt/gitlab/embedded/ssl/openssl.cnf <(printf "[v3_ca]\nsubjectAltName='DNS:*.example.com,IP:173.0.0.10'")) -keyout gitlab.example.com.key -out gitlab.example.com.crt
```

# Runnerの登録

1. https://gitlab.example.com:8929/admin/runners でRunnerの新規作成
2. Gitlab Runnerの regist コマンドが表示されるので、レジストコマンドをコピー
3. docker-compose exec gitlab-runner /bin/bash でshellにログイン
4. 2でコピーしたレジストコマンドの実行
   1. Enter the GitLab instance URL (for example, https://gitlab.com/):
      [https://gitlab.example.com:8929]: ブランクのまま enter
   2. Enter a name for the runner. This is stored only in the local config.toml file:
      [7d324e5f527f]: /etc/gitlab-runner ←を入力してEnter
   3. Enter an executor: custom, ssh, parallels, virtualbox, docker, docker-windows, docker+machine, kubernetes, docker-autoscaler, shell, instance:
      docker ← を入力

以上で登録完了。

# 参考資料

証明書関連
https://blogs.networld.co.jp/entry/2022/03/01/090000
https://hermesian.hatenablog.com/entry/2018/05/03/235255
