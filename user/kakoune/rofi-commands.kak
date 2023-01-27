define-command -override -hidden find_file \
%{ evaluate-commands %sh{
    for line in `rofi -sort -show file-browser-extended -file-browser-depth 0 -file-browser-no-descend -file-browser-stdout -p "File: "`; do
        echo "edit '$line'"
    done
} }

define-command -override -hidden find_delete \
%{ nop %sh{
    rofi -sort -show file-browser-extended -file-browser-depth 0 -file-browser-no-descend -file-browser-stdout | xargs -r trash
} }

define-command -override -hidden find_git_file \
%{ evaluate-commands %sh{
    for line in `git ls-files | rofi -sort -show file-browser-extended -file-browser-depth 0 -file-browser-no-descend -file-browser-stdout -file-browser-stdin`; do
        echo "edit -existing '$line'"
    done
} }

define-command -override -hidden find_git_modified \
%{ evaluate-commands %sh{
    for line in `git status --porcelain | sd '^.. ' ''| rofi -sort -show file-browser-extended -file-browser-no-descend -file-browser-stdout -file-browser-stdin`; do
        echo "edit -existing '$line'"
    done
} }

define-command -override -hidden find_dir \
%{ cd %sh{
    for line in `fd --strip-cwd-prefix -Htd |  rofi -sort -show file-browser-extended -file-browser-no-descend -file-browser-stdout -file-browser-stdin`; do
        echo "edit '$line'"
    done
} }

define-command -override -hidden find_buffer \
%{ evaluate-commands %sh{
    for line in `printf "%s\n" $kak_buflist | wdmenu -i`; do
        echo "buffer '$line'"
    done
} }

define-command -override -hidden tree \
%{ evaluate-commands %sh{
    for line in `rofi -sort -show file-browser-extended -file-browser-stdout`; do
        echo "edit '$line'"
    done
} }
