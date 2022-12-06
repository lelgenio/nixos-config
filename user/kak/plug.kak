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
    map global user "s" ': enter-user-mode mirror<ret>'
}

plug 'delapouite/kakoune-palette'
plug 'greenfork/active-window.kak'
plug 'lelgenio/kak-crosshairs' config %{
    crosshairs-enable
}

# Search and replace, for every buffer
plug "natasky/kakoune-multi-file"

plug "lelgenio/kakoune-colemak-neio"

plug 'kak-lsp/kak-lsp' do %{
    cargo install --locked --force --path .
} config %{
    map global normal <F2> ': lsp-rename-prompt<ret>'
    set global lsp_hover_max_lines 10
    set global lsp_auto_highlight_references true
    set global lsp_inlay_diagnostic_sign "●"
    set global lsp_diagnostic_line_error_sign "●"

    hook global BufCreate   .* %{try lsp-enable}

    define-command -override -hidden lsp-next-placeholder-bind %{
        map global normal <tab> ': try lsp-snippets-select-next-placeholders catch %{ execute-keys -with-hooks <lt>tab> }<ret>' -docstring 'Select next snippet placeholder'
        map global insert <tab> '<a-;>: try lsp-snippets-select-next-placeholders catch %{ execute-keys -with-hooks <lt>tab> }<ret>' -docstring 'Select next snippet placeholder'
    }
    lsp-next-placeholder-bind
    map global insert <c-o> "<esc>: lsp-code-action-sync Fill<ret>"

    define-command -override -hidden lsp-enable-decals %{
        lsp-inlay-diagnostics-enable global
        lsp-inlay-hints-enable global
    }

    define-command -override -hidden lsp-disable-decals %{
        lsp-inlay-diagnostics-disable global
        lsp-inlay-hints-disable global
    }
    lsp-enable-decals

    hook global ModeChange '.*:insert:normal' %{lsp-enable-decals}
    hook global ModeChange '.*:normal:insert' %{lsp-disable-decals}

    hook global WinSetOption filetype=(c|cpp|rust) %{
        hook window -group semantic-tokens BufReload .* lsp-semantic-tokens
        hook window -group semantic-tokens NormalIdle .* lsp-semantic-tokens
        hook window -group semantic-tokens InsertIdle .* lsp-semantic-tokens
        hook -once -always window WinSetOption filetype=.* %{
            remove-hooks window semantic-tokens
        }
      decl -hidden -docstring "Timestamp of the last check" int last_modified
      hook window RawKey .* %{
          eval %sh{
              if [ "${kak_opt_last_modified}" != "${kak_timestamp}" ]; then
                  echo "unset-option buffer lsp_inlay_diagnostics"
                  echo "unset-option buffer lsp_inlay_hints"
              fi
          }
          set current last_modified %val{timestamp}
      }
    }

    declare-option -hidden str modeline_progress ""
    define-command -hidden -params 6 -override lsp-handle-progress %{
        set global modeline_progress %sh{
            if ! "$6"; then
                echo "$2${5:+" ($5%)"}${4:+": $4"}"
            fi
        }
    }

    set global modelinefmt "%%opt{modeline_progress} %opt{modelinefmt}"
}

