---
title: "Overleaf で論文執筆"
emoji: "🌿"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [LaTeX,Overleaf]
published: true
published_at: "2023-02-10 00:00"
---
## はじめに
私が所属している研究室では、論文執筆に Overleaf を利用しています。Overleaf はインストール不要で LaTeX が使えるオンラインエディタです。環境構築がないので導入ハードルは低いのですが、 LaTeX のお作法や Overleaf の仕様に戸惑うことが多いです（私がそうでした😅）。
私自身が詰まったポイントや Tips をまとめました！

https://ja.overleaf.com/

<!-- ## 日本語の利用 -->

## 表の作成
### GUI で作成
エディタよりもGUIで表を作成したい方は [Tables Generator](https://www.tablesgenerator.com/) がオススメです。エクセルの要領で表を作成できますし、とりあえず表を作成して叩き台にするという使い方もできます。
https://www.tablesgenerator.com/

## 参考文献
### なぜか表示されない
参考文献が表示されないときは下記を確認してみましょう。多くの場合これで解決できました。
1. 本文中で `\cite{}` する
LaTeX では本文中で参照した文献のみ表示されます。`.bib` ファイルに参考文献を書くだけでは表示されません。

2. `.bib` ファイルを指定する
`.bib` ファイルの指定は拡張子不要です。例えば `sample.bib` を読み込みたいときは`\bibliography{sample}` とします。またファイル名は大文字と小文字を区別するのでタイプミスがないか要チェックです。ファイル名は日本語も指定できますが英語が無難でしょう。

3. `\bibliographystyle{}` を指定する
[標準で搭載されているスタイル](https://www.overleaf.com/learn/latex/Questions/Which_BibTeX_Styles_are_Available_on_Overleaf%3F)以外を利用する場合は、プロジェクトに `.bst` ファイルをアップロードしましょう。

4. `.bib` ファイルのエラーを確認する
`.bib` ファイルにエラーがあると正常に読み込めないことがあるようです。その場合は、警告メッセージを参考にしてエラーを修正しましょう。

5. フォルダ名を確認する
フォルダ名にスペースや特殊文字が含まれていないか確認しましょう。`.bib` ファイルやメインの`.tex` ファイルが含まれているフォルダ名は要チェックです。フォルダ名にスペースや特殊文字が含まれているとコンパイラが検出できないことがあるようです。
　またメインの `.tex` ファイルはプロジェクトのルートディレクトリに置くことが推奨されています。

6. `\typeout{}`を追加する
ここまでチェックした上で解決できない場合は、かなり特殊な状況だそうです。そんなときは `\bibliography{}` の直前に `\typeout{}` を追加しましょう。
```
\typeout{} % これを追加する！
\bibliography{...}
```

https://www.overleaf.com/learn/latex/Questions/BibTeX_isn%27t_working%3B_my_%5Ccite_are_showing_up_as_question_marks_(%3F)

## おわりに
本来は論文内容の推敲に時間を割くべきであるのに、 LaTeX のお作法や Overleaf の仕様と向き合っている時間が長いと少しずつ気力が失われますよね。皆様の論文執筆が少しでも快適になりますように🤞
この記事が誰かのお役に立てば幸いです🙇‍♂️