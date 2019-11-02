define-command enable-indices -docstring 'enable persistent selections indices in gutter' %{
  hook -group indices window NormalIdle .* show-indices
}

define-command show-indices -docstring 'show selections indices in gutter' %{
  set-face window Indices default

  declare-option line-specs indices_flags
  # from previous call
  remove-highlighter window/indices
  add-highlighter window/indices flag-lines Indices indices_flags

  evaluate-commands %sh{
    index=0
    printf "set-option window indices_flags $kak_timestamp"
    printf '%s\n' "$kak_selections_desc" | tr ' ' '\n' |
    while read desc; do
      first_line="$(cut -d '.' -f 1 <<< "$desc")"
      index=$(($index + 1))
      printf " %s|%s" $first_line $index
    done
  }
}

define-command hide-indices -docstring 'hide selections indices in gutter' %{
  remove-hooks window indices
  remove-highlighter window/indices
}

# Suggested hook

# hook global WinDisplay .* enable-indices
