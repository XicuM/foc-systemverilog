# ----------------------------------------------------------------------
# Vivado project configuration

set project_name            "hello_world"
set project_path            "./vivado/project"
set part                    "xc7z010clg400-1"
set board_part              "digilentinc.com:cora-z7-10:part0:1.0"
set rtl_files               "./vivado/src"
set constraints_file        "./vivado/constraints/cora.xdc"
set top_module              "and_gate"

# ----------------------------------------------------------------------
# Vitis configuration

set workspace               "./vitis/workspace"
set app_name                "hello_world"
set hw_platform             "./vivado/project/${project_name}.xsa"
set sw_platform             "xilinx.com:standalone:1.0"
set domain                  "standalone"
set app_files               "./vitis/src"

# ----------------------------------------------------------------------
# AXI GPIO configuration

set top_module_ext_ports    [list "a" "b"]
set axi_gpios_ext_ports     [list "led"]
set axi_gpios_int_ports     [list "y"]
set axi_gpios_int_widths    [list 1]
set axi_gpios_ext_widths    [list 1]