---
title: "Overleaf で数式を作成する"
emoji: "🌿"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [LaTeX,Overleaf]
published: false
---

## 数式
#### インライン数式
文章中に数式を埋め込むときに利用します。`$` で囲みます。
```
2次方程式の解の公式は $x = \frac{-b \pm \sqrt{b^2 - 4ac}}{2a}$ です。
```
![](/images/overleaf-math/ex-math-inline.png)

#### ディスプレイ数式
ブロック要素的にセンタリングして数式を埋め込むときに利用します。`$$` で囲みます。
```
定積分の定義は
$$
\int_a^b f(x) dx = \lim_{n \to \infty} \sum_{i=1}^n f(x_i) \Delta x
$$
です。
```
![](/images/overleaf-math/ex-math-display.png)

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
