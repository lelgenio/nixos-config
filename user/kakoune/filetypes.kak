
try %{
    require-module python
    add-highlighter shared/python/code/function regex '\b([a-zA-Z_][a-zA-Z0-9_]*)\s*\(' 1:function
}

hook global WinSetOption filetype=sh %{
    set buffer formatcmd 'shfmt -s -ci -i "4"'
}
hook global WinSetOption filetype=c %{
    set buffer formatcmd 'clang-format'
}

hook global WinSetOption filetype=nix %{
    set buffer formatcmd 'nixfmt'
}

hook global BufCreate .*\.html %{
    set buffer formatcmd 'prettier --parser html'
}

hook global BufCreate .*\.component\.html %{
    set buffer filetype angular
}

hook global WinSetOption filetype=angular %[
    set-option buffer extra_word_chars '_' '-'

    require-module html
    add-highlighter buffer/angular ref html
]

hook global BufCreate .*\.js %{
    set buffer formatcmd 'prettier --parser babel'
}

hook global BufCreate .*\.vue %{
    set buffer formatcmd 'prettier --parser vue'
    hook buffer InsertCompletionHide {
      execute-keys 'Ghs$1<ret>c'
    }
}

hook global BufCreate .*\.jsonc %[ set buffer filetype jsonc ]
hook global BufCreate .*\.blade.php %[ set buffer filetype blade ]
hook global BufCreate .*\.less %[ set buffer filetype less ]
hook global BufCreate .*\.(tera|askama)\.?.* %[
    require-module jinja
    add-highlighter buffer/jinja ref jinja
]

hook global WinSetOption filetype=rust %[
  require-module rust

  add-highlighter window/rust-custom regions

  require-module html
  add-highlighter window/rust-custom/html region -recurse '\{' '(html|view)!\s*\{\K' '(?=\})' ref html

  require-module sql
  add-highlighter window/rust-custom/sql region 'r#"\K--\s*sql' '"#' group
  add-highlighter window/rust-custom/sql/ fill white
  add-highlighter window/rust-custom/sql/ ref sql
]

hook global WinSetOption filetype=sql %[
    set buffer comment_line '--'
]

hook global WinSetOption filetype=jsonc %[
    set buffer comment_line '//'

    require-module json
    add-highlighter buffer/jsonc regions
    add-highlighter buffer/jsonc/base default-region ref json
    add-highlighter buffer/jsonc/double_string region ["] ["] fill string
    add-highlighter buffer/jsonc/line-comment region // $ fill comment
]


hook global WinSetOption filetype=blade %[
    set buffer formatcmd 'blade-formatter \
            --end-with-newline \
            --indent-size "4" \
            --wrap-line-length "80" \
            --stdin'
    set-option buffer extra_word_chars '_' '-'

    hook window ModeChange pop:insert:.* -group blade-trim-indent  blade-trim-indent
    hook window InsertChar .* -group blade-indent blade-indent-on-char
    hook window InsertChar \n -group blade-indent blade-indent-on-new-line

    hook -once -always window WinSetOption filetype=.* %{ remove-hooks window blade-.+ }

    require-module php
    require-module javascript

    add-highlighter buffer/blade regions
    add-highlighter buffer/blade/base default-region group

    add-highlighter buffer/blade/string region '"' '"' regions
    add-highlighter buffer/blade/string/base default-region fill string
    add-highlighter buffer/blade/string/expression region '\{\{(?!--)' '(?!--)\}\}' ref php
    add-highlighter buffer/blade/string/raw-expression region '\{!!' '!!\}' ref php

    add-highlighter buffer/blade/base/ ref html

    add-highlighter buffer/blade/php  region '@php' '@endphp' group
    add-highlighter buffer/blade/php/ ref php
    add-highlighter buffer/blade/php/ regex '@((end)?php)' 1:block

    add-highlighter buffer/blade/js  region '<script>' '</script>' group
    add-highlighter buffer/blade/js/ ref javascript

    add-highlighter buffer/blade/expression region '\{\{(?!--)' '(?!--)\}\}' ref php
    add-highlighter buffer/blade/statement  region -recurse '\(' '@(if|foreach|for|section|yield|include)\s*\(' '\)' ref php
    add-highlighter buffer/blade/base/      regex '@(else(if)?|include|case|break)' 1:keyword
    add-highlighter buffer/blade/base/      regex '@((end)?(if|isset|foreach|for|section|switch))' 1:keyword

    add-highlighter buffer/blade/comment    region '\{\{--' '--\}\}' fill comment
    set-option buffer comment_block_begin '{{-- '
    set-option buffer comment_block_end   ' --}}'

    map buffer user 'c' '<a-x>_: comment-block<ret><a-;>;' -docstring 'comment block'
]

