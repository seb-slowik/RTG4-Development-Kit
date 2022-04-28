set config [string toupper [lindex $argv 0]]
set design_flow_stage [string toupper [lindex $argv 1]]
set die_variant [string toupper [lindex $argv 2]]

set hw_platform RTG4_Dev_Kit
set soft_cpu MIV_RV32IMA
set sd_reference BaseDesign

#ES device is not supported in these scripts

#Edge case 1: If the argv0 is empty, assume CFG1
if {"$config" == ""} then {
	set config "CFG1"
}

#Edge case 2: If user passes an argument to argv1, intended for argv2
if {"$design_flow_stage" == "ES"} then {
	set die_variant "ES"
	puts "\n------------------------------------------------------------------------------- \
		  \r\nInfo: The 2nd Argument was used to pass in the die type. \
		  \r\n------------------------------------------------------------------------------- \n"
}

#Edge case 2: If user tries to build the design for an 'ES' die target
if {"$die_variant" == "ES"} {
	puts "\n------------------------------------------------------------------------------- \
		  \r\nError: Engineering Sample (ES) die not supported in these scripts. \
		  \r\n------------------------------------------------------------------------------- \n"
} elseif {"$die_variant" == ""} {
	set die_variant "PS"
}

append target_board $hw_platform _ $die_variant
append project_folder_name MIV_ $config _BD
set project_dir "./$project_folder_name"
append project_name $target_board _ $soft_cpu _ $config _ $sd_reference

proc create_new_project_label { } {
	puts "\n------------------------------------------------------------------------------- \
		  \r\nCreating a new project for the 'RTG4_Dev_Kit' board. \
		  \r\n------------------------------------------------------------------------------- \n"
}

proc project_exists { } {
	puts "\n------------------------------------------------------------------------------- \
		  \r\nError: A project exists for the 'RTG4_Dev_Kit' with this configuration. \
		  \r\n------------------------------------------------------------------------------- \n"
}

proc no_first_argument_entered { } {
	puts "\n------------------------------------------------------------------------------- \
		  \r\nInfo: No 1st Argument has been entered. \
		  \r\nEnter the 1st Argument responsible for type of design configuration -'CFG1..CFGn' \
		  \r\nDefault 'CFG1' design has been selected. \
		  \r\n------------------------------------------------------------------------------- \n"
}

proc invalid_first_argument { } {
	puts "\n------------------------------------------------------------------------------- \
		  \r\nError: Wrong 1st Argument has been entered. No valid configuration detected. \
		  \r\nInfo: Make sure you enter a valid first argument -'CFG1..CFGn'. \
		  \r\n------------------------------------------------------------------------------- \n"
}

proc no_second_argument_entered { } {
	puts "\n------------------------------------------------------------------------------- \
		  \r\nInfo: No adequate 2nd Argument has been entered. \
		  \r\nInfo: nEnter the 2nd Argument after the 1st to be taken further in the Design Flow. \
		  \r\nInfo: A 3rd Argument also needs to be present if targeting an 'ES' die type. \
		  \r\n------------------------------------------------------------------------------- \n"
}

proc invalid_second_argument { } {
	puts "\n------------------------------------------------------------------------------- \
		  \r\nWarning: Wrong 2nd Argument has been entered. \
		  \r\nInfo: Make sure you enter a valid 2nd argument -'Synthesize...Export_Programming_File'.\
		  \r\n------------------------------------------------------------------------------- \n"
}

proc no_third_argument_entered { } {
	puts "\n------------------------------------------------------------------------------- \
		  \r\nInfo: No 3rd Argument has been entered. \
		  \r\nInfo: The default die type -'PS' will be used as target \
		  \r\nInfo: Enter the optional 3rd Argument after the 2nd to target build for 'ES' die \
		  \r\n------------------------------------------------------------------------------- \n"
}

proc invalid_third_argument { } {
	puts "\n------------------------------------------------------------------------------- \
          \r\nWarning: Wrong 3rd Argument has been entered. \
          \r\nInfo: Make sure you enter a valid 3rd argument -'PS' or 'ES'. \
		  \r\nInfo: Building for default, production silicon 'PS' die target \
		  \r\n------------------------------------------------------------------------------- \n"
}

proc  base_design_built { } {
	puts "\n------------------------------------------------------------------------------- \
		  \r\nInfo: BaseDesign built. \
		  \r\n------------------------------------------------------------------------------- \n"
}

proc  legacy_core_msg { } {
	puts "\n------------------------------------------------------------------------------- \
		  \r\nWarning: This Libero design uses a legacy Mi-V soft processor core. \
		  \r\nWarning: Legacy Mi-V soft processors are not recommended for new designs. \
		  \r\nInfo: MIV_RV32 is recommended for new designs. \
		  \r\n------------------------------------------------------------------------------- \n"
}

