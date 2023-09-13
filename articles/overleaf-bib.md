---
title: "Overleaf で参考文献が表示されないときに確認すること"
emoji: "🌿"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [LaTeX,Overleaf]
published: true
published_at: "2023-09-22 00:00"
---

## 結論
以下の6つを確認してみましょう。
1. [本文中で `\cite{}` する](#1-本文中で-cite-する)
2. [`.bib` ファイルを指定する](#2-bib-ファイルを指定する)
3. [`\bibliographystyle{}` を指定する](#3-bibliographystyle-を指定する)
4. [`.bib` ファイルのエラーを確認する](#4-bib-ファイルのエラーを確認する)
5. [フォルダ名を確認する](#5-フォルダ名を確認する)
6. [`\typeout{}`を追加する](#6-typeoutを追加する)

## はじめに
Overleaf で参考文献がなぜか表示されないときってありますよね😅しかし！下記で紹介する6つの項目を確認することで多くの場合解決できました。
本記事では、Overleaf で参考文献が表示されないときに確認することを紹介します。

## 参考文献が表示されないときの確認事項
### 1. 本文中で `\cite{}` する
LaTeX では本文中で参照した文献のみ表示されます。`.bib` ファイルに参考文献を書くだけでは表示されません。

### 2. `.bib` ファイルを指定する
`.bib` ファイルの指定は拡張子不要です。例えば `sample.bib` を読み込みたいときは`\bibliography{sample}` とします。またファイル名は大文字と小文字を区別するのでタイプミスがないか要チェックです。ファイル名は日本語も指定できますが英語が無難でしょう。

### 3. `\bibliographystyle{}` を指定する
[標準で搭載されているスタイル](https://www.overleaf.com/learn/latex/Questions/Which_BibTeX_Styles_are_Available_on_Overleaf%3F)以外を利用する場合は、プロジェクトに `.bst` ファイルをアップロードしましょう。

### 4. `.bib` ファイルのエラーを確認する
`.bib` ファイルにエラーがあると正常に読み込めないことがあるようです。その場合は、警告メッセージを参考にしてエラーを修正しましょう。

### 5. フォルダ名を確認する
フォルダ名にスペースや特殊文字が含まれていないか確認しましょう。`.bib` ファイルやメインの`.tex` ファイルが含まれているフォルダ名は要チェックです。フォルダ名にスペースや特殊文字が含まれているとコンパイラが検出できないことがあるようです。
　またメインの `.tex` ファイルはプロジェクトのルートディレクトリに置くことが推奨されています。

### 6. `\typeout{}`を追加する
ここまでチェックした上で解決できない場合は、かなり特殊な状況だそうです。そんなときは `\bibliography{}` の直前に `\typeout{}` を追加しましょう。
```
\typeout{} % これを追加する！
\bibliography{...}
```

https://www.overleaf.com/learn/latex/Questions/BibTeX_isn%27t_working%3B_my_%5Ccite_are_showing_up_as_question_marks_(%3F)

## おわりに
本記事では Overleaf で参考文献が表示されないときに確認することを紹介しました。
この記事が誰かのお役に立てば幸いです🙇‍♂️皆様の論文執筆が少しでも快適になりますように🤞