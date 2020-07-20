# InterSystems IRIS で REST サーバを作ってみよう！
このGitでは、InterSystems IRIS で作成する REST サーバに必要なディスパッチクラスのサンプルを含んだコンテナを提供しています。
コンテナは、[InterSystems IRIS Community Editionのイメージ](https://hub.docker.com/_/intersystems-iris-data-platform)を使用しています（Pullできない場合はイメージ、タグ名ごご確認いただき、[Dockerfile](/Dockerfile) の IMAGE 変数を書き換えてから実行してください）。

## Gitのサンプルコードは、[InterSystems 開発者コミュニティ](https://jp.community.intersystems.com)に公開しているビデオのサンプルコードです。

(1) [InterSystems IRIS で作成する　REST サーバの仕組みについて]()

(2) [IRIS での JSON 操作]()

IRIS サーバ側でのJSON操作に使用するダイナミックオブジェクト、SQL関数、%JSON.Adapterクラスの使い方を解説します。

(3) [手動によるディスパッチクラスの作成]（）

(4) [API ファーストで作成するディスパッチクラス]（）

アプリケーションの仕様を Open API 2.0 に基づいて先に定義し、定義内容からRESTディスパッチクラスの開発に必要なクラスを自動生成する方法を解説します（実装用クラスには、スタブメソッドが用意されます）。

## その他のビデオ
関連ビデオの他に、IRISの基本操作についてを解説する「はじめてInterSystems IRIS」セルフラーニングビデオを [InterSystems 開発者コミュニティ](https://jp.community.intersystems.com)の [beginnerタグ](https://jp.community.intersystems.com/tags/beginner) にご用意しています。ぜひご参照ください。


## ディレクトリ／サンプルファイルについて
コンテナには、ディスパッチクラスなどのサンプルコードが含まれます。
サンプルファイルについて詳細は以下の通りです。

|ディレクトリ|ファイル|説明|
|:--|:--|:--|
|[Test](/Test)||RESTディスパッチクラスやその他サンプルクラス定義含まれるディレクトリ|
||[Test.Person](/Test/Person.cls)|RESTディスパッチクラスからアクセスするTest.Personクラス（永続クラス＝テーブル）|
||[Test.JSONTest](/Test/JSONTest.cls)|ビデオ：(2) [IRIS での JSON 操作]()の中で実行するJSON用SQL関数のサンプルコードを含んだクラス定義|
||[Test.VSCode.REST](/Test/VSCode/REST.cls)|(3) [手動によるディスパッチクラスの作成]（）で作成するRESTディスパッチクラスのサンプルコード|
||[crud2-sample.json](/crud2-sample.json)|(4) [API ファーストで作成するディスパッチクラス]（）で事前に準備するOpenAPI2.0に基づくアプリケーション定義例|
||[impl-sample.cls](/impl-sample.cls)|(4) [API ファーストで作成するディスパッチクラス]（）でロジックを記述するクラス（自動生成されるクラスにサンプルコードを記載したファイルです）|


## コンテナ起動までの手順
詳細は、[docker-compose.yml](./docker-compose.yml) をご参照ください。

Git展開後、**./ は コンテナ内 /irisdev/app ディレクトリをマウントしています。**
また、IRISの管理ポータルの起動に使用するWebサーバポートは **42773** が割り当てられています。

```
git clone このGitのURL
```
cloneしたディレクトリに移動後、以下実行します。

```
$ docker-compose build
```
ビルド後、コンテナを開始します。
```
$ docker-compose up -d
```
コンテナを停止する方法は以下の通りです。
```
$ docker-compose stop
```

## 手動による REST ディスパッチクラスの作成と実行体験する
コンテナ開始時に /crudSample　のベースURLに対して、[Test.VSCode.REST](/Test/VSCode/REST.cls)が実行できる環境を作成します。

GET／POST／PUT／DELETE 要求をお好みのRESTクライアントから実行できます。
テスト実行時のベースURLは http://localhost:42773/crudSample です。それぞれの要求に合わせてパスを修正して実行してください。

例）Test.Personを全件返すGET要求実行パス　http://localhost:42773/crudSample/person/all

また、コンテナに事前に用意されるベースURL /crudSample では、REST アクセス時に Basic 認証を使用します（認証は任意の方法に変更できますが初期設定として Basic 認証を指定しています）。
コンテナ内では、IRISの事前定義ユーザである _system に対してパスワード SYS でログインできます（パスワードは大文字）。アクセス時に指定してください。


## API ファーストによる RESTディスパッチクラスの作成と実行を体験する
OpenAPI2.0に基づくアプリケーションの仕様をご準備ください。
（サンプル： [crud2-sample.json](/crud2-sample.json) を用意しています。）

JSONでアプリケーション仕様を定義した後、以下URLをPOST要求で実行します。
（メッセージボディにJSONのアプリケーション仕様の定義を指定します）

http://localhost:ポート番号/api/mgmnt/v2/<ネームスペース名>/<ベースURL>

例）ネームスペース：USER、ベースURL：/crud2、IRISのWebサーバポート：42773　とした場合のURLは以下の通りです。
http://localhost:42773/api/mgmnt/v2/user/crud2

実行後自動生成される　crud2.impl クラスを VSCode にエクスポートしてから、コードを追記します（設定詳細はビデオ：[API ファーストで作成するディスパッチクラス]（）xx:ss ～をご参照ください）。

crud2.implクラスのサンプルは [impl-sample.cls](/impl-sample.cls) です。
また、ベースURL /crud2 に対して設定するディスパッチクラスは crud2.disp です（管理ポータルのウェブ・アプリケーションの画面で設定します）。






