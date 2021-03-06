# 
# Report generation script generated by Vivado
# 

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
proc start_step { step } {
  set stopFile ".stop.rst"
  if {[file isfile .stop.rst]} {
    puts ""
    puts "*** Halting run - EA reset detected ***"
    puts ""
    puts ""
    return -code error
  }
  set beginFile ".$step.begin.rst"
  set platform "$::tcl_platform(platform)"
  set user "$::tcl_platform(user)"
  set pid [pid]
  set host ""
  if { [string equal $platform unix] } {
    if { [info exist ::env(HOSTNAME)] } {
      set host $::env(HOSTNAME)
    }
  } else {
    if { [info exist ::env(COMPUTERNAME)] } {
      set host $::env(COMPUTERNAME)
    }
  }
  set ch [open $beginFile w]
  puts $ch "<?xml version=\"1.0\"?>"
  puts $ch "<ProcessHandle Version=\"1\" Minor=\"0\">"
  puts $ch "    <Process Command=\".planAhead.\" Owner=\"$user\" Host=\"$host\" Pid=\"$pid\">"
  puts $ch "    </Process>"
  puts $ch "</ProcessHandle>"
  close $ch
}

proc end_step { step } {
  set endFile ".$step.end.rst"
  set ch [open $endFile w]
  close $ch
}

proc step_failed { step } {
  set endFile ".$step.error.rst"
  set ch [open $endFile w]
  close $ch
}

set_msg_config -id {Synth 8-256} -limit 10000
set_msg_config -id {Synth 8-638} -limit 10000

start_step init_design
set ACTIVE_STEP init_design
set rc [catch {
  create_msg_db init_design.pb
  create_project -in_memory -part xc7a100tcsg324-1
  set_property design_mode GateLvl [current_fileset]
  set_param project.singleFileAddWarning.threshold 0
  set_property webtalk.parent_dir D:/Projects/Code/ece540w20_proj3_r1_1/project_3/project_3.cache/wt [current_project]
  set_property parent.project_path D:/Projects/Code/ece540w20_proj3_r1_1/project_3/project_3.xpr [current_project]
  set_property ip_output_repo D:/Projects/Code/ece540w20_proj3_r1_1/project_3/project_3.cache/ip [current_project]
  set_property ip_cache_permissions {read write} [current_project]
  set_property XPM_LIBRARIES XPM_CDC [current_project]
  add_files -quiet D:/Projects/Code/ece540w20_proj3_r1_1/project_3/project_3.runs/synth_157_v1/nexys4fpga_v1.dcp
  read_ip -quiet D:/Projects/Code/ece540w20_proj3_r1_1/project_3/project_3.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xci
  read_xdc D:/Projects/Code/ece540w20_proj3_r1_1/project_3/project_3.srcs/constrs_1/imports/constraints/n4DDRfpga.xdc
  link_design -top nexys4fpga_v1 -part xc7a100tcsg324-1
  close_msg_db -file init_design.pb
} RESULT]
if {$rc} {
  step_failed init_design
  return -code error $RESULT
} else {
  end_step init_design
  unset ACTIVE_STEP 
}

start_step opt_design
set ACTIVE_STEP opt_design
set rc [catch {
  create_msg_db opt_design.pb
  opt_design -directive ExploreSequentialArea
  write_checkpoint -force nexys4fpga_v1_opt.dcp
  create_report "impl_157_v1_opt_report_drc_0" "report_drc -file nexys4fpga_v1_drc_opted.rpt -pb nexys4fpga_v1_drc_opted.pb -rpx nexys4fpga_v1_drc_opted.rpx"
  close_msg_db -file opt_design.pb
} RESULT]
if {$rc} {
  step_failed opt_design
  return -code error $RESULT
} else {
  end_step opt_design
  unset ACTIVE_STEP 
}

start_step place_design
set ACTIVE_STEP place_design
set rc [catch {
  create_msg_db place_design.pb
  if { [llength [get_debug_cores -quiet] ] > 0 }  { 
    implement_debug_core 
  } 
  place_design -directive EarlyBlockPlacement
  write_checkpoint -force nexys4fpga_v1_placed.dcp
  create_report "impl_157_v1_place_report_io_0" "report_io -file nexys4fpga_v1_io_placed.rpt"
  create_report "impl_157_v1_place_report_utilization_0" "report_utilization -file nexys4fpga_v1_utilization_placed.rpt -pb nexys4fpga_v1_utilization_placed.pb"
  create_report "impl_157_v1_place_report_control_sets_0" "report_control_sets -verbose -file nexys4fpga_v1_control_sets_placed.rpt"
  close_msg_db -file place_design.pb
} RESULT]
if {$rc} {
  step_failed place_design
  return -code error $RESULT
} else {
  end_step place_design
  unset ACTIVE_STEP 
}