proc download_required_direct_cores  { }\
{
	download_core -vlnv {Actel:DirectCore:CoreAPB3:4.2.100} -location {www.microchip-ip.com/repositories/DirectCore}
	download_core -vlnv {Actel:DirectCore:COREAHBTOAPB3:3.2.101} -location {www.microchip-ip.com/repositories/DirectCore}
	download_core -vlnv {Actel:DirectCore:CoreAHBLite:5.5.101} -location {www.microchip-ip.com/repositories/DirectCore}
	download_core -vlnv {Actel:DirectCore:CoreUARTapb:5.7.100} -location {www.microchip-ip.com/repositories/DirectCore}
	download_core -vlnv {Actel:DirectCore:CoreTimer:2.0.103} -location {www.microchip-ip.com/repositories/DirectCore}
	download_core -vlnv {Actel:DirectCore:COREJTAGDEBUG:4.0.100} -location {www.microchip-ip.com/repositories/DirectCore}
	download_core -vlnv {Actel:DirectCore:CoreGPIO:3.2.102} -location {www.microchip-ip.com/repositories/DirectCore}
	download_core -vlnv {Actel:DirectCore:COREAXITOAHBL:3.6.101} -location {www.microchip-ip.com/repositories/DirectCore}
	download_core -vlnv {Microsemi:MiV:MIV_RV32:3.0.100} -location {www.microchip-ip.com/repositories/DirectCore}
	download_core -vlnv {Microsemi:MiV:MIV_RV32IMA_L1_AHB:2.3.100} -location {www.microchip-ip.com/repositories/DirectCore} 
	download_core -vlnv {Microsemi:MiV:MIV_RV32IMA_L1_AXI:2.1.100} -location {www.microchip-ip.com/repositories/DirectCore} 
	download_core -vlnv {Microsemi:MiV:MIV_RV32IMAF_L1_AHB:2.1.100} -location {www.microchip-ip.com/repositories/DirectCore} 
}

proc pre_configure_place_and_route { }\
{
	#Configuring Place_and_Route tool for a timing pass.
	configure_tool -name {PLACEROUTE} -params {EFFORT_LEVEL:false} -params {REPAIR_MIN_DELAY:true} -params {TDPR:true} -params {IOREG_COMBINING:false}
}

proc run_verify_timing { }\
{
	#Runs Verify Timing tool
	run_tool -name {VERIFYTIMING}	
}

if {"$config" == "CFG1"} then {
	if {[file exists $project_dir] == 1} then {
		project_exists
	} else {
		create_new_project_label
		if {"$die_variant" == "ES"} then {
			invalid_third_argument
		} elseif {"$die_variant" != "PS"} then {
			invalid_third_argument
		} else {
			new_project -location  $project_dir -name $project_name -project_description {} -block_mode 0 -standalone_peripheral_initialization 0 -instantiate_in_smartdesign 1 -ondemand_build_dh 1 -hdl {VERILOG} -family {RTG4} -die {RT4G150} -package {1657 CG} -speed {STD} -die_voltage {1.2} -part_range {MIL} -adv_options {IO_DEFT_STD:LVCMOS 2.5V} -adv_options {RESTRICTPROBEPINS:1} -adv_options {RESTRICTSPIPINS:0} -adv_options {TEMPR:MIL} -adv_options {VCCI_1.2_VOLTR:MIL} -adv_options {VCCI_1.5_VOLTR:MIL} -adv_options {VCCI_1.8_VOLTR:MIL} -adv_options {VCCI_2.5_VOLTR:MIL} -adv_options {VCCI_3.3_VOLTR:MIL} -adv_options {VOLTR:MIL}
		}
		download_required_direct_cores
		source ./import/components/IMA_CFG1/import_sd_and_constraints_rtg4_ima_cfg1.tcl
		save_project
        base_design_built
	}
} elseif {"$config" == "CFG2"} then {
	if {[file exists $project_dir] == 1} then {
		project_exists
	} else {
		create_new_project_label
		if {"$die_variant" == "ES"} then {
			invalid_third_argument
		} elseif {"$die_variant" != "PS"} then {
			invalid_third_argument
		} else {
			new_project -location  $project_dir -name $project_name -project_description {} -block_mode 0 -standalone_peripheral_initialization 0 -instantiate_in_smartdesign 1 -ondemand_build_dh 1 -hdl {VERILOG} -family {RTG4} -die {RT4G150} -package {1657 CG} -speed {STD} -die_voltage {1.2} -part_range {MIL} -adv_options {IO_DEFT_STD:LVCMOS 2.5V} -adv_options {RESTRICTPROBEPINS:1} -adv_options {RESTRICTSPIPINS:0} -adv_options {TEMPR:MIL} -adv_options {VCCI_1.2_VOLTR:MIL} -adv_options {VCCI_1.5_VOLTR:MIL} -adv_options {VCCI_1.8_VOLTR:MIL} -adv_options {VCCI_2.5_VOLTR:MIL} -adv_options {VCCI_3.3_VOLTR:MIL} -adv_options {VOLTR:MIL}
		}
		download_required_direct_cores
		source ./import/components/IMA_CFG2/import_sd_and_constraints_rtg4_ima_cfg2.tcl
		save_project
        base_design_built
	}
} elseif {"$config" != ""} then {
		invalid_first_argument
} else {
	if {[file exists $project_dir] == 1} then {
		project_exists
	} else {
		no_first_argument_entered
		create_new_project_label
		if {"$die_variant" == "ES"} then {
			invalid_third_argument
		} elseif {"$die_variant" != "PS"} then {
			invalid_third_argument
		} else {
			new_project -location  $project_dir -name $project_name -project_description {} -block_mode 0 -standalone_peripheral_initialization 0 -instantiate_in_smartdesign 1 -ondemand_build_dh 1 -hdl {VERILOG} -family {RTG4} -die {RT4G150} -package {1657 CG} -speed {STD} -die_voltage {1.2} -part_range {MIL} -adv_options {IO_DEFT_STD:LVCMOS 2.5V} -adv_options {RESTRICTPROBEPINS:1} -adv_options {RESTRICTSPIPINS:0} -adv_options {TEMPR:MIL} -adv_options {VCCI_1.2_VOLTR:MIL} -adv_options {VCCI_1.5_VOLTR:MIL} -adv_options {VCCI_1.8_VOLTR:MIL} -adv_options {VCCI_2.5_VOLTR:MIL} -adv_options {VCCI_3.3_VOLTR:MIL} -adv_options {VOLTR:MIL}
		}
		download_required_direct_cores
		source ./import/components/IMA_CFG1/import_sd_and_constraints_rtg4_ima_cfg1.tcl
		save_project
        base_design_built
	}
}
 
