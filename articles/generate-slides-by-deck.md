---
title: "Markdown で Google Slides を作成するツール「deck」導入方法"
emoji: "🎬️"
type: "idea" # tech: 技術記事 / idea: アイデア
topics: ["Googleスライド", "markdown", "presentation"]
published: true
---

## 結論

- とにかくインストール方法が知りたい方は[インストール](#インストール)
- deck の使い方が知りたい方は[基本的な使い方](#基本的な使い方)

## はじめに

ある日、SNS を徘徊していると「Markdown で Google Slides が作れる」という投稿を目にしました 👀
そこで紹介されていたのが **[deck](https://github.com/k1LoW/deck)** でした。その瞬間から deck を導入して利用しているのですが、最高です ✨

これはぜひエンジニア以外の方にも試してほしい！と思ったので、本記事では **エンジニア以外の方** でも導入しやすいようにスクショ込みで「deck」の導入方法を解説します。

## deck とは
deck は、Markdown と Google Slides を組み合わせてプレゼンテーションを作成・管理するための OSS ツールです。

特徴はこんな感じ：
- **コンテンツとデザインの分離**：Markdown でコンテンツ、Google Slides でデザイン
- **Git でバージョン管理**：Markdown ファイルなので差分管理が簡単
- **継続的なスライド作成**：繰り返し生成・修正が可能

https://github.com/k1LoW/deck

## インストール

ここが最難関かもしれません。「Homebrew インストール」というキーワードで検索してみてください。
Homebrew さえ導入できれば、あとはコマンドを打つだけです。

- Homebrew（オススメ）
```bash
brew install deck
```
---

エンジニア向け

- Go

```bash
go install github.com/k1LoW/deck/cmd/deck@latest
```

もしくは[リリースページ](https://github.com/k1LoW/deck/releases)から直接ダウンロードできます。

## Google API 設定

「API 設定」と聞くと難しそうに聞こえますが、スクショをたくさん載せています。
上から順番に進めていけば、たぶんきっと大丈夫です！

### 1. Google Cloud Console でプロジェクト作成

既にプロジェクトをお持ちの方は、このステップは飛ばして OK です。

1. [Google Cloud Console](https://console.cloud.google.com)にアクセス
2. 新規プロジェクトを作成
3. プロジェクト名を決めて作成ボタンをクリック

### 2. 必要な API を有効化

以下のリンクからの2つの API を有効にしてください：

- [Google Slides API](https://console.cloud.google.com/apis/library/slides.googleapis.com)
- [Google Drive API](https://console.cloud.google.com/apis/library/drive.googleapis.com)

各ページで「有効にする」ボタンをクリックします。

![](/images/generate-slides-by-deck/google-slides-api.png)

### 3. OAuth 認証情報の作成

1. [認証情報ページ](https://console.cloud.google.com/apis/credentials)にアクセス
2. **「+ 認証情報を作成」** ボタンをクリック
3. **「OAuth クライアント ID」** を選択
![](/images/generate-slides-by-deck/create-oauth.png)

4. 同意画面を構成
![](/images/generate-slides-by-deck/oauth-client-id.png)

5. ブランディング「開始」
![](/images/generate-slides-by-deck/oauth-start-branding.png)

6. プロジェクトを構成：アプリ情報で名前を入力（例：「Deck」）
![](/images/generate-slides-by-deck/oauth-project-info.png)

7. プロジェクトを構成：対象（Google ワークスペースユーザーの場合は内部、その他は外部）
![](/images/generate-slides-by-deck/oauth-project-targeting.png)

8. 残りの項目を埋め「作成」
![](/images/generate-slides-by-deck/oauth-project-done.png)

9. 続いて、クライアント：「クライアントを作成」
![](/images/generate-slides-by-deck/create-oauth-clinet.png)

10. アプリケーションの種類で **「デスクトップアプリ」** を選択
![](/images/generate-slides-by-deck/oauth-client-desktop.png)

11. 「作成」ボタンをクリック
12. JSON をダウンロード
![](/images/generate-slides-by-deck/oauth-client-download.png)

ふぅ〜あと少しです 💦

### 4. テストユーザーの登録

公開する必要はないので、テストユーザーとしてメールアドレスを登録します。

1. 「Add users」から自分のメールアドレスを登録
![](/images/generate-slides-by-deck/oauth-test-user.png)


### 5. 認証ファイルの配置

ダウンロードしたJSONファイルを以下の場所に配置します。

:::message
`client_secret_XXXXX.json`の部分は、実際のファイル名に置き換えてください。
:::

```bash
mkdir -p ~/.local/share/deck/

mv ~/Downloads/client_secret_XXXXX.json ~/.local/share/deck/credentials.json
```

これで認証情報の設定は完了です！お疲れ様でした 🍵

## プレゼンテーションの作成

```bash
deck new my-first-deck.md --title "はじめてのdeck"
```

このコマンドを実行すると：

1. ブラウザが自動で開きます
2. Googleアカウントでログイン
3. 「このアプリは確認されていません」という警告が表示されます
4. **「詳細」** をクリック → **「安全でないページに移動」** をクリック
5. アクセスを許可

:::message alert
警告が出ますが、自分で作成したアプリなので問題ないです。「安全でないページに移動」で進めてください。
:::

成功すると、`my-first-deck.md`ファイルが作成され、以下のような内容が自動で追加されます。

```markdown
---
presentationID: 1234567890
title: はじめてのdeck
---
```

## 基本的な使い方

ほんとに触りの部分だけ紹介します！後日いろいろ試行錯誤した結果を記事にしたいと思います。

### Markdown で書く

作成されたファイルに、以下のような内容を追記してみましょう。

```markdown
---
presentationID: 1234567890
title: はじめてのdeck
---

# はじめてのdeck

Markdown で Google Slides を作成してみよう！

---

## 今日のアジェンダ

- **deckとは何か**
- **基本的な使い方**
- **便利な機能**

---

## deck の特徴

- 📝 Markdown で書ける
- 🎨 Google Slides でデザイン
- 📂 Git でバージョン管理
- 🚀 継続的なスライド更新
```

最初に覚えたいポイント：
- `---` でスライドを区切る
- `#` がスライドのタイトルになる
- `-` で箇条書き
- `** **` で太字

### Google Slides に反映

Markdown で書いた内容を Google Slides に反映するには、以下のコマンドを実行します。

```bash
# スライドを反映
deck apply my-first-deck.md

# ブラウザでプレゼンテーションを開く
deck open my-first-deck.md
```

### Watch モード（超便利！）

リアルタイムでファイル変更を反映したい場合は、以下のコマンドを実行します。

```bash
deck apply --watch my-first-deck.md
```

これで、ファイルを保存するたびに自動で Google Slides に反映されます 🚀

## おわりに

いかがでしたか？いますぐにでも Markdown でスライド作成したくなりましたよね！？
一度環境さえ整えてしまえば、スライド作成の効率が劇的に向上します！

ぜひ deck を使った スライド作成を体験してみてください！

## 参考リンク

- [deck](https://github.com/k1LoW/deck)
