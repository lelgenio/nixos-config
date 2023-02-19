#{{@@ header() @@}}
#   __ _     _
#  / _(_)___| |__
# | |_| / __| '_ \
# |  _| \__ \ | | |
# |_| |_|___/_| |_|


# Fine, I'll do it myself
function fish_vi_cursor;end
function fish_mode_prompt;end


############################################################
# Color helpers
############################################################

function _fish_prompt_color -a color
    # separate line needed for bold normal
    set_color $color
    set_color --bold
    set -e argv[1]
    echo -en $argv
end

alias _fish_prompt_warn   "_fish_prompt_color 'yellow'"

alias _fish_prompt_normal "_fish_prompt_color 'normal'"

############################################################
# Git
############################################################

function _fish_prompt_git_status -a git_status_s code symbol color
    echo $git_status_s | string match -qr "^$code"
    and _fish_prompt_color "$color" "$symbol"
end

function _fish_prompt_git_detached
    git symbolic-ref -q HEAD &> /dev/null
        or git show --oneline -s |
        string match -r '^\w+'
end

function _fish_prompt_git_remote_branches
    git for-each-ref --format='%(refname:short)' refs/remotes
end

function _fish_prompt_git_unpushed_branches
    timeout 1s git log --branches --not --remotes --no-walk --oneline
end

function fish_git_prompt
    command -qs git
    or return

    set -l here (string replace -r '/\.git(/.*)?$' '' "$PWD")

    test -d "$here"
    or return

    pushd "$here"

    ############################################################
    # Check if in a git repo and save branch and status
    ############################################################

    set -l git_branch   (git branch --show-current 2> /dev/null);or return
    set -l git_detach   (_fish_prompt_git_detached)
    set -l git_remote_branch   (git rev-parse --abbrev-ref (git branch --show-current)@{u} 2> /dev/null)
    set -l git_status_s (timeout 1s git status -s | string collect)
    set -l git_log_unpushed (_fish_prompt_git_unpushed_branches | wc -l)

    _fish_prompt_normal " on "

    ############################################################
    # Left side represents Index/Filesystem
    ############################################################

    _fish_prompt_git_status "$git_status_s" '.M' '~' 'yellow'   # Modified
    _fish_prompt_git_status "$git_status_s" '.D' '-' 'red'      # Deleted
    _fish_prompt_git_status "$git_status_s" '\?\?' '?' 'normal' # Untraked files exist
    _fish_prompt_git_status "$git_status_s" 'UU' '!' 'yellow'   # Unmerged files exist

    # Print name of branch or checkedout commit
    if test -n "$git_detach"
       _fish_prompt_warn   "$git_detach"
    else if  test -n "$git_branch"
       _fish_prompt_accent "$git_branch"
    else
       _fish_prompt_warn "init"
    end

    # print a "↑" if ahead of origin
    if test 0 -ne (git log --oneline "$git_remote_branch"..HEAD -- | wc -l)
        or test 0 -ne "$git_log_unpushed"
        set -f _git_sync_ahead '↑'
    end

    # print a "↓" if behind of origin
    test 0 -lt (git log --oneline HEAD.."$git_remote_branch" -- | wc -l)
    and set -l _git_sync_behind '↓'

    if set -q _git_sync_ahead _git_sync_behind
        _fish_prompt_normal '⇅'
    else if set -q _git_sync_ahead
        _fish_prompt_normal '↑'
    else if set -q _git_sync_behind
        _fish_prompt_normal '↓'
    end

    ############################################################
    # Right side represents WorkTree/Staged
    ############################################################

    _fish_prompt_git_status "$git_status_s" 'A.' '+' 'green'  # New file
    _fish_prompt_git_status "$git_status_s" 'M.' '~' 'green'  # Modified
    _fish_prompt_git_status "$git_status_s" 'R.' '→' 'yellow' # Moved
    _fish_prompt_git_status "$git_status_s" 'D.' '-' 'red'    # Deletion staged

    popd
end


############################################################
# Program time indicator
############################################################

function __fish_prompt_set_last_command_start --on-event fish_preexec
    set -g __fish_prompt_last_command_start (date +%s.%N)
end

function __fish_prompt_set_last_command_end --on-event fish_postexec
    set -g __fish_prompt_last_command_end (date +%s.%N)
end

function fish_program_time_prompt
    if test -z "$__fish_prompt_last_command_start"
        or test -z "$__fish_prompt_last_command_end"
        return
    end

    set -l diff (math $__fish_prompt_last_command_end - $__fish_prompt_last_command_start)
    set -l diff (math "round ($diff * 100) / 100")

    if test "$diff" -gt 1
        _fish_prompt_normal " took "
        _fish_prompt_warn (env LC_ALL=C printf "%.02f" "$diff")
    end

    set -eg __fish_prompt_last_command_start
    set -eg __fish_prompt_last_command_end
end


############################################################
# Vi mode indicator
############################################################

function fish_vimode_prompt # Not fish_mode_prompt!

    if not test $fish_key_bindings = fish_vi_key_bindings
        printf '\e[5 q' # Bar
        return
    end

    # Set cursor shape
    if test $fish_bind_mode = insert
        printf '\e[5 q' # Bar
    else
        printf '\e[1 q' # Block
    end

    # Print mode symbol, N for normal, I for insert, etc...
    # on most cases first letter of mode name
    _fish_prompt_accent (
    switch $fish_bind_mode
        case replace_one
            printf 'o'
        case default
            printf 'n'
        case '*'
            printf (string match -r '^.' $fish_bind_mode )
    end | string upper
    )' '
end


############################################################
# Main prompt
############################################################

function fish_prompt
    # Save current status as it may be overwritten before usage
    set _status $status

    _fish_prompt_accent $USER
    _fish_prompt_normal " in "
    _fish_prompt_accent (prompt_pwd)

    if test -n "$SSH_TTY"
        _fish_prompt_normal " at "
        _fish_prompt_accent "$hostname"
    end

    if test -n "$IN_NIX_SHELL"
        _fish_prompt_normal " with "
        _fish_prompt_accent "nix"
    end

    fish_git_prompt

    fish_program_time_prompt

    # Line break
    echo

    fish_vimode_prompt

    if test $_status -ne 0
        _fish_prompt_warn "$_status "
    end

    if test $USER = root
        _fish_prompt_normal '# '
    else
        _fish_prompt_normal '$ '
    end

    # Reset colors
    set_color normal
end


# These don't seem to work
# set fish_cursor_default     block      blink
# set fish_cursor_insert      line       blink
# set fish_cursor_replace_one underscore blink
# set fish_cursor_visual      block
