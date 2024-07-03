#!/bin/bash

WATCHED_DIR="./app/models"

# fswatchでディレクトリを監視し、変更があったらrbs-inlineコマンドを実行
fswatch -0 "$WATCHED_DIR" | while read -d "" event
do
    echo "Change detected in: $event"
    docker compose exec -T app bundle exec rbs-inline --output app
done
