

# Set the target hardware platform
set hw_platform C:/path/to/hardware_platform.xsa

# Create a new application project with the specified hardware platform
create_app_project -name $project_name -platform $hw_platform -domain standalone

# Add source files
add_files -fileset sources_1 C:/path/to/your/source_files