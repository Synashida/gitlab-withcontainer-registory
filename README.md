起動方法

1. docker-compose up web
2. attach shellして、 less /etc/gitlab/initial_root_password し、初期パスワードを取得
3. https://gitlab.example.com:8929 にアクセスし、 ID: root / PW: 上記で取得したパスワード

