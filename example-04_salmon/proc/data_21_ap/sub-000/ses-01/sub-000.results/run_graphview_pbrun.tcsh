#!/bin/tcsh

# This script was created by the afni_proc.py quality control (APQC)
# generator.  
#
# Its purpose is to facilitate investigating the properties of time 
# series data, using the AFNI GUI's {proc_type} functionality.
#
# In this script, one *must* provide 2 command line args: 
# + a pb label (pb00, pb01, etc.), 
# + a run number (r01, r02, r03, etc.).
#
# Additionally, one *can* add three numbers on the command line
# to represent the starting location (RAI coordinate notation) of the 
# initial seed.
#
# ver = 2.0
# -------------------------------------------------------------------------


# ----- Get inputs and create label

set pb  = "$1"
set run = "$2"

if ( "${run}" == "" ) then
    echo "** Exiting: this program requires 2 cmd line args to run:"
    echo "   + a pb label (pb00, pb01, etc.)"
    echo "   + a run number (r01, r02, r03, etc.)."
    echo "   Additionally, you can then put 3 numbers as an initial"
    echo "   seed location coordinate"
    exit 1
endif

set label = "${pb} ${run}"

# possible starting seed coordinate (in RAI notation)
set xcoor = "$3"
set ycoor = "$4"
set zcoor = "$5"

# ----- find main dset(s)

set all_dset = `find . -maxdepth 1 -name "${pb}.*.${run}.*.HEAD" \
                      | cut -b3- | sort`

if ( ${#all_dset} == 0 ) then
    echo "** Exiting: could not find dset: ${pb}.*.${run}.*.HEAD"
    exit 1
else if ( ${#all_dset} == 1 ) then
    echo "++ Found ulay dset: ${all_dset}"
else
    echo "++ Note: found multiple (${#all_dset}) dsets: ${pb}.*.${run}.*.HEAD"
    echo "   Assuming this is ME-FMRI"
endif


# Set index to be 'middle' dset (is just first if N=1)
set idx = `echo "scale=0; (${#all_dset}+1)/2" | bc`
set dset_ulay = "${all_dset[$idx]}"

# ----- find associated vline file, if exists
set dset_vline = ""
set dir_vline  = `find . -maxdepth 1 -type d        \
                      -name "vlines.${pb}.*"        \
                      | cut -b3- | sort`
if ( ${#dir_vline} == 1 ) then
    set dset_vline  = `find ./${dir_vline} -maxdepth 1 -type f        \
                           -name "var.1.*${run}*"                     \
                           | cut -b3- | sort`
endif

# ----- find associated radcor file, if exists
set dset_radcor = ""
set dir_radcor  = `find . -maxdepth 1 -type d       \
                     -name "radcor.${pb}.*"         \
                     | cut -b3- | sort`
if ( ${#dir_radcor} == 1 ) then
    set dset_radcor  = `find ./${dir_radcor} -maxdepth 1 -type f     \
                            -name "radcor.*.${run}*HEAD"             \
                            | cut -b3- | sort`
endif

# ----- make ordered list of dsets to load
set all_load  = ( "${all_dset}"                     \
                   ${pb}.*HEAD                      \
                   ${dset_vline} ${dset_radcor}     \
                   *.HEAD *.nii* )

# ----- finalize remaining parameters

if ( "${zcoor}" != "" ) then
    set coord = ( "${xcoor}" "${ycoor}" "${zcoor}" )
else
    set coord = `3dinfo -dc3 "${dset_ulay}"`
endif

# ===========================================================================

# General GUI parameters set by default
setenv AFNI_ENVIRON_WARNINGS    NO
setenv AFNI_THRESH_INIT_EXPON   0
setenv AFNI_NOSPLASH            YES
setenv AFNI_SPLASH_MELT         NO
setenv AFNI_STARTUP_WARNINGS    NO
setenv AFNI_NIFTI_TYPE_WARN     NO
setenv AFNI_NO_OBLIQUE_WARNING  YES
setenv AFNI_COMPRESSOR          NONE
setenv AFNI_NEVER_SAY_GOODBYE   YES
setenv AFNI_MOTD_CHECK          NO
setenv AFNI_VERSION_CHECK       NO
setenv AFNI_IMAGE_DATASETS      NO
setenv AFNI_NO_ADOPTION_WARNING YES
setenv AFNI_FLASH_VIEWSWITCH    NO
setenv AFNI_SKIP_TCSV_SCAN      YES

# graph specific parameters (faster to do here than with driving)
setenv AFNI_graph_width     800  # initial width of graph window
setenv AFNI_graph_height    500  # initial height of graph window
setenv AFNI_graph_matrix    5    # initial number of sub-graphs

# ----- GraphView setup and cmd

# GUI visualization parameters
set crossh      = MULTI
set xh_gap      = -1
set OW          = "OPEN_WINDOW"
set graxis      = "axial"

# port communication
set portnum = `afni -available_npb_quiet`

#============================================================================

afni -q  -no1D -no_detach                                               \
    -npb ${portnum}                                                     \
    -com "SWITCH_UNDERLAY    ${dset_ulay}"                              \
    -com "SET_DICOM_XYZ      ${coord}"                                  \
    -com "SET_XHAIRS         ${crossh}"                                 \
    -com "SET_XHAIR_GAP      ${xh_gap}"                                 \
    -com "$OW sagittalimage"                                            \
    -com "$OW ${graxis}graph"                                           \
    ${all_load:q}  &

sleep 1

set l = `prompt_popup -message \
"   View graphs+images of AP results data:  ${label}\n\n\
\n\
Initial ulay dataset : ${dset_ulay[1]}\n\
Initial graph shown  : ${graxis}\n\
\n\
Some useful graph keyboard shortcuts:\n\
+ g/G = decrease/increase vertical grid spacing\n\
+ m/M = reduce/increase matrix size of sub-graphs by 1  \n\
+ v/V = 'video' scroll forward/backward in time\n\
+ spacebar = pause scrolling\n\
+ a/A = autoscale graphs once/always\n\
+ z/Z = change slice number down/up by 1\n\
+ -/+ = scale graphs down/up vertically\n\
+ S   = save view of graph to image file\n\
+ w   = write highlighted time series as *.1D text file  \n\
\n" \
-b '          Done - Close AFNI GUI          '`


if ("$l" != "1") then
    echo "+* Warn: AFNI Graph Viewer guidance message failed to open"
endif

@Quiet_Talkers -npb_val ${portnum}

cat << EOF
===========================================
++ Goodbye, and thank you for graph viewing.

EOF
exit 0
