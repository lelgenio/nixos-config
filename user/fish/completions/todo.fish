set __fish_complete_todoman_subcomands cancel copy delete done edit flush list move new show
function __fish_complete_todoman_not_subcomand
    not __fish_seen_subcommand_from $__fish_complete_todoman_subcomands
end

function __fish_complete_todoman_list_todos
    todo list |
        string replace -r '^\[.\] ' "" |
        string replace -r ' ' '\t' |
        string replace -r '\t!*' '\t' |
        string replace -r '\(.*?\)' ""
end

function __fish_complete_todoman_config_path
    set -q XDG_CONFIG_DIR
    or set -l XDG_CONFIG_DIR "$HOME/.config"

    set -l config_path "$XDG_CONFIG_DIR/todoman/config.py"

    test -f "$config_path"
    and echo "$config_path"
end

function __fish_complete_todoman_lists_dir
    set -l config_path (__fish_complete_todoman_config_path)
    or return

    # looks something like "~/.local/share/calendars/*"
    string replace -fr 'path\s*=\s*"(.*)"\s*$' '$1' < $config_path |
    string replace -r '^~' "$HOME" |
    string replace -r '\*$' ''
end

function __fish_complete_todoman_list_lists
    set -l lists_path (__fish_complete_todoman_lists_dir)
    string replace -r '.*/(.*?)$' '$1' $lists_path/*
end


#### Initial command definition ####
complete --erase todo
complete -c todo -f

#### Base command flags ####
complete -c todo -n __fish_complete_todoman_not_subcomand -s v -l verbosity -a "CRITICAL ERROR WARNING INFO DEBUG"
complete -c todo -n __fish_complete_todoman_not_subcomand -l colour -l color -a "always auto never"
complete -c todo -n __fish_complete_todoman_not_subcomand -l porcelain -a "Use a stable JSON format"
complete -c todo -n __fish_complete_todoman_not_subcomand -s h -l humanize -a "Format all dates and times in a human friendly way"
complete -c todo -n __fish_complete_todoman_not_subcomand -s c -l config -a "The config file to use."
complete -c todo -n __fish_complete_todoman_not_subcomand -l version -d "Show the version and exit."
complete -c todo -n __fish_complete_todoman_not_subcomand -l help -d "Show this message and exit."

#### Subcommands ####
complete -c todo -n __fish_complete_todoman_not_subcomand -a cancel -d 'Cancel one or more tasks'
complete -c todo -n __fish_complete_todoman_not_subcomand -a copy -d 'Copy tasks to another list'
complete -c todo -n __fish_complete_todoman_not_subcomand -a delete -d 'Delete tasks'
complete -c todo -n __fish_complete_todoman_not_subcomand -a done -d 'Mark one or more tasks as done'
complete -c todo -n __fish_complete_todoman_not_subcomand -a edit -d 'Edit the task with id ID'
complete -c todo -n __fish_complete_todoman_not_subcomand -a flush -d 'Delete done tasks'
complete -c todo -n __fish_complete_todoman_not_subcomand -a list -d 'List tasks'
complete -c todo -n __fish_complete_todoman_not_subcomand -a move -d 'Move tasks to another list'
complete -c todo -n __fish_complete_todoman_not_subcomand -a new -d 'Create a new task with SUMMARY'
complete -c todo -n __fish_complete_todoman_not_subcomand -a show -d 'Show details about a task'

#### Subcommand flags ####

complete -c todo -n "__fish_seen_subcommand_from cancel" -a "(__fish_complete_todoman_list_todos)" -d 'Cancel one or more tasks.'
complete -c todo -n "__fish_seen_subcommand_from cancel" -l help -d 'Show this message and exit.'

complete -c todo -n "__fish_seen_subcommand_from copy" -a "(__fish_complete_todoman_list_todos)" -d 'Cancel one or more tasks.'
complete -c todo -n "__fish_seen_subcommand_from copy" -s l -l list -d 'The list to copy the tasks to.'
complete -c todo -n "__fish_seen_subcommand_from copy" -l help -d 'Show this message and exit.'

complete -c todo -n "__fish_seen_subcommand_from delete" -a "(__fish_complete_todoman_list_todos)" -d 'Delete tasks.'
complete -c todo -n "__fish_seen_subcommand_from delete" -l yes -d 'Confirm the action without prompting.'
complete -c todo -n "__fish_seen_subcommand_from delete" -l help -d 'Show this message and exit.'

complete -c todo -n "__fish_seen_subcommand_from done" -a "(__fish_complete_todoman_list_todos)" -d 'Mark one or more tasks as done.'
complete -c todo -n "__fish_seen_subcommand_from done" -l help -d 'Show this message and exit.'

complete -c todo -n "__fish_seen_subcommand_from edit" -a "(__fish_complete_todoman_list_todos)" -d 'Edit the task with id ID.'
complete -c todo -n "__fish_seen_subcommand_from edit" -l raw -d 'Open the raw file for editing in $EDITOR. Only use this'
complete -c todo -n "__fish_seen_subcommand_from edit" -s s -l start -r -d 'When the task starts.'
complete -c todo -n "__fish_seen_subcommand_from edit" -s d -l due -r -d 'Due date of the task, in the format specified in the configuration.'
complete -c todo -n "__fish_seen_subcommand_from edit" -l location -r -d 'The location where this todo takes place.'
complete -c todo -n "__fish_seen_subcommand_from edit" -l priority -r -d 'Priority for this task'
complete -c todo -n "__fish_seen_subcommand_from edit" -s i -l interactive -r -d 'Go into interactive mode before saving the task.'
complete -c todo -n "__fish_seen_subcommand_from edit" -l help -d 'Show this message and exit.'

complete -c todo -n "__fish_seen_subcommand_from flush" -d 'Delete done tasks. This will also clear the cache to reset task IDs.'
complete -c todo -n "__fish_seen_subcommand_from flush" -l yes -d 'Confirm the action without prompting.'
complete -c todo -n "__fish_seen_subcommand_from flush" -l help -d 'Show this message and exit.'

complete -c todo -n "__fish_seen_subcommand_from flush" -d 'Delete done tasks. This will also clear the cache to reset task IDs.'
complete -c todo -n "__fish_seen_subcommand_from flush" -l yes -d 'Confirm the action without prompting.'
complete -c todo -n "__fish_seen_subcommand_from flush" -l help -d 'Show this message and exit.'

complete -c todo -n "__fish_seen_subcommand_from list" -a "(__fish_complete_todoman_list_lists)" -d 'List tasks by list name'
complete -c todo -n "__fish_seen_subcommand_from list" -l location -r -d 'Only show tasks with location containg TEXT'
complete -c todo -n "__fish_seen_subcommand_from list" -l category -d "Only show tasks with category containg"
complete -c todo -n "__fish_seen_subcommand_from list" -l grep -d "Only show tasks with message containg"
complete -c todo -n "__fish_seen_subcommand_from list" -l sort -d "Sort tasks by field" -a "description location status summary uid rrule percent_complete priority sequence categories completed_at created_at dtstamp start due last_modified"
complete -c todo -n "__fish_seen_subcommand_from list" -l reverse -l no-reverse -d 'Sort tasks in reverse order (see --sort)'
complete -c todo -n "__fish_seen_subcommand_from list" -l due -d 'Only show tasks due in INTEGER hours'
complete -c todo -n "__fish_seen_subcommand_from list" -l priority -r -d 'Only show tasks with priority at least as high as' -a "low medium high"
complete -c todo -n "__fish_seen_subcommand_from list" -l start -r -d "Only shows tasks before/after given DATE"
complete -c todo -n "__fish_seen_subcommand_from list" -l startable -d "Show only todos which should can be started today"
complete -c todo -n "__fish_seen_subcommand_from list" -s s -l status -r -d "Show only todos with the provided comma-separated" -a "NEEDS-ACTION CANCELLED COMPLETED IN-PROCESS ANY"
complete -c todo -n "__fish_seen_subcommand_from list" -l help -d "Show this message and exit."

complete -c todo -n "__fish_seen_subcommand_from move" -a "(__fish_complete_todoman_list_todos)" -d 'Move tasks to another list.'
complete -c todo -n "__fish_seen_subcommand_from move" -s l -l list -a "(__fish_complete_todoman_list_lists)" -d 'The list to move the tasks to.'
complete -c todo -n "__fish_seen_subcommand_from move" -l help -d 'Show this message and exit.'

complete -c todo -n "__fish_seen_subcommand_from new" -d 'Create a new task with SUMMARY.'
complete -c todo -n "__fish_seen_subcommand_from new" -s l -l list -a "(__fish_complete_todoman_list_lists)" -d 'List in which the task will be saved.'
complete -c todo -n "__fish_seen_subcommand_from new" -s r -l read-description -d 'Read task description from stdin.'
complete -c todo -n "__fish_seen_subcommand_from new" -s s -l start -d 'When the task starts.'
complete -c todo -n "__fish_seen_subcommand_from new" -s d -l due -d 'Due date of the task, in the format specified in the configuration.'
complete -c todo -n "__fish_seen_subcommand_from new" -l location -d 'The location where this todo takes place.'
complete -c todo -n "__fish_seen_subcommand_from new" -s i -l interactive -d 'Go into interactive mode before saving the task.'
complete -c todo -n "__fish_seen_subcommand_from new" -l help -d 'Show this message and exit.'

complete -c todo -n "__fish_seen_subcommand_from show" -a "(__fish_complete_todoman_list_todos)" -d 'Show details about a task.'