pre_configure_place_and_route

#if {"$config" == "CFG2"} then {
	#configure_tool -name {SYNTHESIZE} -params {SYNPLIFY_OPTIONS:set_option -looplimit 4000} 
#}

if {"$design_flow_stage" == "SYNTHESIZE"} then {
	puts "\n------------------------------------------------------------------------------- \
		  \r\nBegin Synthesis... \
		  \r\n------------------------------------------------------------------------------- \n"

    run_tool -name {SYNTHESIZE}
    save_project

	puts "\n------------------------------------------------------------------------------- \
		  \r\nSynthesis Complete. \
		  \r\n------------------------------------------------------------------------------- \n"


} elseif {"$design_flow_stage" == "PLACE_AND_ROUTE"} then {

	puts "\n------------------------------------------------------------------------------- \
		  \r\nBegin Place and Route... \
		  \r\n------------------------------------------------------------------------------- \n"

	run_verify_timing
	save_project

	puts "\n------------------------------------------------------------------------------- \
		  \r\nPlace and Route Complete. \
		  \r\n------------------------------------------------------------------------------- \n"


} elseif {"$design_flow_stage" == "GENERATE_BITSTREAM"} then {

	puts "\n------------------------------------------------------------------------------- \
		  \r\nGenerating Bitstream... \
		  \r\n------------------------------------------------------------------------------- \n"

	run_verify_timing
    run_tool -name {GENERATEPROGRAMMINGDATA}
    run_tool -name {GENERATEPROGRAMMINGFILE}
    save_project

	puts "\n------------------------------------------------------------------------------- \
		  \r\nBitstream Generated. \
		  \r\n------------------------------------------------------------------------------- \n"


} elseif {"$design_flow_stage" == "EXPORT_PROGRAMMING_FILE"} then {

	puts "\n------------------------------------------------------------------------------- \
		  \r\nExporting Programming Files... \
		  \r\n------------------------------------------------------------------------------- \n"

	run_verify_timing
	run_tool -name {GENERATEPROGRAMMINGFILE}

	export_prog_job \
		-job_file_name $project_name \
		-export_dir $project_dir/designer/BaseDesign/export \
		-force_rtg4_otp 0 \
		-design_bitstream_format {PPD} 
	save_project
	
	puts "\n------------------------------------------------------------------------------- \
		  \r\nProgramming Files Exported. \
		  \r\n------------------------------------------------------------------------------- \n"

} elseif {"$design_flow_stage" != ""} then {
	if {"$design_flow_stage" != "PS"} then {
		invalid_second_argument
	}
} else {
	no_second_argument_entered
}