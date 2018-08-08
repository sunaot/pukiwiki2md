# Pukiwiki2md

[![Build Status](https://travis-ci.org/sunaot/pukiwiki2md.svg?branch=master)](https://travis-ci.org/sunaot/pukiwiki2md)
[![Coverage Status](https://coveralls.io/repos/github/sunaot/pukiwiki2md/badge.svg?branch=master)](https://coveralls.io/github/sunaot/pukiwiki2md?branch=master)

Pukiwiki2md is a PEG (Parsing Expression Grammar) implementation of PukiWiki parser and transforms PukiWiki notation to Markdown notation. You can use it as a converter with a little code as follows:

## Usage

```
parser = Pukiwiki2md::Parser.new
transform = Pukiwiki2md::Transform.new
tree = parser.parse(wiki_text)
markdown_text = transform.apply(tree)
```

## Supporting PukiWiki notations

https://pukiwiki.osdn.jp/?FormattingRules

### ブロック要素

- 段落
- 引用文
- リスト構造 (一部非対応)
- 整形済みテキスト
- 表組み (一部非対応)
- 見出し
- 水平線
- 行間空け
- 添付ファイル・画像の貼り付け (一部非対応)

### インライン要素

- 文字列
- 改行
- 強調・斜体
- 取消線
- 注釈
- 添付ファイル・画像の貼り付け (一部非対応)
- ページ名 (一部非対応)
- InterWiki (一部非対応)
- リンク
- エイリアス (一部非対応)

## Non-supporting PukiWiki notations

https://pukiwiki.osdn.jp/?FormattingRules

### ブロック要素

- CSV形式の表組み
- 目次
- 左寄せ・センタリング・右寄せ
- テキストの回り込みの解除
- フォーム

### インライン要素

- 文字サイズ
- 文字色
- ルビ構造
- アンカーの設定
- カウンタ表示
- オンライン表示
- バージョン表示
- タブコード
- ページ名置換文字
- 日時置換文字
- 文字参照文字
- 数値参照文字

### その他

- コメント行

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sunaot/pukiwiki2md.


## License

`pukiwiki2md` gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

