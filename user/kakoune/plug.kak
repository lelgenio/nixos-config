nop %sh{
    PLUG_DIR="${HOME}/.cache/kakoune_plugins"
    REPO="https://github.com/andreyorst/plug.kak.git"

    mkdir -p "$PLUG_DIR"

    test -d "${PLUG_DIR}/plug.kak" ||
        git clone "$REPO" "${PLUG_DIR}/plug.kak"
}

source %sh{ echo "${HOME}/.cache/kakoune_plugins/plug.kak/rc/plug.kak" }

plug "andreyorst/plug.kak" noload config %{
    # Auto install every pluging
    set-option global plug_always_ensure true
    set-option global plug_install_dir %sh{ echo "${HOME}/.cache/kakoune_plugins" }
}

plug 'eraserhd/kak-ansi'

plug 'alexherbo2/auto-pairs.kak' config %{
    enable-auto-pairs
}

plug 'lelgenio/kakoune-mirror-colemak' config %{
    map global user "s" ': enter-user-mode mirror<ret>' -docstring 'mirror mode'
}

plug 'delapouite/kakoune-palette'
plug 'greenfork/active-window.kak'
plug 'lelgenio/kak-crosshairs' config %{
    crosshairs-enable
}

# Search and replace, for every buffer
plug "natasky/kakoune-multi-file"

plug "lelgenio/kakoune-colemak-neio"