start_step phys_opt_design
set ACTIVE_STEP phys_opt_design
set rc [catch {
  create_msg_db phys_opt_design.pb
  phys_opt_design -directive AlternateFlowWithRetiming
  write_checkpoint -force nexys4fpga_v1_physopt.dcp
  close_msg_db -file phys_opt_design.pb
} RESULT]
if {$rc} {
  step_failed phys_opt_design
  return -code error $RESULT
} else {
  end_step phys_opt_design
  unset ACTIVE_STEP 
}

  set_msg_config -source 4 -id {Route 35-39} -severity "critical warning" -new_severity warning
start_step route_design
set ACTIVE_STEP route_design
set rc [catch {
  create_msg_db route_design.pb
  route_design -directive AlternateCLBRouting
  write_checkpoint -force nexys4fpga_v1_routed.dcp
  create_report "impl_157_v1_route_report_drc_0" "report_drc -file nexys4fpga_v1_drc_routed.rpt -pb nexys4fpga_v1_drc_routed.pb -rpx nexys4fpga_v1_drc_routed.rpx"
  create_report "impl_157_v1_route_report_methodology_0" "report_methodology -file nexys4fpga_v1_methodology_drc_routed.rpt -pb nexys4fpga_v1_methodology_drc_routed.pb -rpx nexys4fpga_v1_methodology_drc_routed.rpx"
  create_report "impl_157_v1_route_report_power_0" "report_power -file nexys4fpga_v1_power_routed.rpt -pb nexys4fpga_v1_power_summary_routed.pb -rpx nexys4fpga_v1_power_routed.rpx"
  create_report "impl_157_v1_route_report_route_status_0" "report_route_status -file nexys4fpga_v1_route_status.rpt -pb nexys4fpga_v1_route_status.pb"
  create_report "impl_157_v1_route_report_timing_summary_0" "report_timing_summary -max_paths 10 -file nexys4fpga_v1_timing_summary_routed.rpt -pb nexys4fpga_v1_timing_summary_routed.pb -rpx nexys4fpga_v1_timing_summary_routed.rpx"
  create_report "impl_157_v1_route_report_incremental_reuse_0" "report_incremental_reuse -file nexys4fpga_v1_incremental_reuse_routed.rpt"
  create_report "impl_157_v1_route_report_clock_utilization_0" "report_clock_utilization -file nexys4fpga_v1_clock_utilization_routed.rpt"
  create_report "impl_157_v1_route_report_bus_skew_0" "report_bus_skew -warn_on_violation -file nexys4fpga_v1_bus_skew_routed.rpt -pb nexys4fpga_v1_bus_skew_routed.pb -rpx nexys4fpga_v1_bus_skew_routed.rpx"
  close_msg_db -file route_design.pb
} RESULT]
if {$rc} {
  write_checkpoint -force nexys4fpga_v1_routed_error.dcp
  step_failed route_design
  return -code error $RESULT
} else {
  end_step route_design
  unset ACTIVE_STEP 
}

start_step post_route_phys_opt_design
set ACTIVE_STEP post_route_phys_opt_design
set rc [catch {
  create_msg_db post_route_phys_opt_design.pb
  phys_opt_design -directive ExploreWithAggressiveHoldFix
  write_checkpoint -force nexys4fpga_v1_postroute_physopt.dcp
  create_report "impl_157_v1_post_route_phys_opt_report_timing_summary_0" "report_timing_summary -max_paths 10 -warn_on_violation -file nexys4fpga_v1_timing_summary_postroute_physopted.rpt -pb nexys4fpga_v1_timing_summary_postroute_physopted.pb -rpx nexys4fpga_v1_timing_summary_postroute_physopted.rpx"
  create_report "impl_157_v1_post_route_phys_opt_report_bus_skew_0" "report_bus_skew -warn_on_violation -file nexys4fpga_v1_bus_skew_postroute_physopted.rpt -pb nexys4fpga_v1_bus_skew_postroute_physopted.pb -rpx nexys4fpga_v1_bus_skew_postroute_physopted.rpx"
  close_msg_db -file post_route_phys_opt_design.pb
} RESULT]
if {$rc} {
  step_failed post_route_phys_opt_design
  return -code error $RESULT
} else {
  end_step post_route_phys_opt_design
  unset ACTIVE_STEP 
}

