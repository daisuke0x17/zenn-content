---
title: "autostashでstashとpopを楽にできた"
emoji: "🦥"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["Git"]
published: true
published_at: "2023-08-31 00:00"
---

## 結論
- `pull`のときに`--autostash`オプションをつける
  - `pull`の前に`stash`してくれて、さらに`pull`が終わったら`pop`までしてくれます
- グローバルに設定することもできます
```
git config --global pull.autostash true
```
※ `rebase`のときも同様に`--autostash`をつけることで`autostash`が有効になります。

## はじめに
ローカルに未コミットの変更がある状態で`pull`することはありませんか？そんなときは`stash`して`pull`して、`pull`が終わったら`pop`していました。これがなんとも面倒ですよね。
そんなときに便利なのがオプションがありました！`autostash`です✨ この記事では`autostash`の使い方を紹介します。

## autostash の使い方
### pull するとき
`autostash`は`pull`のオプションなので、`pull`のときに`--autostash`をつけるだけでOKです。
（※後述しますが`rebase`でも使えます！）

```bash
git pull --autostash
```
### rebase するとき
`rebase`のときも同様に`--autostash`をつけるだけでOKです。

```bash
git rebase --autostash
```

## グローバルに設定する
`autostash`はデフォルトでは無効（`false`）になっています。なので、`pull`するときに毎回`--autostash`をつけなければなりません。毎回つけるのは面倒だ！というときは、グローバルに設定してしまいましょう🥳
```bash
# pull
git config --global pull.autostash true

# rebase
git config --global rebase.autoStash true
```
これで`pull`するときに`--autostash`をつけなくても`autostash`が有効になります。

### autostash してほしくないとき
グローバルに設定したけれど`autostash`してほしくないときもあるかと思います。そんなときは`--no-autostash`をつけることで無効にできます。
```bash
# pull
git pull --no-autostash

# rebase
git rebase --no-autostash
```

## おまけ
`autostash`を紹介しましたが、それでも手動で`pop`する機会はありますよね。`git stash list`で`stash`の一覧を確認して、`pop`したい`stash`の番号を探して、0番目を`pop`したいときは
```bash
git stash pop stash@{0}
```
としていましたが
```bash
git stash pop 0
```
とできることを最近知りました😇`stash@{0}`を`0`に省略できるんですね！

## 参考
- https://git-scm.com/docs/git-pull#Documentation/git-pull.txt---autostash
- https://git-scm.com/docs/git-rebase#Documentation/git-rebase.txt---autostash
- https://git-scm.com/docs/git-config#Documentation/git-config.txt-rebaseautoStash
