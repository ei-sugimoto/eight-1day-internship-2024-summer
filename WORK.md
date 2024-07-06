# 1dayインターン当日課題資料

## まずは最初に
- 開発環境の構築ができていない人は[README.md](README.md)の手順で構築しましょう.
- 最新版のGoogle Chromeで動作チェックを行ってください.
- 不明な点がある方はメンターに声をかけてください.

## 初期状態
環境構築が完了していると以下のような状態になっているかと思います.
- 名刺が5枚表示されている.
- 名刺のデータと画像はすでにストレージに入っている.

## ストレージについて
名刺画像の保存先は minio というストレージを使用しています.\
この minio は AWS S3 と互換性のあるサービスで画像の取得・保存・削除などの操作をすることができます.\
本番環境では S3 を使っており, local 環境で同様のことをしたいときに便利です.\
今回の名刺画像は `cards` というバケットに `{card_id}` で名刺画像オブジェクトが保存されています.\

バケットの中身を覗いてみたい人は http://localhost:9003 にアクセスしてみましょう.\
[compose.yml](compose.yml) に記載されている `MINIO_ROOT_USER` と `MINIO_ROOT_PASSWORD` でログインできます。

## 課題の進め方
- 基本は一人で作業しましょう.
- フロントエンドとサーバーサイドの課題がありますが、どちらから進めても問題ありません.
- 問題に関係するコードに近くに問題番号が書いてあるので参考にしてください.
- 各課題が完了したらメンターの人にチェックしてもらってください.
- push しなくても大丈夫です.

## フロントエンド課題

- ライブラリの追加はせずに自前で実装しましょう
- VSCodeを使う場合、フロントエンドの開発時にはfrontのディレクトリでエディタを開くと便利です。

### React_Q1 名刺画像を表示しよう

- [AsyncCardImage](front/src/components/AsyncCardImage.tsx)に名刺画像を表示させましょう
  - 人物に紐づく最後の名刺画像を表示しましょう
  - 名刺画像を取得するAPIは [cards.ts](front/src/apis/cards.ts) に定義されています
- 画像のアスペクト比は 横 600 x 縦 380 です。この比率が崩れないようにレスポンシブ対応しましょう
- 画像読み込みによるガタツキ（Layout Shift）が起きないようにしましょう

### React_Q2 名刺を全件表示できるようにしよう

- リスト最下部にある[Loader](front/src/components/Loader.tsx)が完全に表示されたことを検知して通信を行いましょう
- 通信中はSpinner（グルグルするUI）を表示しましょう
- [usePeople](front/src/utils/useData.ts)のfetchMore関数を実装して次のページの取得を行い、無限スクロールにしましょう
- `hasMore`の値を使って、次のページがない場合はLoadingを表示しないようにしましょう

### React_Q3 メモの表示をリッチにしよう

- メモを表示する[MemoViewer](front/src/components/MemoViewer.tsx)を実装しましょう
  - 改行に対応しましょう（dangerouslySetInnerHTMLは使わず）
  - 行内にURLがあればリンクにしましょう (noopener noreferrerを付け、複数個にも対応)
  - 行はpタグ、リンクはaタグ、それ以外はspanタグで表示しましょう
  - スペースは個数分表示しましょう
- 以下の文字列が期待通り表示されるかでチェックしてください

```text
1: http://example.com 2: https://example.com

    link http://example.com is here
```

## サーバーサイド課題

### Rails_Q1: 名刺を検索できるようにしよう

名刺を検索してヒットしたものだけ表示するようにしましょう.

- 「検索ボタン」を押すと `query` というパラメータに検索ワードが付与されて [Apis::PeopleController](app/controllers/apis/people_controller.rb) の `#index` アクションが呼ばれます.
- 名前・メールアドレス・会社名を部分一致で検索しましょう.
  - Eightでは名刺の検索にはAWSのOpenSearchを使っていますが、ここではLIKE句で検索をかけてもらって大丈夫です.
  - SQLインジェクションの回避と、検索ワードで正しく検索できることを意識しましょう.
- N+1問題を回避し、SQLの発行回数をできるだけ少なくしましょう.
  - データ量が多い大規模サービスでは、SQLの大量発行はパフォーマンスの低下等の大きな問題につながってきます.
- 実装が完了したら以下を実行し、テストが通ることを確認してください.
  - `$ docker compose exec app bin/rspec spec/requests/apis/people_controller_spec.rb`

### Rails_Q2: 人脈管理をしよう

Eightは人脈管理ツールです.　名刺(Card)が新規で作成されたとき, 同一と判定される人物(Person)がいれば, Card をその Person に紐付けましょう.

- [Card](app/models/card.rb)モデルの `#register` に名刺登録処理を実装しましょう.
- 登録したCard情報を元に、[SampleCardImageUploader](app/models/sample_card_image_uploader.rb)で画像生成してS3にアップロードしましょう.
- 以下のコマンドを叩くと、追加の名刺を取り込むことができます.
  - `$ docker compose exec app bin/rake card_create:additional`
  - リセットする場合は `$ docker compose exec app rails db:seed` を叩いてください
- 同一人物に紐付けるには、新規に登録する名刺の person_id に同一と判定したPersonのidを紐づけましょう.
- 新規に登録する名刺がどの人物にも紐付かない場合, 新しいidでPersonを作成して名刺に紐づけましょう.
- 新規に取り込まれる名刺が名寄せ（merge）され同一人物と判定される条件は以下の2つのケースとします.

  ```
  - パターン1：氏名が完全一致 & メールアドレスが完全一致
  - パターン2：メールアドレスが完全一致 & 職業関連度のスコアが 80 以上
  ```

