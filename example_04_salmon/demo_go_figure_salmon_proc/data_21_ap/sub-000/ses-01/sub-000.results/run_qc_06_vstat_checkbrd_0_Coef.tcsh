#!/bin/tcsh 

# setup the environment a bit (more speed, fewer warnings)
setenv AFNI_IMSAVE_WARNINGS    NO
setenv AFNI_THRESH_INIT_EXPON  0
setenv AFNI_NOSPLASH           YES
setenv AFNI_SPLASH_MELT        NO
setenv AFNI_STARTUP_WARNINGS   NO
setenv AFNI_NIFTI_TYPE_WARN    NO
setenv AFNI_NO_OBLIQUE_WARNING YES
#setenv AFNI_IMAGE_GLOBALRANGE  VOLUME
setenv AFNI_IMAGE_LABEL_IJK    NO 
setenv AFNI_IMAGE_ZOOM_NN      YES
setenv AFNI_NEVER_SAY_GOODBYE  YES
setenv AFNI_MOTD_CHECK         NO
setenv AFNI_NIFTI_TYPE_WARN    NO


# define all variables used in AFNI drive command
set read_ulay    = "anat_final.sub-000+orig.HEAD"  
set read_olay    = "stats.sub-000+orig.HEAD"  
set read_dir     = "."  
set use_ad       = "-all_dsets" 
set crossh       = "SINGLE"  
set see_olay     = "+"  
set pbar_sign    = "-"  
set ncolors      = "99"  
set topval       = "1"  
set my_cbar      = "Reds_and_Blues_Inv"  
set XXX_NPANE    = ""  
set com_pbar_str = "PBAR_SAVEIM QC_sub-000/media/qc_06_vstat_checkbrd_0_Coef.pbar.jpg dim=64x512H"  
set subbb        = ( 0 1 2 )
set com_ulay_str = "SET_ULAY_RANGE A.all 0.000000 1403.254080"  
set frange       = "1.510903"  
set thrnew       = "3.321881"  
set thrflag      = "*"  
set olay_alpha   = "Yes"  
set olay_boxed   = "Yes"  
set func_resam   = "NN"  
set xh_gap       = "-1"  
set OW           = "OPEN_WINDOW"  
set opac         = "9"  
set butpress     = ""  
set mx           = "1"  
set my           = "1"  
set mgap         = "1"  
set mcolor       = "black"  
set gapord       = ( 34 36 14 )
set scropx       = ( 0 0 )  
set scropy       = ( 0 0 )  
set ccropx       = ( 0 0 ) 
set ccropy       = ( 0 0 )  
set acropx       = ( 0 0 )  
set acropy       = ( 0 0 )  
set coor_type    = "SET_DICOM_XYZ"
set coors        = ( 2.135498 -13.301 -1.328899 )  
set ftype        = "JPEG"  
set odir         = "QC_sub-000/media"  
set impref       = "qc_06_vstat_checkbrd_0_Coef"  
set bufac        = "2"  
set do_quit      = "QUITT"  

set view_planes = ( )
if ( 1 && "1" != "1" ) then
    set view_planes = ( ${view_planes:q} -com "SAVE_${ftype} axialimage    ${odir}/${impref}.axi blowup=${bufac}" )
endif
if ( 1 && "1" != "1" ) then
    set view_planes = ( ${view_planes:q} -com "SAVE_${ftype} sagittalimage ${odir}/${impref}.sag blowup=${bufac}" )
endif
if ( 0 && "1" != "1" ) then
    set view_planes = ( ${view_planes:q} -com "SAVE_${ftype} coronalimage  ${odir}/${impref}.cor blowup=${bufac}" )
endif

# port communication
set portnum = 0

# the drive command itself (without quitting)
afni -q -no1D ${XXX_NPANE} -noplugins -no_detach  -echo_edu          \
    -npb ${portnum}  ${use_ad}                                      \
    -com "SWITCH_UNDERLAY ${read_ulay}"                              \
    -com "SWITCH_OVERLAY  ${read_olay}"                              \
    -com "SEE_OVERLAY     ${see_olay}"                               \
    -com "$OW sagittalimage opacity=${opac} ${butpress}              \
           mont=${mx}x${my}:${gapord[1]}:${mgap}:${mcolor}           \
           crop=${scropx[1]}:${scropx[2]},${scropy[1]}:${scropy[2]}" \
    -com "$OW coronalimage  opacity=${opac} ${butpress}              \
           mont=${mx}x${my}:${gapord[2]}:${mgap}:${mcolor}           \
           crop=${ccropx[1]}:${ccropx[2]},${ccropy[1]}:${ccropy[2]}" \
    -com "$OW axialimage    opacity=${opac} ${butpress}              \
           mont=${mx}x${my}:${gapord[3]}:${mgap}:${mcolor}           \
           crop=${acropx[1]}:${acropx[2]},${acropy[1]}:${acropy[2]}" \
    -com "SET_PBAR_ALL    ${pbar_sign}${ncolors} $topval $my_cbar"   \
    -com "$com_pbar_str"  \
    -com "SET_SUBBRICKS   ${subbb}"                                  \
    -com "$com_ulay_str"                                             \
    -com "SET_FUNC_RANGE  ${frange}"                                 \
    -com "SET_THRESHNEW   $thrnew *"                          \
    -com "SET_FUNC_ALPHA  $olay_alpha"                               \
    -com "SET_FUNC_BOXED  $olay_boxed"                               \
    -com "SET_FUNC_RESAM  ${func_resam}.${func_resam}"               \
    -com "SET_XHAIRS      ${crossh}"                                 \
    -com "SET_XHAIR_GAP   ${xh_gap}"                                 \
    -com "$coor_type $coors"                                         \
    ${view_planes:q}                                                 \
    ${read_dir} &

set l = `prompt_popup -message \
"APQC, vstat: checkbrd_0_Coef\n\n\
\n\n\
Initial ulay dataset : ${read_ulay}\n\
Initial olay dataset : ${read_olay} (${see_olay})\n\
\n" \
-b '          Done - Close AFNI GUI          '`


if ("$l" != "1") then
    echo "+* Warn: AFNI driving guidance message failed to open"
endif

echo "++ Quiet talkers"
@Quiet_Talkers -quiet -npb_val ${portnum}

echo "================================================="
echo "++ Goodbye, and thank you for checking your data."

