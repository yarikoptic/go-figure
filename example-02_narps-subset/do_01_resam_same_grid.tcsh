#!/bin/tcsh

# Create a version of each NARPS result dset that is on the same grid,
# for later similarity calcs.
# 
# Also, make masks of data within MNI-reference mask for cases of:
# + where data is nonzero
# + where data is >thr
# + where data is <-thr
# + where data is > |thr|
#
# ============================================================================

# reference dset that determines the grid
set dset_grid = extra_datasets/MNI152_mask_222.nii.gz

# Threshold value (for both Z- and t-stat values, which should be
# approximately the same given the DoFs)
set thrval = 3

# Which Hypotheses to loop over? there are 9, here just loop over Hyp 1
set all_num = 1 # `seq 1 1 9`

foreach num ( ${all_num} )
    # input dir with raw datasets
    set dir_raw = data_00_basic_narps_hyp_${num}

    # output dir to put all the copies in
    set odir   = data_01_res222_hyp_${num}
    \mkdir -p ${odir}

    # get names of all input dsets
    cd ${dir_raw}
    set all_dset = `find . -name "*.nii*" | cut -b3-`
    cd -

    # loop over all dsets and make new versions
    foreach nn ( `seq 1 1 ${#all_dset}` )
        set nnn     = `printf "%03d" $nn`
        set fname   = "${all_dset[$nn]}"

        # base name of vol, and make a list of all prefixes for later
        set ibase   = `3dinfo -prefix_noext "${dir_raw}/${fname}"`
        set idir    = `dirname "${fname}"`
        set iid     = `printf "${idir}" | tail -c 4`

        # Make the resampled dset

        set dset_res = "${odir}/dset_${iid}_${idir}__${ibase}.nii.gz"
        echo "++ dset name : '${dir_raw}/${fname}'"
        echo "++ dset_res  : '${dset_res}'"
        3dresample -echo_edu                \
            -overwrite                      \
            -prefix "${dset_res}"           \
            -master "${dset_grid}"          \
            -input  "${dir_raw}/${fname}"

        if ( $status ) then
            exit 2
        endif

        # ... and make thresholded masks for each

        set dset_m0 = "${odir}/mask_00_${iid}_wbbool.nii.gz"
        set dset_m1 = "${odir}/mask_01_${iid}_posthr.nii.gz"
        set dset_m2 = "${odir}/mask_02_${iid}_negthr.nii.gz"
        set dset_m3 = "${odir}/mask_03_${iid}_allthr.nii.gz"

        # sidenote: the following warnings are not a problem here:
        ### WARNING: Template space of dataset
        ### extra_datasets/MNI152_mask_222.nii.gz does not match space
        ### of first dataset
        # ... it just denotes detailed labeling of TLRC vs MNI in
        # most/all cases
        
        echo "++ dset name: '${fname}'"
        echo "++ dset_m0  : '${dset_m0}'"
        3dcalc -echo_edu                           \
            -overwrite                             \
            -a       "${dset_res}"                 \
            -b       "${dset_grid}"                \
            -expr    "bool(a)*step(b)"             \
            -prefix  "${dset_m0}"

        if ( $status ) then
            echo "** ERROR: crash here"
            exit 10
        endif

        echo "++ dset_m1  : '${dset_m1}'"
        3dcalc                                     \
            -overwrite                             \
            -a       "${dset_res}"                 \
            -b       "${dset_grid}"                \
            -expr    "ispositive(a-${thrval})*step(b)"  \
            -prefix  "${dset_m1}"

        if ( $status ) then
            echo "** ERROR: crash here"
            exit 11
        endif

        echo "++ dset_m1  : '${dset_m2}'"
        3dcalc                                     \
            -overwrite                             \
            -a       "${dset_res}"                 \
            -b       "${dset_grid}"                \
            -expr    "isnegative(a+${thrval})*step(b)"  \
            -prefix  "${dset_m2}"

        if ( $status ) then
            echo "** ERROR: crash here"
            exit 12
        endif

        echo "++ dset_m1  : '${dset_m3}'"
        3dcalc                                     \
            -overwrite                             \
            -a       "${dset_res}"                 \
            -b       "${dset_grid}"                \
            -expr    "step(ispositive(a-${thrval})+isnegative(a+${thrval}))*step(b)"  \
            -prefix  "${dset_m3}"

        if ( $status ) then
            echo "** ERROR: crash here"
            exit 13
        endif
    end

    # concatenate everything 
    # (tr value doesn't matter, just avoid needless warn)
    cd ${odir}
    3dTcat -tr 1 -prefix DSET_ALL_hyp${num}_222.nii.gz dset_*
    if ( $status ) then
        exit 3
    endif
    cd -
end