- 職業関連度とは
  - 2つの職業が近い（似ている）場合はスコアが高くなります
  - 逆に2つの職業が離れている場合はスコアが低くなります
  - 例: calculation(title1, title2)
  - 職業関連度スコアを計算するモジュールはこちら側で用意しています（[CalculationTitleScore](app/models/concerns/calculation_title_score.rb)）
- 取り込まれる名刺データについて
  - 現実世界の名刺の各項目には表記揺れ（姓名の間に空白があったりなかったり、メールアドレスの場合は大文字だったり小文字だったり...などなど）が存在します.
  - 今回のデータは名刺の名前の部分に空白があるもの、ないものが存在しています.
  - 上記の表記揺れも考慮して同一人物と判定できるようにしましょう.
- 補足
  - 新規名刺取り込みのコマンドは [lib/tasks/card_create.rake](lib/tasks/card_create.rake) にあるように名刺データをparseして名刺登録しています.
  - 新規で取り込まれるデータは [db/additional_cards.csv](db/additional_cards.csv) にあります.
  - 実装が完了したら以下を実行し、テストが通ることを確認してください.
    - `$ docker compose exec app bin/rspec spec/models/card_spec.rb`

### Rails_Q3: Webアプリで名刺の取り込みをしよう

Rails_Q2 では手動でrakeタスクを実行して名刺を取り込みましたが、本課題ではWebアプリ上でCSVファイルをアップロードして名刺を取り込んでみましょう。

- ヘッダー右部の `名刺取り込み`の遷移先は[CardUploadsController](app/controllers/card_uploads_controller.rb)になります.
  - CSVファイルはS3にアップロードして、後述するJobクラスで非同期に取り込むようにします.
  - アップロードするファイルは、Rails_Q2 で利用した[db/additional_cards.csv](db/additional_cards.csv)を利用します.
- 取り込み処理を非同期ジョブにしましょう.
  - キューイングサービスは `solid_queue` を利用します.
    - `bundle exec rake solid_queue:start` コマンドでポーリングが開始されます.
    - [Procfile.dev](Procfile.dev)に上記コマンドを追加して実行しましょう.
    - `http://localhost:3003/jobs`からジョブの状況を確認できます.
  - [ApplicationJob](app/jobs/application_job.rb)を継承したJobクラスを作成し、CSVファイルからの名刺取り込みを非同期で処理します.
    - `CardUploadsController`ではJobをエンキューしたら成功のレスポンスを返します.
    - その後、作成したJobから Rails_Q2 の名寄せ処理を実行します.
- 実装が完了したら以下を実行し、テストが通ることを確認してください.
  - `$ docker compose exec app bin/rspec spec/requests/card_uploads_controller_spec.rb`

## フロントエンド x サーバーサイド課題

### React_x_Rails_Q4: メモを登録・編集できるようにしよう

Eightでは名刺の人物にメモをつけることができます.
メモを登録・編集する機能をアプリケーションに追加しましょう.

- サーバーサイド
  - 新規にメモ登録・編集用APIを用意しましょう
  - メモの内容には以下の制限があります
    - 文字数は200文字まで
    - 絵文字不可
  - バリデーションエラーとなった場合はAPIのレスポンスでエラーメッセージを返しましょう
- フロントエンド
  - APIを呼び出す[postMemo](front/src/apis/personMemo.ts)を実装し、[MemoEditDialog](front/src/components/MemoEditDialog.tsx)から実行しましょう
  - バリデーションエラーのエラーメッセージが返った場合は表示しましょう
  - 編集に成功した場合、メモの表示を更新しましょう
  - （できたら、）ダイアログ内にフォーカスが閉じるようにしましょう

## Appendix

### フロントエンド

#### React_Q4 検索の通信を間引きましょう

- 文字を入力するたびに検索するインクリメンタルサーチを実装しよう
- 一定時間入力がない場合に検索を実行するようにしましょう（useDebouncedFuncを実装）

#### React_Q5 classNames関数の返り値の型をstringより詳しい型にしよう

- classNames関数の返り値の型ClassNameJoinを実装して、stringより詳しい型にしましょう

### サーバーサイド
#### Rails_Q4 rbs-inline を使って静的型付けをしてみよう
静的型付け言語であるRBSがRuby3系から導入されました

- rbs: 型定義をするための言語
- rbs_collection: ライブラリやgemの型定義ファイル (rbs) をまとめているgem
- steep: rbsを使って型チェックをするgem
- sig/: rbsファイルを置くディレクトリ。rbsファイルはsig/配下に置くことが推奨されています

Appendixでは、[rbs-inline](https://github.com/soutaro/rbs-inline) gemを用いて、`app/models/concerns` 配下に型を定義してみましょう

rbs-inlineを使って型定義を行うための準備をします
1. ホストマシンで `$ brew install fswatch` する（ファイル検知に必要です）
2. ホストマシンで `$ chmod +x ./auto_gen_rbs.sh` する（スクリプトを動かすために権限が必要です）
3. ホストマシンで `$ ./auto_gen_rbs.sh` する（ここでrbsが自動検知されるようになります）
4. rbsを追加したいファイルの１行目に `# rbs_inline: enabled` を記載する
5. [Syntax Guide](https://github.com/soutaro/rbs-inline/wiki/Syntax-guide) を参考に型定義を行う

型が正しく定義されているかは、`$ docker compose exec app steep check` で確認できます。
