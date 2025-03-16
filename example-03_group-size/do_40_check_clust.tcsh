#!/bin/tcsh

# Create images of group results for Ex. 3 of the "Go Figure" draft,
# where group analyses contained subsets of the same group of
# subjects.
# 
# Images with both transparent and opaque thresholding are created.
# Outlines are put around all suprathreshold clusters, to facilitate
# visibility.
#
# This script is run from the directory that contains all the
# `3dttest++ -ClustSim ..` output directories.
#
# ============================================================================
# input/output info

# Output directory
set odir = clust_min_cases_ex3

# Whole brain mask dset (might not always be used here in future)
set dset_mask = extra_datasets/group_mask.inter.nii.gz

# Ref dset to underlay in the images
set ulay = extra_datasets/MNI152_2009_template_SSW.nii.gz

# Main clustering parameters
set clust_pthr  = 0.001
set clust_alpha = 0.05

# ============================================================================
# processing

# Make output dir
\mkdir -p ${odir}

# Image setttings are that constant across all dsets
set coords     = ( 0 0 32 )
set del_sli    = ( 11 11 11 )
set img_params = ( \
                   -cbar              Reds_and_Blues_Inv   \
                   -ulay_range        0% 98%               \
                   -func_range        0.005                \
                   -set_subbricks     0 0 1                \
                   -blowup            2                    \
                   -opacity           9                    \
                   -thr_olay_p2stat   ${clust_pthr}        \
                   -thr_olay_pside    bisided              \
                   -olay_boxed_color  white                \
                   -montx             3                    \
                   -monty             1                    \
                   -set_dicom_xyz     ${coords}            \
                   -delta_slices      ${del_sli}           \
                   -set_xhairs        OFF                  \
                   -no_cor                                 \
                   -label_mode        0                    \
                   -label_size        0  )

# loop over all variations of group size (nn is number of subj removed)
foreach nn ( `seq 0 1 9` `seq 10 5 30` )
    set nnn    = `printf "%03d" ${nn}`
    set dir    = group_analysis.CSIM.1grp.equalRange.gain.min-${nnn}
    set file   = ${dir}/ttest++_result_${nnn}.CSimA.NN2_bisided.1D
    
    # Extract cluster threshold size from 3dClustSim's 1D text file
    set nclust = `1d_tool.py                     \
                      -verb        0             \
                      -infile      ${file}       \
                      -csim_pthr   ${clust_pthr} \
                      -csim_alpha  ${clust_alpha}`

    # Make cluster maps
    3dClusterize                                                             \
        -overwrite                                                           \
        -inset       ${dir}/ttest++_result_${nnn}+tlrc.HEAD                  \
        -ithr        1                                                       \
        -idat        0                                                       \
        -mask        ${dset_mask}                                            \
        -NN          2                                                       \
        -bisided     p=${clust_pthr}                                         \
        -clust_nvox  ${nclust}                                               \
        -pref_map    ${odir}/Cluster_min-${nnn}_Map.nii.gz                   \
        -pref_dat    ${odir}/Cluster_min-${nnn}_EffEst.nii.gz                \
        >            ${odir}/Cluster_min-${nnn}_Table.1D

    if ( $status ) then
        exit 1
    endif

    # For similarity matrices: copy Tstat (continuum data)
    3dcalc                                                                   \
        -overwrite                                                           \
        -a          ${dir}/ttest++_result_${nnn}+tlrc.HEAD'[1]'              \
        -expr       'a'                                                      \
        -prefix     ${odir}/dset_${nnn}__Tstat.nii.gz

    # For similarity matrices: binarize clusts, or use all 0s
    if ( -f ${odir}/Cluster_min-${nnn}_EffEst.nii.gz ) then
        # pos clust
        3dcalc                                                               \
            -overwrite                                                       \
            -a          ${odir}/Cluster_min-${nnn}_EffEst.nii.gz             \
            -expr       'ispositive(a)'                                      \
            -prefix     ${odir}/mask_01_${nnn}_posthr.nii.gz                 \
            -datum      byte
        # neg clust
        3dcalc                                                               \
            -a          ${odir}/Cluster_min-${nnn}_EffEst.nii.gz             \
            -overwrite                                                       \
            -expr       'isnegative(a)'                                      \
            -prefix     ${odir}/mask_02_${nnn}_negthr.nii.gz                 \
            -datum      byte
        # all clust
        3dcalc                                                               \
            -overwrite                                                       \
            -a          ${odir}/Cluster_min-${nnn}_EffEst.nii.gz             \
            -expr       'bool(a)'                                            \
            -prefix     ${odir}/mask_03_${nnn}_allthr.nii.gz                 \
            -datum      byte
    else
        # pos clust
        3dcalc                                                               \
            -overwrite                                                       \
            -a          ${dset_mask}                                         \
            -expr       '0'                                                  \
            -prefix     ${odir}/mask_01_${nnn}_posthr.nii.gz                 \
            -datum      byte
        # neg clust
        3dcalc                                                               \
            -overwrite                                                       \
            -a          ${dset_mask}                                         \
            -expr       '0'                                                  \
            -prefix     ${odir}/mask_02_${nnn}_negthr.nii.gz                 \
            -datum      byte
        # all clust
        3dcalc                                                               \
            -overwrite                                                       \
            -a          ${dset_mask}                                         \
            -expr       '0'                                                  \
            -prefix     ${odir}/mask_03_${nnn}_allthr.nii.gz                 \
            -datum      byte
    endif

    set all_ab = ( Yes No )

    foreach ab ( ${all_ab} )
        set alpha = ${ab}
        set boxed = Yes        # place boxes around clusters in all imgs
        set opref = ${odir}/img_narps_min-${nnn}_alpha-${alpha}_boxed-${boxed}

        set olay  = ${dir}/ttest++_result_${nnn}+tlrc.HEAD

        @chauffeur_afni                                                      \
            -ulay              ${ulay}                                       \
            -olay              ${olay}                                       \
            -box_focus_slices  ${dset_mask}                                  \
            -prefix            ${opref}                                      \
            -clusterize        "-NN 2 -clust_nvox ${nclust}"                 \
            -olay_alpha        ${alpha}                                      \
            -olay_boxed        ${boxed}                                      \
            -prefix            ${opref}                                      \
            ${img_params}

        if ( $status ) then
            exit 1
        endif
    end
end

exit 0
