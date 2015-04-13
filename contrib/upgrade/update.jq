{
  version:  .version,
  machines: .machines | to_entries | sort |
    map(
      if .value.extra_data.box.name == "ailispaw/rancheros-lite" then
        .value.extra_data.box.version = $version | .
      else . end
    )
    | from_entries
}
