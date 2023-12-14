try %{
    # declare-user-mode surround
    declare-user-mode find
}

map global user 'w' ': w<ret>' -docstring 'write buffer'
map global user 'u' ': config-source<ret>' -docstring 'source configuration'
map global user 'g' ': enter-user-mode lsp<ret>' -docstring 'lsp mode'
map global user 'z' ':zoxide ' -docstring 'zoxide'
map global user 'n' ': new<ret>' -docstring 'new window'

map global user 'e' 'x|emmet<ret>@' -docstring 'process line with emmet'
map global user 'm' ': try format-buffer catch lsp-formatting-sync<ret>' -docstring 'format document'
map global user 'M' ': try lsp-range-formatting-sync catch format-selections<ret>' -docstring 'format selection'

map global user 'c' ': comment-line<ret>' -docstring 'comment line'
map global user 'C' '_: comment-block<ret>' -docstring 'comment block'
map global user '=' 'kgh<a-i><space>yjghi<space><esc>h<a-i><space>Rgi' -docstring 'Copy previous line indentation '

map global user "s" ': enter-user-mode mirror<ret>' -docstring 'mirror mode'

map global user 'p' '! wl-paste -n<ret>' -docstring 'clipboard paste'
map global user 'P' '<a-o>j! wl-paste -n<ret>' -docstring 'clipboard paste on next line'
map global user 'R' '"_d! wl-paste -n <ret>' -docstring 'clipboard replace'
map global user 'y' ': copy-file-path<ret>' -docstring 'register name to clipboard'

map global user 'b' ': find_buffer<ret>' -docstring 'switch buffer'

map global user 'l' ': lsp-enable-decals<ret>' -docstring 'LSP enable decals'
map global user 'L' ': lsp-disable-decals<ret>' -docstring 'LSP disable decals'

map global user 'f' ': enter-user-mode find<ret>' -docstring 'find mode'
map global find 't' ': tree<ret>' -docstring 'file tree'
map global find 'f' ': find_file<ret>' -docstring 'file'
map global find 'l' ': find_line<ret>' -docstring 'jump to line'
map global find 'r' ': find_ripgrep<ret>' -docstring 'ripgrep all file'
map global find 'g' ': find_git_file<ret>' -docstring 'git files'
map global find 'm' ': find_git_modified<ret>' -docstring 'git modified files'
map global find 'c' ': find_dir<ret>' -docstring 'change dir'
map global find 'd' ': find_delete<ret>' -docstring 'file to delete'

map global user 'S' ': find_spell<ret>' -docstring 'pick language for spellchecking'

define-command -override -hidden find_spell \
%{ evaluate-commands %sh{
    for line in `aspell dump dicts | wdmenu -i -p "Language: "`; do
        echo "spell '$line'"
    done
} }

define-command -override -hidden find_file \
%{ evaluate-commands %sh{
    for line in `fd --strip-cwd-prefix -tf -HE .git | wdmenu -i -p "File: "`; do
        echo "edit '$line'"
    done
} }

define-command -override -hidden find_delete \
%{ nop %sh{
    fd --strip-cwd-prefix -H -E .git -t f | wdmenu -i | xargs -r trash
} }

define-command -override -hidden find_git_file \
%{ evaluate-commands %sh{
    for line in `git ls-files | wdmenu -i`; do
        echo "edit -existing '$line'"
    done
} }

define-command -override -hidden find_git_modified \
%{ evaluate-commands %sh{
    for line in `git status --porcelain | sd '^.. ' ''| wdmenu -i`; do
        echo "edit -existing '$line'"
    done
} }

define-command -override -hidden find_dir \
%{ cd %sh{
    for line in `fd --strip-cwd-prefix -Htd | wdmenu -i`; do
        echo "edit '$line'"
    done
} }

define-command -override -hidden find_buffer \
%{ evaluate-commands %sh{
    for line in `printf "%s\n" $kak_buflist | wdmenu -i`; do
        echo "buffer '$line'"
    done
} }

define-command -override -hidden find_ripgrep \
%{ evaluate-commands %sh{
    patter=$( wdmenu -i -p "Regex")
    rg --column -n "$patter" | wdmenu -i |
        perl -ne 'print "edit \"$1\" \"$2\" \"$3\" " if /(.+):(\d+):(\d+):/'
} }

define-command -override -hidden find_line \
%{ evaluate-commands -save-regs a %{
        execute-keys %{Z%"ayz}
        execute-keys %sh{
            line=$(
                printf "%s\n" "$kak_reg_a" |
                nl -ba -w1 |
                wdmenu -i -p "Line" |
                cut -f1
            )
            test -n "$line" && echo "${line}gx"
        }
} }

define-command -override -hidden tree \
%{ evaluate-commands %sh{
    file=`mktemp`
    terminal --class file_picker -e ranger --selectfile="$kak_buffile" --choosefiles="$file"
    for line in `cat "$file"`; do
        echo "edit '$line'"
    done
    rm "$file"
} }


define-command -override -params .. \
-shell-script-candidates 'zoxide query -l' \
zoxide %{
    cd %sh{ zoxide query -- "$@" || echo "$@" }
    echo %sh{ pwd | sed "s|$HOME|~|" }
}

define-command -override  config-source %{
    source "%val{config}/kakrc"
}

define-command -override copy-file-path %{
    nop %sh{ {
        wl-copy $kak_reg_percent
    } >/dev/null 2>&1 </dev/null & }
}
