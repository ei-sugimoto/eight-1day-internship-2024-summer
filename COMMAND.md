# コンテナにログインしたい
```console
$ docker compose exec app /bin/bash
```

# rails cしたい
```console
$ docker compose exec app rails c
```

# ログを確認したい
```console
$ docker compose logs app
# オプション指定で新しいログを出力し続けることができます
$ docker compose logs app -f
```

# MySQLをターミナルで開きたい
```console
$ docker compose exec app rails db -p
# こんな感じでSQLが書けます
MySQL [app_development]> SELECT * FROM cards;
```

## 脆弱性診断をしたい
```console
$ docker compose exec app brakeman
# オプション指定もできます
$ docker compose exec app brakeman -q --color
```

# rubyのコードをフォーマットしたい
```console
$ docker compose exec app rubocop -a
```

# TypeScriptのコードをフォーマットしたい
```console
$ docker compose exec app yarn --cwd front format
```
