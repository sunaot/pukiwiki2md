# Pukiwiki2md

Pukiwiki2md is a PEG (Parsing Expression Grammar) implementation of PukiWiki parser and transforms PukiWiki notation to Markdown notation. You can use it as a converter with a little code as follows:

## Usage

```
parser = Pukiwiki2md::Parser.new
transform = Pukiwiki2md::Transform.new
tree = parser.parse(wiki_text)
markdown_text = transform.apply(tree)
```


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sunaot/pukiwiki2md.


## License

`pukiwiki2md` gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

