try %{
    # declare-user-mode surround
    declare-user-mode git
}

map global user 'v'    ': enter-user-mode git<ret>' -docstring 'git vcs mode'
map global user 'V'    ': enter-user-mode -lock git<ret>' -docstring 'git vcs mode'
map global git 's'     ': git status<ret>' -docstring 'status'
map global git 'S'     '_: git show %val{selection} --<ret>' -docstring 'show'
map global git 'a'     ': git add<ret>' -docstring 'add current'
map global git 'd'     ': git diff %reg{%}<ret>' -docstring 'diff current'
map global git 'r'     ': git checkout %reg{%}<ret>' -docstring 'restore current'
map global git 'A'     ': git add --all<ret>' -docstring 'add all'
map global git 'D'     ': git diff<ret>' -docstring 'diff all'
map global git '<a-d>' ': git diff --staged<ret>' -docstring 'diff staged'
map global git 'c'     ': git commit -v<ret>' -docstring 'commit'
map global git 'u'     ': git update-diff<ret>' -docstring 'update gutter diff'
map global git 'n'     ': git next-hunk <ret>' -docstring 'next hunk'
map global git 'p'     ': git prev-hunk <ret>' -docstring 'previous hunk'
map global git 'm'     ': git-merge-head <ret>' -docstring 'merge using head'
map global git 'M'     ': git-merge-new <ret>' -docstring 'merge using new'
map global git '<a-m>' ': git-merge-original <ret>' -docstring 'merge using original'

define-command -override git-merge-head %{
    evaluate-commands -draft %{
        # delete head marker
        execute-keys <a-/>^<lt>{4,}<ret><a-x>d
        try %{
            # select original marker
            execute-keys /^[|]{4,}<ret>
            # extend to theirs marker
            execute-keys ?^={4,}<ret><a-x>
        } catch %{
            # select theirs marker
            execute-keys /^={4,}<ret><a-x>
        }
        # extend to end marker
        execute-keys ?^<gt>{4,}<ret><a-x>d
    }
} -docstring "merge using head"

define-command -override git-merge-original %{
    evaluate-commands -draft %{
        # select head marker
        execute-keys <a-/>^<lt>{4,}<ret>
        # select to middle of conflict
        execute-keys ?^[|]{4,}<ret><a-x>d
        # select theirs marker
        execute-keys /^={4,}<ret>
        # extend to end marker
        execute-keys ?^<gt>{4,}<ret><a-x>d
    }
} -docstring "merge using original"

define-command -override git-merge-new %{
    evaluate-commands -draft %{
        # select head marker
        execute-keys <a-/>^<lt>{4,}<ret>
        # extend to theirs marker
        execute-keys ?^={4,}\n<ret>d
        # delete end marker
        execute-keys /^<gt>{4,}<ret><a-x>d
    }
} -docstring "merge using new"
