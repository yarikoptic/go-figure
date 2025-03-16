#!/bin/tcsh

# Create similarity matrices for Ex. 2 of the "Go Figure" draft, over
# a representative subset of NARPS's team submissions.
# 
# Similarity matrices include both Dice coefficients (when opaque
# thresholding is used) and Pearson correlation (for transparent or
# un-thresholded datasets are used).
#
# In the NARPS project, Hyp 1 and 3 datasets are all the same. These
# are the ones we look at here.
#
# ============================================================================
# make corr mats and images

# reference dset
set dset_grid = extra_datasets/MNI152_mask_222.nii.gz

# Threshold value (for both Z- and t-stat values, which should be
# approximately the same given the DoFs)
set thrval = 3

# in general, loop over all 9 hypotheses ( `seq 1 1 9` ), but here just 1
set all_num = ( 1 ) 

foreach num ( ${all_num} )

    # Set and check names of I/O dirs
    set resdir = data_01_res222_hyp_${num}
    set odir   = data_41_similar_matrices_${num}

    \mkdir -p ${odir}

    # Get the list of dsets, ordered, from *this* file
    set all_dset = `cat list_match_${num}_sort_GO_FIGURE.txt | awk '{print $2}'`

    echo "++ Hyp number : ${num}"
    echo "++ N all_dset : ${#all_dset}"
    echo "++   all_dset : ${all_dset}"

    # Prepare label IDs and lists of dsets
    set all_iid = ()
    set all_dset_res = ()
    set all_dset_m0  = ()
    set all_dset_m1  = ()
    set all_dset_m2  = ()
    set all_dset_m3  = ()
    foreach nn ( `seq 1 1 ${#all_dset}` )
        set nnn     = `printf "%03d" $nn`
        set fname   = "${all_dset[$nn]}"

        # Base name of vol, and make a list of all prefixes for later
        set ibase   = `3dinfo -prefix_noext "${fname}"`
        set idir    = `dirname "${fname}"`
        set dirnarp = `basename "${idir}"`
        set iid     = `printf "${dirnarp}" | tail -c 4`

        # each is a useful input dset here
        set dset_res = "${resdir}/dset_${iid}_${dirnarp}__${ibase}.nii.gz"
        set dset_m0  = "${resdir}/mask_00_${iid}_wbbool.nii.gz"
        set dset_m1  = "${resdir}/mask_01_${iid}_posthr.nii.gz"
        set dset_m2  = "${resdir}/mask_02_${iid}_negthr.nii.gz"
        set dset_m3  = "${resdir}/mask_03_${iid}_allthr.nii.gz"

        # the accumulating lists
        set all_iid      = ( ${all_iid} ${iid} )
        set all_dset_res = ( ${all_dset_res} ${dset_res} )
        set all_dset_m0  = ( ${all_dset_m0}  ${dset_m0} )
        set all_dset_m1  = ( ${all_dset_m1}  ${dset_m1} )
        set all_dset_m2  = ( ${all_dset_m2}  ${dset_m2} )
        set all_dset_m3  = ( ${all_dset_m3}  ${dset_m3} )
    end

    # ======================================================================
    # create *.netcc file: for Dice coef (masked regions)
    
    set onetcc = ${odir}/matrix_dice_hyp${num}.netcc

    printf "" > ${onetcc}

    # header
    printf "# %d  # Number of network ROIs\n"   "${#all_dset}"  >> ${onetcc}
    printf "# %d  # Number of netcc matrices\n" "3"             >> ${onetcc}
    printf "# WITH_ROI_LABELS\n"                                >> ${onetcc}

    # 'ROI' (= dset) labels, numbers
    printf "   ${all_iid}\n"                 >> ${onetcc}
    echo   "   `seq 1 1 ${#all_dset}`"       >> ${onetcc}

    printf "# Dice_pos\n"
    printf "# Dice_pos\n"                    >> ${onetcc}
    3ddot -full -dodice ${all_dset_m1}       >> ${onetcc}

    if ( $status ) then
        exit 1
    endif

    printf "# Dice_neg\n"
    printf "# Dice_neg\n"                    >> ${onetcc}
    3ddot -full -dodice ${all_dset_m2}       >> ${onetcc}

    if ( $status ) then
        exit 1
    endif

    printf "# Dice_all\n"
    printf "# Dice_all\n"                    >> ${onetcc}
    3ddot -full -dodice ${all_dset_m3}       >> ${onetcc}

    if ( $status ) then
        exit 1
    endif

    fat_mat2d_plot.py                         \
        -input   ${onetcc}                    \
        -ftype   svg                          \
        -cbar    Reds                         \
        -vmin    0                            \
        -vmax    1
    fat_mat2d_plot.py                         \
        -input   ${onetcc}                    \
        -ftype   tif                          \
        -cbar    Reds                         \
        -vmin    0                            \
        -vmax    1

    if ( $status ) then
        exit 1
    endif

    # ======================================================================
    # create *.netcc file: Pearson correlation, for continuous WB measures
    
    set onetcc = ${odir}/matrix_cont_hyp${num}.netcc
    printf "" > ${onetcc}

    # header
    printf "# %d  # Number of network ROIs\n"   "${#all_dset}"  >> ${onetcc}
    printf "# %d  # Number of netcc matrices\n" "1"             >> ${onetcc}
    printf "# WITH_ROI_LABELS\n"                                >> ${onetcc}

    # 'ROI' (= dset) labels, numbers
    printf "   ${all_iid}\n"                 >> ${onetcc}
    echo   "   `seq 1 1 ${#all_dset}`"       >> ${onetcc}

    printf "# Corr_coef\n"
    printf "# Corr_coef\n"                   >> ${onetcc}
    3ddot -full -docor -mask ${dset_grid} \
        ${all_dset_res}                      >> ${onetcc}

    if ( $status ) then
        exit 1
    endif

    # similarity matrices
    fat_mat2d_plot.py                         \
        -input   ${onetcc}                    \
        -ftype   svg                          \
        -cbar    seismic                      \
        -vmin    -1                           \
        -vmax     1
    fat_mat2d_plot.py                         \
        -input   ${onetcc}                    \
        -ftype   tif                          \
        -cbar    seismic                      \
        -vmin    -1                           \
        -vmax     1

    if ( $status ) then
        exit 1
    endif
end



echo "++ DONE"

exit 0
