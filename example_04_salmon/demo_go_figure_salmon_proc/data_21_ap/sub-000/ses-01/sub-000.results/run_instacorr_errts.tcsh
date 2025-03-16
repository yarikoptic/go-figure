#!/bin/tcsh

# This script was created by the afni_proc.py quality control (APQC)
# generator.  
#
# Its purpose is to facilitate investigating the properties of time 
# series data, using the AFNI GUI's {proc_type} functionality.
#
# Additionally, one *can* add three numbers on the command line
# to represent the starting location (RAI coordinate notation) of the 
# initial seed.
#
# Using InstaCorr:
# As described in the popup help, once the GUI is open and InstaCorr
# has been set up, users should just need to hold down the Ctrl+Shift
# keys and then left-click and move the mouse around (dragging or
# re-clicking).  Watch the correlation patterns to that seed location
# change, and this often provides an excellent way to understand the
# data.
#
# ver = 2.0
# -------------------------------------------------------------------------


# ----- Get inputs and create label

# possible starting seed coordinate (in RAI notation)
set xcoor = "$1"
set ycoor = "$2"
set zcoor = "$3"

set label = 'errts (residuals)'

# ----- find main dset(s)
set dset_ulay = "anat_final.sub-000+orig.HEAD"
set ic_dset   = "errts.sub-000+orig.HEAD"

# ----- make list of dsets to load

set all_load  = ( "${dset_ulay}" "${ic_dset}"                     \
                   corr_brain*HEAD                                \
                   all_runs.*.HEAD *.HEAD *.nii* )

# ----- finalize remaining parameters

if ( "${zcoor}" != "" ) then
    set coord = ( "${xcoor}" "${ycoor}" "${zcoor}" )
else
    set coord = `3dinfo -dc3 "${dset_ulay}"`
endif

set voxvol      = `3dinfo -voxvol "${ic_dset}"`
set ic_seedrad  = `echo "${voxvol}"                                      \
                        | awk '{printf "%0.2f",(2*($1)^0.3334);}'`
echo "++ seedcorr radius: ${ic_seedrad}"

set ic_blur = 0
echo "++ blurring radius: ${ic_blur}"

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

# GUI params, set here for speed, perhaps 
setenv AFNI_DEFAULT_OPACITY    7
setenv AFNI_THRESH_AUTO        NO
setenv AFNI_FUNC_BOXED         YES

# ----- InstaCorr setup and cmd

# IC parameters
set ic_ignore   = 0
set ic_automask = no
set ic_despike  = no
set ic_bandpass = 0,99999
set ic_polort   = -1                    # bc the data be residuals
set ic_method   = P

# GUI visualization parameters
set pbar_sign   = "-"
set ncolors     = 99
set topval      = 0.6
set cbar        = "Reds_and_Blues_Inv"
set olay_alpha  = "Quadratic"
set thresh      = 0.3
set frange      = ${topval}
set crossh      = MULTI
set xh_gap      = -1
set OW          = "OPEN_WINDOW"

# port communication
set portnum = `afni -available_npb_quiet`

#============================================================================

afni -q  -no1D -no_detach                                               \
    -npb ${portnum}                                                     \
    -com "SWITCH_UNDERLAY    ${dset_ulay}"                              \
    -com "INSTACORR INIT                                                \
                    DSET=${ic_dset}                                     \
                  IGNORE=${ic_ignore}                                   \
                    BLUR=${ic_blur}                                     \
                AUTOMASK=${ic_automask}                                 \
                 DESPIKE=${ic_despike}                                  \
                BANDPASS=${ic_bandpass}                                 \
                  POLORT=${ic_polort}                                   \
                 SEEDRAD=${ic_seedrad}                                  \
                  METHOD=${ic_method}"                                  \
    -com "INSTACORR SET      ${coord} J"                                \
    -com "SET_THRESHNEW      ${thresh}"                                 \
    -com "SET_PBAR_ALL       ${pbar_sign}${ncolors} ${topval} ${cbar}"  \
    -com "SET_FUNC_RANGE     ${frange}"                                 \
    -com "SET_XHAIRS         ${crossh}"                                 \
    -com "SET_XHAIR_GAP      ${xh_gap}"                                 \
    -com "SET_FUNC_ALPHA     ${olay_alpha}"                             \
    -com "$OW sagittalimage"                                            \
    ${all_load:q}  &

sleep 1

set l = `prompt_popup -message \
"   Run InstaCorr on AP results data:  ${label}\n\n\
\n\
InstaCorr calc using : ${ic_dset}\n\
Initial ulay dataset : ${ic_dset}\n\
         IC seed rad : ${ic_seedrad} mm\n\
         IC blur rad : ${ic_blur} mm\n\
         IC polort N : ${ic_polort}\n\
\n\
Wait briefly for initial correlation patterns to appear.  \n\
\n\
To use InstaCorr:\n\
+ Hold down Ctrl+Shift\n\
+ Left-click in the dataset\n\
+ Drag the cursor around.\n\
... and correlation patterns instantly update\n\
from each new seed location.\n\
\n\
To jump to particular coordinates:\n\
+ Right-click -> 'Jump to (xyz)' \n\
+ Enter 3 space-separated coords\n\
+ Right-click -> 'InstaCorr set'\n\
\n\
Alpha (transparent) thresholding is ON, and boxes have\n\
been placed around suprathreshold regions.\n\
\n" \
-b '          Done - Close AFNI GUI          '`

if ("$l" != "1") then
    echo "+* Warn: InstaCorr guidance message failed to open"
endif

echo "++ Quiet talkers"
@Quiet_Talkers -quiet -npb_val ${portnum}

cat << EOF
===========================================
++ Goodbye, and thank you for InstaCorring.

EOF
exit 0
