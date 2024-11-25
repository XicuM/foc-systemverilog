package require yaml
set config [yaml::load [open "config.yaml"]]
set project_name [dict get $config project_name]
set project_path [dict get $config project_path]
set top_module [dict get $config top_module]
set constraints_file [dict get $config constraints_file]
set part [dict get $config part]