#Hardware     : RTG4 Dev Kit (rev B (RTG4150-1657CG))
#MIV Cores    : MIV_RV32
#
#Libero's TCL top level script
#
#This Tcl file sources other Tcl files to build the design(on which recursive export is run) in a bottom-up fashion

#Importing and Linking all the HDL source files used in the design
import_files -hdl_source ./import/hdl/reset_synchronizer.v
build_design_hierarchy

#Sourcing the Tcl files for creating individual components under the top level
source ./import/components/SHARED_COMPONENTS/RTG4FCCC_0.tcl 
source ./import/components/SHARED_COMPONENTS/RTG4_SRAM_AXI4_0.tcl 
source ./import/components/SHARED_COMPONENTS/CoreJTAGDebug_0.tcl 
source ./import/components/SHARED_COMPONENTS/CoreTimer_0.tcl 
source ./import/components/SHARED_COMPONENTS/CoreTimer_1.tcl 
source ./import/components/SHARED_COMPONENTS/MIV_RV32_CFG2_0.tcl 
source ./import/components/SHARED_COMPONENTS/MIV_ESS_0.tcl 

# Creating SmartDesign BaseDesign
set sd_name {BaseDesign}
create_smartdesign -sd_name ${sd_name}

# Disable auto promotion of pins of type 'pad'
auto_promote_pad_pins -promote_all 0

# Create top level Ports
sd_create_scalar_port -sd_name ${sd_name} -port_name {TDO} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {TRSTB} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {TCK} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {TDI} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {TMS} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {RX} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {TX} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {DEVRST_N} -port_direction {IN}

sd_create_scalar_port -sd_name ${sd_name} -port_name {PUSH_BTN_1} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {PUSH_BTN_2} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {LED_1} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {LED_2} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {LED_3} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {LED_4} -port_direction {OUT}



# Add CoreJTAGDebug_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {CoreJTAGDebug_0} -instance_name {CoreJTAGDebug_0}


# Add CoreTimer_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {CoreTimer_0} -instance_name {CoreTimer_0}


# Add CoreTimer_1 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {CoreTimer_1} -instance_name {CoreTimer_1}



# Add MIV_RV32_CFG2_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {MIV_RV32_CFG2_0} -instance_name {MIV_RV32_CFG2_0}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {MIV_RV32_CFG2_0:TIME_COUNT_OUT}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {MIV_RV32_CFG2_0:JTAG_TDO_DR}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {MIV_RV32_CFG2_0:EXT_RESETN}


# Add MIV_ESS_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {MIV_ESS_0} -instance_name {MIV_ESS_0}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {MIV_ESS_0:GPIO_IN} -pin_slices {[0]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {MIV_ESS_0:GPIO_IN} -pin_slices {[1]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {MIV_ESS_0:GPIO_IN} -pin_slices {[3:2]}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {MIV_ESS_0:GPIO_IN[3:2]} -value {GND}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {MIV_ESS_0:GPIO_OUT} -pin_slices {[0]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {MIV_ESS_0:GPIO_OUT} -pin_slices {[1]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {MIV_ESS_0:GPIO_OUT} -pin_slices {[2]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {MIV_ESS_0:GPIO_OUT} -pin_slices {[3]}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {MIV_ESS_0:GPIO_INT}


# Add AND2_0 instance
sd_instantiate_macro -sd_name ${sd_name} -macro_name {AND2} -instance_name {AND2_0}


# Add RCOSC_50MHZ_0 instance
sd_instantiate_macro -sd_name ${sd_name} -macro_name {RCOSC_50MHZ} -instance_name {RCOSC_50MHZ_0}


# Add reset_synchronizer_0 instance
sd_instantiate_hdl_module -sd_name ${sd_name} -hdl_module_name {reset_synchronizer} -hdl_file {hdl\reset_synchronizer.v} -instance_name {reset_synchronizer_0}


# Add RTG4_SRAM_AXI4_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {RTG4_SRAM_AXI4_0} -instance_name {RTG4_SRAM_AXI4_0}


