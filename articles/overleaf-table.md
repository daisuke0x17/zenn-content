---
title: "Overleaf で美しい表を作成する"
emoji: "🌿"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [LaTeX,Overleaf]
published: true
published_at: "2023-02-12 00:00"
---

## 結論
- `booktabs` パッケージを利用する
- [Tables Generator](https://www.tablesgenerator.com/) で表を作成すると簡単です

## はじめに
論文を執筆するときに「この論文の美しい表はどうやって作ってるんだ！」と思ったことはありませんか？🤔
本記事では、Overleaf でよくみる美しい表の作成方法を紹介します。

## よくみる表を作成する
`booktabs` パッケージを利用すると、より LaTeX らしい表を作成できます。
使い方は、`\toprule`、`\midrule`、`\bottomrule` のコマンドで、表の上下に線を引くことができます。
注意点としては **`\usepackage{booktabs}`** の追加を忘れないことです。また、[Tables Generatorで表を作成する](#tables-generatorで表を作成する)と簡単です。
```
\begin{tabular}{@{}cccrrc@{}}
  \toprule
        & 分類   & タイプ & \multicolumn{1}{c}{高さ (m)} & \multicolumn{1}{c}{重さ (kg)} & 特性    \\ \midrule
  ゼニガメ  & かめのこ & みず  & 0.5                        & 9.0                         & げきりゅう \\
  カメール  & かめ   & みず  & 1.0                        & 22.5                        & げきりゅう \\
  カメックス & こうら  & みず  & 1.6                        & 85.5                        & げきりゅう \\ \bottomrule
\end{tabular}
```
![](/images/overleaf-tips/ex-table.png)

ちなみにエクセル風の表は下記のように作成できます。`booktabs`パッケージを利用した場合と比べてどうでしょうか？🤔
個人的には`booktabs`パッケージを利用した線の少ない表の方が好みです！
```
\begin{tabular}{|c|c|c|c|} \hline
  & 分類   & タイプ & 特性    \\ \hline
  ゼニガメ  & かめのこ & みず  & げきりゅう \\
  カメール  & かめ   & みず  & げきりゅう \\
  カメックス & こうら  & みず  & げきりゅう \\ \hline
\end{tabular}
```
![](/images/overleaf-tips/ex-default-table.png)

### Tables Generatorで表を作成する
エディタよりもGUIで表を作成したい方は [Tables Generator](https://www.tablesgenerator.com/) がオススメです。マウスでポチポチして表を作成できますし、とりあえず表を作成して叩き台にするという使い方もできます。
**Booktabs table style** を選択すると美しい表が作成できます✨
![](/images/overleaf-tips/ex-tables-generator.png)

https://www.tablesgenerator.com/

## おわりに
本記事では論文でよくみる美しい表の作成方法を紹介しました。
この記事が誰かのお役に立てば幸いです🙇‍♂️皆様の論文執筆が少しでも快適になりますように🤞