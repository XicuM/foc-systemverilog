# Import variables
source ./scripts/get_config.tcl

# Create a new project
create_project $project_name ${project_path} -part $part

# Close project
close_project