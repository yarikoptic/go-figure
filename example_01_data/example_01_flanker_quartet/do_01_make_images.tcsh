#!/bin/tcsh

set ulay = MNI152_2009_template_SSW.nii.gz
set olay = dset_coef_stat.nii.gz
set mask = mask.nii.gz

# voxelwise thr value (AFNI stats program outputs can generally
# convert p-to-stat internally; we also show p2statsdset program usage)
set pthr = 0.001

# Transparent thresholding on and off, respectively
set all_style = ( Yes No )

# ===========================================================================
# Preliminary example, original dset 
# NB: these images not used in draft---retained for info/demo purposes

# This loop makes montages of the original dataset, with effect
# estimate as overlay and stats data only used for thresholding.  This
# method of visualization is preferred over just showing stats, but to
# keep Ex. 1 focused on the transparent thresholding aspect (for those
# not used to showing the effect estimate as overlay, instead of
# stats), these were not used in the draft.

# loop over both transparent and opaque thresholding styles
foreach style ( ${all_style} )

    set idx   = 00
    set opref = img_dset_${idx}_alpha-${style}_olay-effest

    # original data
    #
    # NOTES
    # 
    # + effect est as olay and stats as thr ('-set_subbricks ..')
    # + Clusterizing performed, with 3dClusterize opts ('-clusterize ..')
    #   - this dset has already been masked, but in future we likely might not

    @chauffeur_afni                                                          \
        -ulay             ${ulay}                                            \
        -olay             ${olay}                                            \
        -cbar             Reds_and_Blues_Inv                                 \
        -func_range       0.05                                               \
        -set_dicom_xyz    0 18 34                                            \
        -delta_slices     5 5 5                                              \
        -set_subbricks    0 "cond" "cond_Z"                                  \
        -clusterize       "-NN 2 -clust_nvox 40"                             \
        -thr_olay_p2stat  ${pthr}                                            \
        -thr_olay_pside   bisided                                            \
        -olay_alpha       ${style}                                           \
        -olay_boxed       ${style}                                           \
        -opacity          9                                                  \
        -prefix           ${opref}                                           \
        -pbar_saveim      ${opref}_cbar                                      \
        -set_xhairs       OFF                                                \
        -montx            5                                                  \
        -monty            1                                                  \
        -label_mode       1                                                  \
        -label_size       4

    if ( $status ) then
        exit 1
    endif
end

# ==========================================================================
# Intermediate calcs for variations

set statthr = `p2dsetstat                             \
                -quiet                                \
                -pval ${pthr}                         \
                -bisided                              \
                -inset dset_coef_stat.nii.gz"[cond_Z]"`

cat <<EOF 

++ Stat thr: ${statthr}

EOF

# generate cluster map from above 3dClusterize-via-@chauffeur_afni
# usage, but with a new prefix
set opref     = img_dset_00_alpha-No_olay-effest          # which run from above?
set clust_cmd = `grep -v pref_map ${opref}_clust_cmd.txt | tr '\' ' '`
set clust_cmd = "${clust_cmd} -pref_map CLUSTMAP.nii.gz -overwrite -echo_edu"

# run that recreated command
${clust_cmd}

if ( $status ) then
    exit 1
endif

# Make a copy of just stats data, for variations
3dcalc                                                                       \
    -overwrite                                                               \
    -echo_edu                                                                \
    -a          dset_coef_stat.nii.gz'[cond_Z]'                              \
    -expr       "a"                                                          \
    -prefix     var0_coef_stat.nii.gz

if ( $status ) then
    exit 1
endif

# ==========================================================================
# Variations, used in Fig. 1, panels A, B and D

# --------------------------------------------------------------------------
# VARIATION 1 : LHS negated outside clust

3dcalc                                                                       \
    -overwrite                                                               \
    -echo_edu                                                                \
    -a          var0_coef_stat.nii.gz                                        \
    -b          CLUSTMAP.nii.gz                                              \
    -expr       "bool(b)*a + not(bool(b))*(not(step(x))*a-step(x)*a)"        \
    -prefix     var1_coef_stat.nii.gz

if ( $status ) then
    exit 1
endif

# --------------------------------------------------------------------------
# VARIATION 2 : LHS zeroed outside clust

3dcalc                                                                       \
    -overwrite                                                               \
    -echo_edu                                                                \
    -a          var0_coef_stat.nii.gz                                        \
    -b          CLUSTMAP.nii.gz                                              \
    -expr       "bool(b)*a + not(bool(b))*(not(step(x))*a-step(x)*0)"        \
    -prefix     var2_coef_stat.nii.gz

if ( $status ) then
    exit 1
endif

# --------------------------------------------------------------------------
# VARIATION 3 : random values outside clust

3dcalc                                                                       \
    -overwrite                                                               \
    -echo_edu                                                                \
    -a          var0_coef_stat.nii.gz                                        \
    -b          CLUSTMAP.nii.gz                                              \
    -c          csim_output_A_times3_mb2b.nii.gz                             \
    -d          mask.nii.gz                                                  \
    -expr       "bool(b)*a + not(bool(b))*c*d"                               \
    -prefix     var3_coef_stat.nii.gz

3drefit -sublabel 0 'cond_Z' var3_coef_stat.nii.gz

if ( $status ) then
    exit 1
endif

# ============================================================================
# Make images of the variations

# These images use the stats data for both olay and thr
# information. This is ultimately not preferably, but was used for the
# early Ex. 1 in the draft.

foreach var ( `seq 0 1 3` ) 
    set idx = `printf "%02d" ${var}`

    set olay_var = var${var}_coef_stat.nii.gz

    foreach style ( ${all_style} )

        set opref = img_vars_${idx}_alpha-${style}_olay-stat

        # NB: this is only of stats
        @chauffeur_afni                                                      \
            -ulay             ${ulay}                                        \
            -olay             ${olay_var}                                    \
            -cbar             Reds_and_Blues_Inv                             \
            -func_range       4                                              \
            -set_dicom_xyz    0 18 36                                        \
            -delta_slices     5 5 5                                          \
            -set_subbricks    0 "cond_Z" "cond_Z"                            \
            -clusterize       "-NN 2 -clust_nvox 40"                         \
            -thr_olay_p2stat  ${pthr}                                        \
            -thr_olay_pside   bisided                                        \
            -olay_alpha       ${style}                                       \
            -olay_boxed       ${style}                                       \
            -opacity          9                                              \
            -prefix           ${opref}                                       \
            -pbar_saveim      ${opref}_cbar                                  \
            -set_xhairs       OFF                                            \
            -montx            1                                              \
            -monty            1                                              \
            -label_mode       0                                              \
            -label_size       4                                              \
            -crop_axi_x       15 178                                         \
            -crop_axi_y       20 208                                         \
            -crop_cor_x       15 178                                         \
            -crop_cor_y       15 178                                         \
            -crop_sag_x       20 208                                         \
            -crop_sag_y       15 178                                         \
            -no_sag                                                          \
            -no_cor

        if ( $status ) then
            exit 1
        endif
    end
end
