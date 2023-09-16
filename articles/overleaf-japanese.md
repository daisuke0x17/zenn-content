---
title: "Overleaf で日本語を使えるようにする"
emoji: "🌿"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [LaTeX,Overleaf]
published: true
published_at: "2023-09-15 00:00"
---

## 結論
1. 左上メニューからコンパイラを`LaTeX`に設定する
2. プロジェクトのルートディレクトリに`latexmkrc`ファイル（**拡張子不要**）を作成し、下記を記述する
```
$latex = 'platex';
$bibtex = 'pbibtex';
$dvipdf = 'dvipdfmx %O -o %D %S';
$makeindex = 'mendex %O -o %D %S';
```

## はじめに
私が所属している研究室では、論文執筆に Overleaf を利用しています。Overleaf はインストール不要で LaTeX が使えるオンラインエディタです。しかし！デフォルトの設定では日本語入力ができません😅
本記事では、Overleaf で日本語入力ができるようになるまでの手順をまとめました。

https://ja.overleaf.com/

## 日本語入力に必要な設定
プロジェクト開始時の状態では日本語を入力してもコンパルできません。
以下の4つ（主に最初の3つ！）を設定して日本語入力ができるようにしましょう💪
### 1. 左上メニューからコンパイラを`LaTeX`に設定する
   ![](/images/overleaf-japanese/ex-menu.jpg)
   ![](/images/overleaf-japanese/ex-compiler-latex.png)

### 2. プロジェクトのルートディレクトリに `latexmkrc` というファイルを作成する
ルートディレクトリに`latexmkrc`というファイルを作成してください。
**拡張子は不要**ですのでご注意ください。
    ![](/images/overleaf-japanese/ex-latexmkrc.png)

### 3. `latexmkrc` ファイルに下記をコピペする
一旦無心でコピペしましょう。詳細については後ほど解説します。
```
$latex = 'platex';
$bibtex = 'pbibtex';
$dvipdf = 'dvipdfmx %O -o %D %S';
$makeindex = 'mendex %O -o %D %S';
```
### 4. `\documentclass{}`を確認する
学会のテンプレートでは既に設定されいると思いますが、念の為確認しておきましょう。文章クラスの種類については[こちら](https://medemanabu.net/latex/documentclass/)にまとまっていました。和文のクラスであれば問題ないです。

https://ja.overleaf.com/learn/latex/Japanese

## latexmkrc の中身が知りたい
これで日本語は入力できるようになりました。しかし、`latexmkrc` の中身を理解せずに使うのはムズムズしますよね。自分なりにですが何を設定しているのか調べてみました。間違っている箇所があればご指摘ください🙇‍♂️
- `$latex`
`.tex` ファイルをコンパイルする際のコマンドを指定します。日本語をコンパイルする際は `platex` を指定する。
- `$bibtex`
`.bib` ファイルをコンパイルする際のコマンドを指定します。日本語をコンパイルする際は `pbibtex` を指定する。
- `$dvipdf`
`latex` が出力した`DVI` ファイルを PDF に変換するコマンドを指定します。日本語を変換する際は `dvipdfmx` を指定する。
- `$makeindex`
索引を作成するコマンドを指定します。 `\usepackage{makeindex}` 利用時に必要になる。
<!-- TODO: オプションについて調べてまとめる `%O`とか`%D`とか`%S -->

http://www2.yukawa.kyoto-u.ac.jp/~koudai.sugimoto/dokuwiki/doku.php?id=latex:latexmk%E3%81%AE%E8%A8%AD%E5%AE%9A

## おわりに
本記事では Overleaf で日本語入力ができるようになるまでの手順をまとめました。日本語入力の設定は、論文執筆のはじめの一歩になると思います。この記事が誰かのお役に立てば幸いです🙇‍♂️
皆様の論文執筆が少しでも快適になりますように🤞