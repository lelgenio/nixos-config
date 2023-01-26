# {{@@ header() @@}}

map global normal <c-d> 10j
map global normal <c-u> 10k

map global normal <c-r> 10j
map global normal <c-w> 10k

# alt i makes searches case insensitive
map global prompt <a-i> '<c-a>(?i)<c-e>'

######################################################
# Emacs-like insert
######################################################

map global insert <c-b> "<a-;>h"
map global insert <c-f> "<a-;>l"

map global insert <a-b> "<a-;>b"
map global insert <a-f> "<a-;>w"

map global insert <c-a> "<a-;>gi"
map global insert <c-e> "<a-;>gh<a-;>gl<right>"
map global insert <c-w> "<a-;>b<a-;>d"


######################################################
# Other insert binds
######################################################

map global insert <a-k> "<esc>"
map global insert <c-t> "<esc>"


######################################################
# Objects
######################################################

map global object m %{c^[<lt>=|]{4\,}[^\n]*\n,^[<gt>=|]{4\,}[^\n]*\n<ret>} -docstring 'git conflict markers'
map global object M %{c^<lt>{4\,}[^\n]*\n,^<gt>{4\,}[^\n]*\n<ret>} -docstring 'git conflict'

