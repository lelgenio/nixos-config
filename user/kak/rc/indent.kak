# {{@@ header() @@}}
#  _  __     _
# | |/ /__ _| | _____  _   _ _ __   ___
# | ' // _` | |/ / _ \| | | | '_ \ / _ \
# | . \ (_| |   < (_) | |_| | | | |  __/
# |_|\_\__,_|_|\_\___/ \__,_|_| |_|\___|

set global tabstop 4

hook global BufCreate .*\.py %{
    set global indentwidth 4
}

#################################################################
# Spaces
#################################################################

set global indentwidth 4

# use spaces insted of tabs
hook global BufCreate .* %{
    hook buffer InsertChar \t %{
        exec -draft -itersel h@
    } -group replace-tabs-with-spaces
}

hook global WinSetOption filetype=makefile %{
    remove-hooks buffer replace-tabs-with-spaces
}
