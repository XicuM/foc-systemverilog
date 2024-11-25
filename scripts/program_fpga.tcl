# Import variables
source ./scripts/get_config.tcl

# Open hardware manager and connect to the hardware server
open_hw_manager
connect_hw_server
open_hw_target

# Get the available devices and filter for the FPGA device (Zynq-7000)
set devices [get_hw_devices]
set fpga_device ""
foreach device $devices {
    set part_name [get_property PART $device]
    puts "Checking device: $device with part: $part_name"
    if {[string match "xc7z010*" $part_name] || [string match "xc7z020*" $part_name]} {
        set fpga_device $device
        break
    }
}
if {$fpga_device eq ""} {
    puts "ERROR: No programmable FPGA device found."
    exit 1
}

# Program the FPGA with the bitstream
set_property PROGRAM.FILE ${project_path}/${project_name}.bit [current_hw_device]
program_hw_devices [current_hw_device]

# Close the hardware manager
close_hw_manager