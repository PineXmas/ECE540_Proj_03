# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
set_msg_config -id {Synth 8-256} -limit 10000
set_msg_config -id {Synth 8-638} -limit 10000
create_project -in_memory -part xc7a100tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir D:/Projects/Code/ece540w20_proj3_r1_1/project_3/project_3.cache/wt [current_project]
set_property parent.project_path D:/Projects/Code/ece540w20_proj3_r1_1/project_3/project_3.xpr [current_project]
set_property XPM_LIBRARIES XPM_CDC [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo d:/Projects/Code/ece540w20_proj3_r1_1/project_3/project_3.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_verilog -library xil_defaultlib -sv {
  D:/Projects/Code/ECE540_Proj_03/project_3/project_3.srcs/sources_1/imports/hdl/mean_v2.sv
  D:/Projects/Code/ece540w20_proj3_r1_1/project_3/project_3.srcs/sources_1/imports/hdl/sevenseg_outmux.sv
  D:/Projects/Code/ECE540_Proj_03/project_3/project_3.srcs/sources_1/imports/hdl/nexys4fpga_v1.sv
}
read_verilog -library xil_defaultlib {
  D:/Projects/Code/ece540w20_proj3_r1_1/project_3/project_3.srcs/sources_1/imports/hdl/binary_to_bcd.v
  D:/Projects/Code/ece540w20_proj3_r1_1/project_3/project_3.srcs/sources_1/imports/hdl/control_unit.v
  D:/Projects/Code/ece540w20_proj3_r1_1/project_3/project_3.srcs/sources_1/imports/hdl/debounce.v
  D:/Projects/Code/ece540w20_proj3_r1_1/project_3/project_3.srcs/sources_1/imports/hdl/sevensegment.v
}
read_ip -quiet D:/Projects/Code/ece540w20_proj3_r1_1/project_3/project_3.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xci
set_property used_in_implementation false [get_files -all d:/Projects/Code/ece540w20_proj3_r1_1/project_3/project_3.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_board.xdc]
set_property used_in_implementation false [get_files -all d:/Projects/Code/ece540w20_proj3_r1_1/project_3/project_3.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xdc]
set_property used_in_implementation false [get_files -all d:/Projects/Code/ece540w20_proj3_r1_1/project_3/project_3.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_ooc.xdc]

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc D:/Projects/Code/ece540w20_proj3_r1_1/project_3/project_3.srcs/constrs_1/imports/constraints/n4DDRfpga.xdc
set_property used_in_implementation false [get_files D:/Projects/Code/ece540w20_proj3_r1_1/project_3/project_3.srcs/constrs_1/imports/constraints/n4DDRfpga.xdc]

set_param ips.enableIPCacheLiteLoad 0
close [open __synthesis_is_running__ w]

synth_design -top nexys4fpga_v1 -part xc7a100tcsg324-1 -directive FewerCarryChains -retiming


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef nexys4fpga_v1.dcp
create_report "synth_157_v1_synth_report_utilization_0" "report_utilization -file nexys4fpga_v1_utilization_synth.rpt -pb nexys4fpga_v1_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
