try %{
    # declare-user-mode surround
    declare-user-mode git
}

map global user 'v'    ': enter-user-mode git<ret>' -docstring 'git vcs mode'
map global user 'V'    ': enter-user-mode -lock git<ret>' -docstring 'git vcs mode'

# show status
map global git 's'     ': git status<ret>' -docstring 'status'
map global git 'S'     '_: git show %val{selection} --<ret>' -docstring 'show'
map global git 'g'     ': git-graph <ret>' -docstring 'graph all commits'
map global git 'G'     ': git-graph-simpified <ret>' -docstring 'graph all branches'
map global git '<a-g>' ': git-graph-with-remotes<ret>' -docstring 'graph all branches and remotes'
map global git 'd'     ': git diff %reg{%}<ret>' -docstring 'diff current'
map global git 'D'     ': git diff<ret>' -docstring 'diff all'
map global git '<a-d>' ': git diff --staged<ret>' -docstring 'diff staged'

map global git 'n'     ': git next-hunk <ret>' -docstring 'next git modification'
map global git 'p'     ': git prev-hunk <ret>' -docstring 'previous git modification'

# make commits
map global git 'a'     ': git add<ret>' -docstring 'add current'
map global git 'A'     ': git add --all<ret>' -docstring 'add all'
map global git 'c'     ': git commit -v<ret>' -docstring 'commit'

# discard work
map global git 'r'     ': git checkout %reg{%}<ret>' -docstring 'restore current'

# deal with merges
map global git 'N'     ': git-next-merge-conflict <ret>' -docstring 'next git merge conflict'
map global git 'P'     ': git-prev-merge-conflict <ret>' -docstring 'previous git merge conflict'
map global git 'm'     ': git-merge-head <ret>' -docstring 'merge using head'
map global git 'M'     ': git-merge-new <ret>' -docstring 'merge using new'
map global git '<a-m>' ': git-merge-original <ret>' -docstring 'merge using original'

define-command -override git-next-merge-conflict %{
    try %{
        execute-keys /^<lt>{6,}.*?^<gt>{6,}.*?$<ret>
    } catch %{
        fail "No hunks found forward"
    }
} -docstring "next git merge hunk"

define-command -override git-prev-merge-conflict %{
    try %{
        execute-keys <a-/>^<lt>{6,}.*?^<gt>{6,}.*?$<ret>
    } catch %{
        fail "No hunks found backwards"
    }
} -docstring "previous git merge hunk"

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

define-command -override git-graph %{
    try %{ delete-buffer '*git-graph*' }
    edit -scratch '*git-graph*'
    execute-keys '<a-!> timeout 10s git graph --color=always --decorate --branches<ret>'
    execute-keys 'gg'
    try ansi-render
    map buffer normal q ': delete-buffer!<ret>'
}

define-command -override git-graph-simpified %{
    try %{ delete-buffer '*git-graph*' }
    edit -scratch '*git-graph*'
    execute-keys '<a-!> timeout 10s git graph --color=always --decorate --all --simplify-by-decoration<ret>'
    execute-keys 'gg'
    try ansi-render
    map buffer normal q ': delete-buffer!<ret>'
}

define-command -override git-graph-with-remotes %{
    try %{ delete-buffer '*git-graph*' }
    edit -scratch '*git-graph*'
    execute-keys '<a-!> timeout 10s git graph --color=always --decorate --all<ret>'
    execute-keys 'gg'
    try ansi-render
    map buffer normal q ': delete-buffer!<ret>'
}
