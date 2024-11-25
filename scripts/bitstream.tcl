# Import variables
source ./scripts/get_config.tcl

# Open project
open_project ${project_path}/${project_name}.xpr

# Add sources and constraints, and set the top module
add_files -fileset sources_1 -norecurse ./rtl
add_files -fileset constrs_1 ./constraints/${constraints_file}
set_property top $top_module [current_fileset]

# Run synthesis if necessary
set synth_status [get_property STATUS [get_runs synth_1]]
if {${synth_status} ne "synthesized"} {
    reset_run synth_1
    launch_runs synth_1 -jobs 12
    wait_on_run synth_1
} else {
    open_run synth_1
}

# Run implementation if necessary
set impl_status [get_property STATUS [get_runs impl_1]]
if {${impl_status} ne "implemented"} {
    reset_run impl_1
    launch_runs impl_1 -jobs 12
    wait_on_run impl_1
    open_run impl_1
}

# Generate bitstream
write_bitstream -force ./${project_path}/${project_name}.bit

# Save and close the project
save_project_as ./${project_path}/${project_name}.xpr
close_project