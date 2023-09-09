---
title: "Overleaf で表を作成する"
emoji: "🌿"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [LaTeX,Overleaf]
published: false
---

## 表の作成
エクセル風のシンプルな表は下記のように作成できます。
個人的には、後述する[booktabs パッケージを利用する](#booktabs-パッケージを利用する)とより LaTeX らしい表を作成できるのでそちらをオススメします。
```
\begin{tabular}{|c|c|c|c|} \hline
  & 分類   & タイプ & 特性    \\ \hline
  ゼニガメ  & かめのこ & みず  & げきりゅう \\
  カメール  & かめ   & みず  & げきりゅう \\
  カメックス & こうら  & みず  & げきりゅう \\ \hline
\end{tabular}
```
![](/images/overleaf-table/ex-default-table.png)

### booktabs パッケージを利用する
`booktabs` パッケージを利用すると、より LaTeX らしい表を作成できます。`\toprule`、`\midrule`、`\bottomrule` で表の上下に線を引くことができます。
注意点としては **`\usepackage{booktabs}`** の追加を忘れないことです。[Tables Generatorで表を作成する](#tables-generatorで表を作成する)と簡単です。
```
\begin{tabular}{@{}cccrrc@{}}
  \toprule
        & 分類   & タイプ & \multicolumn{1}{c}{高さ (m)} & \multicolumn{1}{c}{重さ (kg)} & 特性    \\ \midrule
  ゼニガメ  & かめのこ & みず  & 0.5                        & 9.0                         & げきりゅう \\
  カメール  & かめ   & みず  & 1.0                        & 22.5                        & げきりゅう \\
  カメックス & こうら  & みず  & 1.6                        & 85.5                        & げきりゅう \\ \bottomrule
\end{tabular}
```
![](/images/overleaf-table/ex-table.png)

### Tables Generatorで表を作成する
エディタよりもGUIで表を作成したい方は [Tables Generator](https://www.tablesgenerator.com/) がオススメです。マウスでポチポチして表を作成できますし、とりあえず表を作成して叩き台にするという使い方もできます。
**Booktabs table style** を選択すると美しい表が作成できます✨
![](/images/overleaf-table/ex-tables-generator.png)

https://www.tablesgenerator.com/
