---
title: "Overleaf で論文執筆"
emoji: "🌿"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [LaTeX,Overleaf]
published: true
published_at: "2023-02-12 00:00"
---
## はじめに
私が所属している研究室では、論文執筆に Overleaf を利用しています。Overleaf はインストール不要で LaTeX が使えるオンラインエディタです。環境構築がないので導入ハードルは低いのですが、 LaTeX のお作法や Overleaf の仕様に戸惑うことがありますよね😅
私自身が詰まったポイントや Tips をまとめました！

https://ja.overleaf.com/

## 日本語の入力
プロジェクト開始時の状態では日本語を利用することができません。コンパイラが日本語を読み込めないためです。日本語で論文を執筆する際は下記を設定してみましょう。
1. 左上メニューからコンパイラを`LaTeX`に設定する
2. プロジェクトのルートディレクトリに `latexmkrc` というファイルを作成する
**拡張子は不要**です。コンパイル時の手順を定義するファイルです。
3. `latexmkrc` ファイルに下記を記述する
一旦無心でコピペしましょう。詳細については後ほど解説します。
```
$latex = 'platex';
$bibtex = 'pbibtex';
$dvipdf = 'dvipdfmx %O -o %D %S';
$makeindex = 'mendex %O -o %D %S';
```
4. `\documentclass{}`を確認する
学会のテンプレートでは既に設定されいると思いますが、念の為確認しておきましょう。文章クラスの種類については[こちら](https://medemanabu.net/latex/documentclass/)にまとまっていました。和文のクラスであれば問題ないです。

https://ja.overleaf.com/learn/latex/Japanese

### latexmkrc の中身が知りたい
日本語は入力できるようになったけど、`latexmkrc` の中身を理解せずに使うのは嫌だ！という私のために何を設定しているのか調べてみました。
- `$latex`
`.tex` ファイルをコンパイルする際のコマンドを指定します。日本語をコンパイルする際は `platex` を指定する。
- `$bibtex`
`.bib` ファイルをコンパイルする際のコマンドを指定します。日本語をコンパイルする際は `pbibtex` を指定する。
- `$dvipdf`
`latex` が出力した`DVI` ファイルを PDF に変換するコマンドを指定します。日本語を変換する際は `dvipdfmx` を指定する。
- `$makeindex`
索引を作成するコマンドを指定します。 `\usepackage{makeindex}` 利用時に必要だそう。
<!-- TODO: オプションについて調べてまとめる `%O`とか`%D`とか`%S -->

http://www2.yukawa.kyoto-u.ac.jp/~koudai.sugimoto/dokuwiki/doku.php?id=latex:latexmk%E3%81%AE%E8%A8%AD%E5%AE%9A

## 基本のコマンド
### セクション・サブセクション
```
\section{こうするとセクションになります}
\subsection{サブセクションも作れますよ}
\subsubsection{サブのサブも作れます}
```
![](/images/overleaf-tips/ex-section.png)

### 段落
2つの方法で段落を作成できます。
1. 空行を一行挟む
2. `\par` を利用する
```
私はポケモンGoが大好きです。都会に住んでレイドにたくさん参加したいです。

私は水泳も大好きです。陸にいるより水に浸かっていたい。
でも陸でバイクに乗ることも好きです。風を切るのが気持ちい。\par
空の行を一行挟むか\verb|\par|で段落を作ることができます。
```
![](/images/overleaf-tips/ex-par.png)

### 改行
```
こうすると段落内で\\強制的に改行することができます。
```
![](/images/overleaf-tips/ex-new-line.png)

### 文字
```
これは\textbf{太字}です。
こうすると\textit{SYATAI}になります。
重要な箇所は\underline{下線}を引いてもよいでしょう。
```
![](/images/overleaf-tips/ex-char.png)

#### 上付き文字・下付き文字
```
これは\textsuperscript{上付き文字}です。
こうすると\textsubscript{下付き文字}になります。
```
![](/images/overleaf-tips/ex-sup-sub.png)

### 箇条書き
```
\begin{itemize}
    \item Go
    \item TypeScript
    \item Python
\end{itemize}
```
![](/images/overleaf-tips/ex-list.png)

#### 入れ子の箇条書き
箇条書きは入れ子にすることができます。
```
\begin{itemize}
    \item Go
      \begin{itemize}
        \item Gin
        \item Echo
      \end{itemize}
    \item TypeScript
\end{itemize}
```
![](/images/overleaf-tips/ex-nested-list.png)

### 番号付きリスト
```
\begin{enumerate}
  \item フシギダネ
  \item フシギソウ
  \item フシギバナ
\end{enumerate}
```
![](/images/overleaf-tips/ex-num-list.png)

#### 入れ子の番号付きリスト
番号付きリストは入れ子にすることができます。
```
\begin{enumerate}
  \item フシギダネ
    \begin{enumerate}
      \item たねポケモン
      \item くさ・どく
    \end{enumerate}
  \item フシギソウ
\end{enumerate}
```
![](/images/overleaf-tips/ex-nested-num-list.png)

## 数式
#### インライン数式
文章中に数式を埋め込むときに利用します。`$` で囲みます。
```
2次方程式の解の公式は $x = \frac{-b \pm \sqrt{b^2 - 4ac}}{2a}$ です。
```
![](/images/overleaf-tips/ex-math-inline.png)

#### ディスプレイ数式
ブロック要素的にセンタリングして数式を埋め込むときに利用します。`$$` で囲みます。
```
定積分の定義は
$$
\int_a^b f(x) dx = \lim_{n \to \infty} \sum_{i=1}^n f(x_i) \Delta x
$$
です。
```
![](/images/overleaf-tips/ex-math-display.png)

### ギリシャ文字
| 記号 | 小文字 | 大文字 | 記号 | 小文字 | 大文字 | 記号 | 小文字 | 大文字 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| $$\alpha \space \Alpha$$ | `\alpha` | `A` | $$\iota \space \Iota$$ | `\iota` | `I` | $$\rho \space \Rho$$ | `\rho` | `P` |
| $$\beta \space \Beta$$ | `\beta` | `B` | $$\kappa \space \Kappa$$ | `\kappa` | `K` | $$\sigma \space \Sigma$$ | `\sigma` | `\Sigma` |
| $$\gamma \space \Gamma$$ | `\gamma` | `\Gamma` | $$\lambda \space \Lambda$$ | `\lambda` | `\Lambda` | $$\tau \space \Tau$$ | `\tau` | `T` |
| $$\delta \space \Delta$$ | `\delta` | `\Delta` | $$\mu \space \Mu$$ | `\mu` | `M` | $$\upsilon \space \Upsilon$$ | `\upsilon` | `\Upsilon` |
| $$\epsilon \space \Epsilon$$ | `\epsilon` | `E` | $$\nu \space \Nu$$ | `\nu` | `N` | $$\phi \space \Phi$$ | `\phi` | `\Phi` |
| $$\zeta \space \Zeta$$ | `\zeta` | `Z` | $$\xi \space \Xi$$ | `\xi` | `Xi` | $$\chi \space \Chi$$ | `\chi` | `X` |
| $$\eta \space \Eta$$ | `\eta` | `H` | $$\omicron \space \Omicron$$ | `o` | `O` | $$\psi \space \Psi$$ | `\psi` | `\Psi` |
| $$\theta \space \Theta$$ | `\theta` | `\Theta` | $$\pi \space \Pi$$ | `\pi` | `\Pi` | $$\omega \space \Omega$$ | `\omega` | `\Omega` |

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
![](/images/overleaf-tips/ex-default-table.png)

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
![](/images/overleaf-tips/ex-table.png)

### Tables Generatorで表を作成する
エディタよりもGUIで表を作成したい方は [Tables Generator](https://www.tablesgenerator.com/) がオススメです。マウスでポチポチして表を作成できますし、とりあえず表を作成して叩き台にするという使い方もできます。
**Booktabs table style** を選択すると美しい表が作成できます✨
![](/images/overleaf-tips/ex-tables-generator.png)

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