# Add RTG4FCCC_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {RTG4FCCC_0} -instance_name {RTG4FCCC_0}


# Add SYSRESET_0 instance
sd_instantiate_macro -sd_name ${sd_name} -macro_name {SYSRESET} -instance_name {SYSRESET_0}


# Add scalar net connections
sd_connect_pins -sd_name ${sd_name} -pin_names {"SYSRESET_0:DEVRST_N" "DEVRST_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"RCOSC_50MHZ_0:CLKOUT" "RTG4FCCC_0:RCOSC_50MHZ" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"AND2_0:Y" "reset_synchronizer_0:reset" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"AND2_0:B" "RTG4FCCC_0:LOCK" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"AND2_0:A" "SYSRESET_0:POWER_ON_RESET_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreJTAGDebug_0:TGT_TCK_0" "MIV_RV32_CFG2_0:JTAG_TCK" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreJTAGDebug_0:TGT_TDI_0" "MIV_RV32_CFG2_0:JTAG_TDI" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreJTAGDebug_0:TGT_TMS_0" "MIV_RV32_CFG2_0:JTAG_TMS" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreJTAGDebug_0:TGT_TRSTN_0" "MIV_RV32_CFG2_0:JTAG_TRSTN" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreJTAGDebug_0:TGT_TDO_0" "MIV_RV32_CFG2_0:JTAG_TDO" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"MIV_ESS_0:PRESETN" "reset_synchronizer_0:reset_sync" "CoreTimer_0:PRESETn" "CoreTimer_1:PRESETn" "RTG4_SRAM_AXI4_0:ARESETN" "MIV_RV32_CFG2_0:RESETN" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreTimer_0:TIMINT" "MIV_RV32_CFG2_0:MSYS_EI" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreTimer_1:TIMINT" "MIV_RV32_CFG2_0:EXT_IRQ" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"MIV_ESS_0:PCLK" "reset_synchronizer_0:clock" "RTG4FCCC_0:GL0" "CoreTimer_0:PCLK" "CoreTimer_1:PCLK" "RTG4_SRAM_AXI4_0:ACLK" "MIV_RV32_CFG2_0:CLK" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreJTAGDebug_0:TCK" "TCK" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreJTAGDebug_0:TDI" "TDI" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreJTAGDebug_0:TDO" "TDO" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreJTAGDebug_0:TMS" "TMS" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreJTAGDebug_0:TRSTB" "TRSTB" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"MIV_ESS_0:UART_RX" "RX" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"MIV_ESS_0:UART_TX" "TX" }

# Add bus net connections
sd_connect_pins -sd_name ${sd_name} -pin_names {"MIV_ESS_0:GPIO_IN[0]" "PUSH_BTN_1" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"MIV_ESS_0:GPIO_IN[1]" "PUSH_BTN_2" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"MIV_ESS_0:GPIO_OUT[0]" "LED_1" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"MIV_ESS_0:GPIO_OUT[1]" "LED_2" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"MIV_ESS_0:GPIO_OUT[2]" "LED_3" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"MIV_ESS_0:GPIO_OUT[3]" "LED_4" }


# Add bus interface net connections
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreTimer_0:APBslave" "MIV_ESS_0:APB_3_mTARGET" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreTimer_1:APBslave" "MIV_ESS_0:APB_4_mTARGET" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"MIV_ESS_0:APB_0_mINITIATOR" "MIV_RV32_CFG2_0:APB_MSTR" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"RTG4_SRAM_AXI4_0:AXI4_Slave" "MIV_RV32_CFG2_0:AXI4_M_SLV" }

# Re-enable auto promotion of pins of type 'pad'
auto_promote_pad_pins -promote_all 1
# Re-arrange SmartDesign layout
sd_reset_layout -sd_name ${sd_name}
# Save the SmartDesign
save_smartdesign -sd_name ${sd_name}
# Generate the SmartDesign
generate_component -component_name ${sd_name}

