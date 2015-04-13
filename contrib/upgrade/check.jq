.machines | with_entries(
  select(.value.extra_data.box.name == "ailispaw/rancheros-lite")
  |
  select(.value.extra_data.box.version != $version)
)
