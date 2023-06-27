# Build the design hierarchy and set the root of the project
build_design_hierarchy
set_root $sdName

# Import constraint files for all base and design guide configurations
import_files -sdc $scriptDir/import/constraints/io_jtag_constraints.sdc
import_files -io_pdc $scriptDir/import/constraints/io/io_constraints.pdc

# Organize PDC and SDC constraints to Synthesis, Place and Route and Verify Timing tools
# CFG1, CFG2, CFG3 MIV_RV32: Base Configs 
organize_tool_files -tool {PLACEROUTE} \
	-file $projectDir/constraint/io/io_constraints.pdc \
	-file $projectDir/constraint/io_jtag_constraints.sdc \
	-module ${sdName}::work -input_type {constraint}

organize_tool_files -tool {SYNTHESIZE} \
	-file $projectDir/constraint/io_jtag_constraints.sdc \
	-module ${sdName}::work -input_type {constraint}

organize_tool_files -tool {VERIFYTIMING} \
	-file $projectDir/constraint/io_jtag_constraints.sdc \
	-module ${sdName}::work -input_type {constraint}

run_tool -name {CONSTRAINT_MANAGEMENT}
derive_constraints_sdc