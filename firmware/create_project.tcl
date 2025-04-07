##################
# Initial checks #
##################

# Check for setup file and source it
set setup_file "setup.tcl"
if {![file exists $setup_file]} {
  error "Missing setup file: $setup_file"
  return 1
}
source $setup_file

# Check for ip repository
if {![file exists $ip_repo_dirs]} {
    error "Missing IP repository: $ip_repo_dirs"
    return 1
}
# Check Vivado version 
set ver [lindex [split $::env(XILINX_VIVADO) /] end]
if {![string equal $ver $version_required]} {
  puts "Vivado version mismatch. Expected $version_required, got $ver"
  return 1
}

##################
# Create project #
##################

# All the information from the setup file
puts "+++++ CASB Firmware Setup +++++"
puts "Project name: ${project_name}"
puts "Design name: ${design_name}"
puts "Vivado version: ${version_required}"
puts "IP repository: ${ip_repo_dirs}"

# Set origin directory to where the tcl script is 
set origin_dir [file dirname [info script]]

# Set the project directory
set proj_dir "$origin_dir/$project_name"

# Create the project
create_project $project_name $proj_dir -part xc7z020clg400-1

# Set project properties
set obj [get_projects $project_name]
set_property board_part "myir.com:mys-7z020:part0:2.1" $obj
set_property target_language "VHDL" $obj

###########
# Sources #
###########

# Create 'sources_1' fileset if not found
if {![string equal [get_filesets -quiet sources_1] ""]} {
  puts "sources_1 not found"
  #create_fileset -srcset sources_1
  #puts "created sources_1"
}

# Set ip repository paths
set_property ip_repo_paths $ip_repo_dirs [get_filesets sources_1]

# Rebuild ip reository before adding source files
update_ip_catalog -rebuild

# Set 'sources_1' fileset properties as top module 
set_property top "${design_name}_wrapper" [get_filesets sources_1]

###############
# Constraints #
###############

# Create 'constrs_1` if not found
if {![string equal [get_filesets -quiet constrs_1] ""]} {
  puts "constrs_1 not found"
  #create_fileset -srcset constrs_1 
  #puts "created constrs_1"
}

# Add everything in the constrs subdirectory to the constraints 
foreach cfile [glob -type f "$origin_dir/src/constrs/*.xdc"] {
  puts "Adding constraints file: $cfile"
  add_files -fileset constrs_1 [file normalize $cfile]
}

################
# Block design #
################

# Create block design 
source $origin_dir/src/bd/${design_name}.tcl

# Generate the wrapper for the block design
make_wrapper -files [get_files *${design_name}.bd] -top

# Add the wrapper to the project
add_files -norecurse ${project_name}/${project_name}.srcs/sources_1/bd/${design_name}/hdl/${design_name}_wrapper.vhd

# Update com 
update_compile_order -fileset sources_1

# Validate and save block design
close_bd_design [current_bd_design]
open_bd_design [get_files ${design_name}.bd]
regenerate_bd_layout
validate_bd_design -force
save_bd_design

puts "+++++ Successfully created project: ${project_name} +++++"
puts "Build and then run synthesis and implementation when ready"