try %§

define-command -hidden blade-trim-indent %{
    # remove trailing white spaces
    try %{ execute-keys -draft -itersel <a-x> s \h+$ <ret> d }
}

define-command -hidden blade-indent-on-char %<
    evaluate-commands -draft -itersel %<
        # align closer token to its opener when alone on a line
        try %/ execute-keys -draft <a-h> <a-k> ^\h+[\]}]$ <ret> m s \A|.\z <ret> 1<a-&> /
    >
>

define-command -hidden blade-indent-on-new-line %<
    evaluate-commands -draft -itersel %<
        # copy // comments or docblock * prefix and following white spaces
        try %{ execute-keys -draft s [^/] <ret> k <a-x> s ^\h*\K(?://|[*][^/])\h* <ret> y gh j P }
        # preserve previous line indent
        try %{ execute-keys -draft <semicolon> K <a-&> }
        # filter previous line
        try %{ execute-keys -draft k : blade-trim-indent <ret> }
        # indent after lines beginning / ending with opener token
        try %_ execute-keys -draft k <a-x> <a-k> ^\h*[[{]|[[{]$ <ret> j <a-gt> _
        # append " * " on lines starting a multiline /** or /* comment
    	try %{ execute-keys -draft k <a-x> s ^\h*/[*][* ]? <ret> j gi i <space>*<space> }
    	# deindent closer token(s) when after cursor
    	try %_ execute-keys -draft <a-x> <a-k> ^\h*[})] <ret> gh / [})] <ret> m <a-S> 1<a-&> _
    >
>
§

hook global WinSetOption filetype=less  %[
    set buffer formatcmd 'prettier \
            --tab-width "4" \
            --print-width "80" \
        	--parser less'

    set-option buffer extra_word_chars '_' '-'

    set buffer comment_line '//'
    set buffer comment_block_begin '/*'
    set buffer comment_block_end   '*/'

    hook window ModeChange pop:insert:.* -group less-trim-indent  less-trim-indent
    hook window InsertChar \n -group less-indent less-indent-on-new-line
    hook window InsertChar \} -group less-indent less-indent-on-closing-curly-brace

    map buffer insert <c-k> '<esc>xs\$\d+<ret>) c'

    hook -once -always window WinSetOption filetype=.* %{ remove-hooks window less-.+ }

    add-highlighter buffer/less regions
    add-highlighter buffer/less/code default-region group

    add-highlighter buffer/less/line-comment region // $ fill comment
    add-highlighter buffer/less/comment region /[*] [*]/ fill comment
    add-highlighter buffer/less/double_string region ["] ["] fill string
    add-highlighter buffer/less/single_string region ['] ['] fill string

    add-highlighter buffer/less/code/ regex ([A-Za-z][A-Za-z0-9_-]*)\h*: 1:keyword
    add-highlighter buffer/less/code/ regex ::?(\w+) 0:attribute
    add-highlighter buffer/less/code/ regex !important 0:keyword

    add-highlighter buffer/less/code/selector   group
    add-highlighter buffer/less/code/selector/ regex         [A-Za-z][A-Za-z0-9_-]* 0:keyword
    add-highlighter buffer/less/code/selector/ regex [*]|[#.][A-Za-z][A-Za-z0-9_-]* 0:variable
    add-highlighter buffer/less/code/selector/ regex &([A-Za-z0-9_-]*) 1:variable
    add-highlighter buffer/less/code/selector/ regex & 0:operator
    add-highlighter buffer/less/code/selector/ regex (\.?[A-Za-z][A-Za-z0-9_-]*)\s*\( 1:function

    add-highlighter buffer/less/code/ regex (\b(\d*\.)?\d+(ch|cm|em|ex|mm|pc|pt|px|rem|vh|vmax|vmin|vw|%|s|ms)?) 0:value 3:type
    add-highlighter buffer/less/code/ regex (#)[0-9A-Fa-f]{3}([0-9A-Fa-f]{3}([0-9A-Fa-f]{2})?)?\b 0:value 1:operator

    add-highlighter buffer/less/code/ regex (?i)\b(AliceBlue|AntiqueWhite|Aqua|Aquamarine|Azure|Beige|Bisque|Black|BlanchedAlmond|Blue|BlueViolet|Brown|BurlyWood|CadetBlue|Chartreuse|Chocolate|Coral|CornflowerBlue|Cornsilk|Crimson|Cyan|DarkBlue|DarkCyan|DarkGoldenRod|DarkGray|DarkGrey|DarkGreen|DarkKhaki|DarkMagenta|DarkOliveGreen|DarkOrange|DarkOrchid|DarkRed|DarkSalmon|DarkSeaGreen|DarkSlateBlue|DarkSlateGray|DarkSlateGrey|DarkTurquoise|DarkViolet|DeepPink|DeepSkyBlue|DimGray|DimGrey|DodgerBlue|FireBrick|FloralWhite|ForestGreen|Fuchsia|Gainsboro|GhostWhite|Gold|GoldenRod|Gray|Grey|Green|GreenYellow|HoneyDew|HotPink|IndianRed|Indigo|Ivory|Khaki|Lavender|LavenderBlush|LawnGreen|LemonChiffon|LightBlue|LightCoral|LightCyan|LightGoldenRodYellow|LightGray|LightGrey|LightGreen|LightPink|LightSalmon|LightSeaGreen|LightSkyBlue|LightSlateGray|LightSlateGrey|LightSteelBlue|LightYellow|Lime|LimeGreen|Linen|Magenta|Maroon|MediumAquaMarine|MediumBlue|MediumOrchid|MediumPurple|MediumSeaGreen|MediumSlateBlue|MediumSpringGreen|MediumTurquoise|MediumVioletRed|MidnightBlue|MintCream|MistyRose|Moccasin|NavajoWhite|Navy|OldLace|Olive|OliveDrab|Orange|OrangeRed|Orchid|PaleGoldenRod|PaleGreen|PaleTurquoise|PaleVioletRed|PapayaWhip|PeachPuff|Peru|Pink|Plum|PowderBlue|Purple|RebeccaPurple|Red|RosyBrown|RoyalBlue|SaddleBrown|Salmon|SandyBrown|SeaGreen|SeaShell|Sienna|Silver|SkyBlue|SlateBlue|SlateGray|SlateGrey|Snow|SpringGreen|SteelBlue|Tan|Teal|Thistle|Tomato|Turquoise|Violet|Wheat|White|WhiteSmoke|Yellow|YellowGreen)\b 0:value

    add-highlighter buffer/less/code/ regex ([\w-_]+)\s*: 1:attribute
    add-highlighter buffer/less/code/ regex @[\w\d-_]+ 0:variable

]

try %§

define-command -hidden less-trim-indent %{
    # remove trailing white spaces
    try %{ execute-keys -draft -itersel <a-x> s \h+$ <ret> d }
}

define-command -hidden less-indent-on-new-line %[
    evaluate-commands -draft -itersel %[
        # preserve previous line indent
        try %[ execute-keys -draft <semicolon> K <a-&> ]
        # filter previous line
        try %[ execute-keys -draft k : less-trim-indent <ret> ]
        # indent after lines ending with with {
        try %[ execute-keys -draft k <a-x> <a-k> \{$ <ret> j <a-gt> ]
        # deindent closing brace when after cursor
        try %[ execute-keys -draft <a-x> <a-k> ^\h*\} <ret> gh / \} <ret> m <a-S> 1<a-&> ]
    ]
]

define-command -hidden less-indent-on-closing-curly-brace %[
    evaluate-commands -draft -itersel %[
        # align to opening curly brace when alone on a line
        try %[ execute-keys -draft <a-h> <a-k> ^\h+\}$ <ret> m s \A|.\z <ret> 1<a-&> ]
    ]
]

§
