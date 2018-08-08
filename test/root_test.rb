require 'test_helper'

class Sample < Minitest::Test
  def setup
    @parser = ::Pukiwiki2md::Parser.new
    @trans = ::Pukiwiki2md::Transform.new
  end

  def test_from_root
    result = @parser.parse(sample_text)
    assert_equal expectation, @trans.apply(result)
  end

  private
  def sample_text
    <<-TEXT
#contents

* Hello, World [#qb249ac2]

This is Wiki text.
Hi, God.

This text shows ''STRONG TEXT'' and '''italic text'''.
%%deleted text%% もこんなかんじ。
これは((footnote なのです))と書くと脚注になる。
[[Blog:http://example.com/blog]]はブログへのリンク。
&ref(https://example.com/foo.pdf);と書くと添付ファイルで
さらに &ref(https://example.com/picture.png); とすると画像表示

** FrontPage [#e652f146]

#br

> Quotation text
> This is also quotation text

- This is unordered list
- This is also unordered list
-- Indent level 2
--- Indent level 3

+ This is ordered list
+ This is also ordered list
++ Indent level 2
+++ Indent level 3

#ref(image.jpg)

#ref(filename.ext)

#ls

|aaa|bbb|ccc|h
| 1 | 2 | 3 |
| 4 | 5 | 6 |

| 1 | 2 | 3 |
| 4 | 5 | 6 |
| 7 | 8 | 9 |

----
- ul following to ----

: definition term 1 | and description 1
: definition term 2 | and description 2
: definition term 3 | and description 3

 This is preformatted text.
 This text is like <pre> tag.

#hr

#clear

* Hello, World

#clear but it's normal paragraph
Hello, again.
    TEXT
  end

  def expectation
    <<-TEXT
<!---
    toc
--->

# Hello, World 

This is Wiki text.
Hi, God.

This text shows  **STRONG TEXT**  and  _italic text_ .
 ~~deleted text~~  もこんなかんじ。
これは(footnote なのです)と書くと脚注になる。
[Blog](http://example.com/blog)はブログへのリンク。
[foo.pdf](https://example.com/foo.pdf)と書くと添付ファイルで
さらに ![picture.png](https://example.com/picture.png) とすると画像表示

## FrontPage 

<br />

> Quotation text
> This is also quotation text

* This is unordered list
* This is also unordered list
    * Indent level 2
        * Indent level 3

1. This is ordered list
1. This is also ordered list
    1. Indent level 2
        1. Indent level 3

![image.jpg](image.jpg)

[filename.ext](filename.ext)

<!---
    ls
--->

|aaa|bbb|ccc|
| --- | --- | --- |
| 1 | 2 | 3 |
| 4 | 5 | 6 |

| | | |
| --- | --- | --- |
| 1 | 2 | 3 |
| 4 | 5 | 6 |
| 7 | 8 | 9 |

---
* ul following to ----

<dl>
    <dt>definition term 1 </dt>
    <dd>and description 1</dd>
    <dt>definition term 2 </dt>
    <dd>and description 2</dd>
    <dt>definition term 3 </dt>
    <dd>and description 3</dd>
</dl>

```
This is preformatted text.
This text is like <pre> tag.
```

---

<!---
    clear
--->

# Hello, World

#clear but it's normal paragraph
Hello, again.
    TEXT
  end
end
