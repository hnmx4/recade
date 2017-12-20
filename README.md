# recade

DNSレコードをYAMLコードで管理するツール（PowerDNSのMySQLバックエンド向け）

<!-- ## Preparation -->

<!-- ``` -->
<!-- cd recade -->
<!-- cp .env.example .env -->
<!-- ``` -->

<!-- ## Installation -->

<!-- 環境変数を設定する -->

<!-- - `RECADE_SECRET_FILE` -->
<!--   - `secret.yml.enc`のファイルパス -->

<!-- - `RECADE_SECRET_PASSWORD` -->
<!--   - secret.ymlを暗号化/復号するためのパスワード -->

<!-- - `RECADE_SSH_CONFIG` -->
<!--   - `~/.ssh/config`など -->

<!-- ## Usage -->

<!-- DNSサーバに登録されているレコードをyaml形式で出力する -->
<!-- ``` -->
<!-- bundle exec recade dump <hostname> -->
<!-- ``` -->

<!-- records.ymlをDNSサーバに同期させる -->
<!-- ``` -->
<!-- bundle exec recade sync <hostname> <records.yml file path> -->
<!-- ``` -->

<!-- ## How to write records.yml -->

<!-- Following sample: -->

<!-- ``` -->
<!-- # id                    INT AUTO_INCREMENT, -->
<!-- # domain_id             INT DEFAULT NULL, -->
<!-- # name                  VARCHAR(255) DEFAULT NULL, -->
<!-- # type                  VARCHAR(10) DEFAULT NULL, -->
<!-- # content               VARCHAR(64000) DEFAULT NULL, -->
<!-- # ttl                   INT DEFAULT NULL, -->
<!-- # prio                  INT DEFAULT NULL, -->
<!-- # change_date           INT DEFAULT NULL, -->
<!-- # disabled              TINYINT(1) DEFAULT 0, -->
<!-- # ordername             VARCHAR(255) BINARY DEFAULT NULL, -->
<!-- # auth                  TINYINT(1) DEFAULT 1, -->

<!-- - domain_id: 1 -->
<!--   name: hoge.jp -->
<!--   type: A -->
<!--   content: 192.168.11.1 -->
<!--   ttl: 1111 -->
<!-- ``` -->

<!-- `spec/fixtures`にテスト用のレコードファイルがあるので、参考にしてください。 -->
