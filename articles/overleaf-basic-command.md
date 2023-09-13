---
title: "Overleaf の基本コマンド"
emoji: "🌿"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [LaTeX,Overleaf]
published: false
---

## 基本のコマンド
### セクション・サブセクション
```
\section{こうするとセクションになります}
\subsection{サブセクションも作れますよ}
\subsubsection{サブのサブも作れます}
```
![](/images/overleaf-basic-command/ex-section.png)

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
![](/images/overleaf-basic-command/ex-par.png)

### 改行
```
こうすると段落内で\\強制的に改行することができます。
```
![](/images/overleaf-basic-command/ex-new-line.png)

### 文字
```
これは\textbf{太字}です。
こうすると\textit{SYATAI}になります。
重要な箇所は\underline{下線}を引いてもよいでしょう。
```
![](/images/overleaf-basic-command/ex-char.png)

#### 上付き文字・下付き文字
```
これは\textsuperscript{上付き文字}です。
こうすると\textsubscript{下付き文字}になります。
```
![](/images/overleaf-basic-command/ex-sup-sub.png)

### 箇条書き
```
\begin{itemize}
    \item Go
    \item TypeScript
    \item Python
\end{itemize}
```
![](/images/overleaf-basic-command/ex-list.png)

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
![](/images/overleaf-basic-command/ex-nested-list.png)

### 番号付きリスト
```
\begin{enumerate}
  \item フシギダネ
  \item フシギソウ
  \item フシギバナ
\end{enumerate}
```
![](/images/overleaf-basic-command/ex-num-list.png)

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
![](/images/overleaf-basic-command/ex-nested-num-list.png)
