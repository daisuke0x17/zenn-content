---
title: "仕組みから学ぶ GitHub Copilot の使い方"
emoji: "🧑‍🚀"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["githubcopilot", "github"]
published: true
publishedAt: "2023-09-21 00:00"
---

## 結論
- GitHub Copilot の仕組みを知りたい方は[こちら](#github-copilot-の裏側)
- 具体的な Tips を知りたい方は[こちら](#具体的なtips)


## はじめに
2023年09月12日に行われた、[【GitHub x サイバーエージェント共催】GitHub Copilotで変わる開発文化の現実](https://cyberagent.connpass.com/event/292982/) に参加してきました。このイベントでは、GitHub Copilot の仕組みやチームでの活用方法について詳しく解説していただきました。
本記事では、イベントで学んだことをギュッと圧縮して紹介します。GitHub Copilot の仕組みを知ることで、新たな活用方法を発見する手がかりになれば幸いです🥳

## Copilot とは
GitHub Copilot は、GitHub と OpenAI が共同開発した AI プログラミングアシスタントです。もう Copilot なしのコーディングなんて考えられない！という人もいるのではなしょうか？🤔
コードの自動補完や、関数の実装を AI がサジェストしてくれるまさに **Co** な **パイロット** です。

https://github.com/features/copilot

### Copilot の思想
Copilot は以下の思想で開発されています。
- レスポンスの速さ重視
    - 「長時間かけて最高のコードを提案する」という思想ではない
    - エンジニアが待つ時間を減らすことを重視している
- 納得がいかない提案はすぐに破棄して、次の提案を促すような使い方を想定している
- 多くの人がハッピーになれる機能から実装している

Copilot の Change Log はこちら🔽
https://github.blog/changelog/label/copilot/

## GitHub Copilot の裏側
### モデル
- Sahara-base という GPT3.5-turbo をベースにしたモデルを使用
    - CodeX は現在使用していない
    - あくまで Language Model である
    - （モデルは人間が書くコードをどんな風に捉えているんでしょうか🤔）

:::details Sahara-baseとは
なかなか情報が見つかりませんでしたが、1つだけ参考になりそうな Discussion を発見しました！
この記事によると、2023年4月の下旬ごろには既に Sahara-base が使われていそうです。
Sahara-base は2022年初頭にトレーニングされ、2023年3月1日にモデルが更新されたとのことです。2022年初頭から存在していた Cushman-02（CodeX 派生）からのアップグレードに当たるようです。

https://github.com/orgs/community/discussions/56975
:::

### Copilot がエディタから収集する情報
Copilot はエディタ内から情報を収集しています。リポジトリ全体を探索しているわけではありません。Copilot がモデルへ渡せるトークン数は 2000 トークンほどになっています。
収集する情報の優先順位は以下のようになっています。

#### 1. プログラミング言語情報
- 例えば、TypeScript で書いているときは「TypeScript を書いている（Language Marker）」という情報を渡しています
- Language Marker の例
    - html: `<!DOCTYPE html>`
    - Python: `#\!/usr/bin/env python3`
- ここで認識された言語のファイルが Copilot が探索する対象になります
    - Python で書いているときに関連している CSV や Markdown などのファイルは Copilot は読み込んでいないので注意です

#### 2. 現在のファイルへのパス
- 現在アクティブなファイルへのパス情報を渡しています
- 例えば、現在アクティブなファイルが`controllers`ディレクトに存在するなら「コントローラーを書いていそうだ」という情報です。

#### 3. 現在のカーソル位置上部のコード

#### 4. 現在のカーソル位置下部のコード

#### 5. 非アクティブなオープンしているタブ
- 最大で直近 20 個のタブが探索対象になります
- 現在アクティブなファイルと同じ言語のファイルが対象になります
- FIFO で直近のタブが優先して探索される

#### 6. コードベースの中の他の場所のコード（← New）

:::message
あくまで現時点での優先順位であり、今後変更される可能性があります。
:::

### 具体的なTips
#### コード補完
GitHub Copilot の基本機能です。コードを提案してくれて、`Tab`キーで補完することができます。
その他にもショートカットキーが用意されているので下記を参考にしてみてください！
| アクション | ショートカットキー |
| ---- | ---- |
| 提案を受け入れて補完 | `Tab` |
| 提案を却下 | `Esc` |
| 次の提案を表示 | `Option (⌥) or Alt` + `]` |
| 前の提案を表示 | `Option (⌥) or Alt` + `[` |

https://docs.github.com/ja/copilot/configuring-github-copilot/configuring-github-copilot-in-your-environment

#### コメントを英語で書く
日本語でコメントを書くよりも、英語のほうがトークンを節約できます。結果として多くの情報を渡すことができるので、より良い提案が得られる可能性が高くなります。
ただし、意味の通らない英語を書いてしまうと逆効果なので、無理して英語を書く必要はないかと思います😅

#### ユニットテストの作成
ユニットテストの作成も工夫次第で Copilot に任せることができるかも？しれません。
重要なのは**コメント**を活用して具体的な情報を Copilot へ渡すことです。
例えば
- コメントでオープンクエスチョンを行う
- 候補数を指定する

など、とにかく具体的な情報を渡すことが大切です。

```typescript:example.ts
// ◯◯なエッジケースを含めたテストの候補を10個ください
```
また、[Copilot がエディタから収集する情報](#copilot-がエディタから収集する情報)で述べましたが、Python を書いているときに関連している CSV や Markdown などのファイルが存在しても Copilot は読み込んでいません。関連する情報はコメントで渡してあげる必要があります。
```Python:example.py
# 名前,年齢,都市
# 田中,30,東京
# 佐藤,25,大阪
# 山田,35,福岡
```

#### 便利ファイルのピン留め
こちらは既に活用されている方も多いのではないでしょうか。`d.ts`ファイルやマイグレーションファイルなどギュッと情報が詰まったファイルをピン留めしましょう。
ただし、**ピン留めしたからといって優先度が上がるわけではない**ようです。すぐにファイルを取り出せる状態にしておくが大切です。

#### 一貫性のあるコーディングスタイル
これが一番重要で一番難しい？ことかもしれません。「良いものを書けば良いものが返ってくる」ということです。本イベント内でも命名規則が重要であるというお話がありました。
少ない情報で多くを伝えられるような命名を心がけたいですね！


## エディタだけじゃない！GitHub Copilot X
Copilot と言えばエディタ上でコードを補完する機能ですが、エディタ以外にもその能力を発揮しているサービスがあります。それが GitHub Copilot X です。
GitHubブログによると
> GitHub Nextの研究開発チームは、GitHub Copilotをエディター上だけではなく、開発ライフサイクル全体を通してすぐに利用できるAIアシスタントに進化させるべく取り組んでいます。そうして誕生したのがGitHub Copilot Xであり、AIを活用したソフトウェア開発の未来に対するGitHubのビジョンを体現しています。
https://github.blog/jp/2023-03-23-github-copilot-x-the-ai-powered-developer-experience/

つまりコーディングだけでなく、開発ライフサイクル全体を通して Copilot を活用できる未来がくるということですね！
そんな GitHub Copilot X の中からイベントでも取り上げられたもの３つ紹介します。

GitHub Copilot X の 詳細 はこちら🔽
https://github.com/features/preview/copilot-x

### Copilot for the CLI
CLI でも Copilot がつかえるようになります！AI が対話しながらコマンドの入力をサポートしてくれます。

![](https://github.blog/jp/wp-content/uploads/sites/2/2023/03/Copilot-CLI-1.png?w=512L)
*https://github.blog/jp/2023-03-23-github-copilot-x-the-ai-powered-developer-experience/*

Waiting List への登録はこちら🔽
https://githubnext.com/projects/copilot-cli

### Copilot for Pull Requests
Pull Request に対して Copilot がコメントを書いてくれます！AI が変更履歴を読み取って、変更内容に関連するコメントを書いてくれます。
![](/images/github-copilot-tips/copilot-pr.png)
*https://githubnext.com/projects/copilot-for-pull-requests*

https://githubnext.com/projects/copilot-for-pull-requests

### Copilot for Docs
技術系のドキュメントを学習した ChatGPTのような存在です！まずは、`Azure`,`MDN Web Docs`,`React`のドキュメントを学習したモデルが提供されるようです。
https://githubnext.com/projects/copilot-for-docs

## 最後に
GitHub Copilot は日々開発が進んでいます。今後も新しい機能が追加されていくと思うので、目が離せませんね！
本記事では Tips を紹介しましたが、Copilot は「Tips を意識せずとも自然に良いコーディングができる」という未来を目指しているようです🚀
本記事が快適なコーディングライフを送るための一助になれば幸いです🙇‍♂️
