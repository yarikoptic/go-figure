#!/bin/tcsh

# Create similarity matrices for Ex. 3 of the "Go Figure" draft, where
# group analyses contained subsets of the same group of subjects.
# 
# Similarity matrices include both Dice coefficients (when opaque
# thresholding is used) and Pearson correlation (for transparent or
# un-thresholded datasets are used).
#
# This script is run from the directory that contains all the
# `3dttest++ -ClustSim ..` output directories.  This must be run after
# "do_40_*.tcsh".
#
# ============================================================================
# input/output info

# This output directory already exists, from running do_40_*.tcsh
set odir      = clust_min_cases_ex3

# Whole brain mask dset (constrain region for spatial correlation to brain)
set dset_mask = extra_datasets/group_mask.inter.nii.gz

# ============================================================================
# prepare label IDs and lists of dsets

if ( ! -d ${odir} ) then
    echo "** ERROR: output dir doesn't exist."
    echo "          Run 'do_40_*.tcsh' script first."
    exit 1
endif

set all_iid      = ()
foreach nn ( `seq 0 1 9` `seq 10 5 30` )
    set nsubj   = `echo "47 - ${nn}" | bc`
    set all_iid = ( ${all_iid} Nsubj_${nsubj} )
end

set all_dset_res = ( `find ./${odir} -name "dset_*__Tstat.nii.gz" \
                        |  cut -b3- | sort` )
set all_dset_m1 = ( `find ./${odir} -name "mask_01_*_posthr.nii.gz" \
                        |  cut -b3- | sort` )
set all_dset_m2 = ( `find ./${odir} -name "mask_02_*_negthr.nii.gz" \
                        |  cut -b3- | sort` )
set all_dset_m3 = ( `find ./${odir} -name "mask_03_*_allthr.nii.gz" \
                        |  cut -b3- | sort` )
set ndset = ${#all_dset_m3}

echo "++ All IDs: $all_iid"


# ======================================================================
# create *.netcc file: for WB Dice coef (dichotomized data)

# Clear output text file
set onetcc = ${odir}/matrix_dice_NSUBJ.netcc
printf "" > ${onetcc}

# Make header
printf "# %d  # Number of network ROIs\n"   "${ndset}"      >> ${onetcc}
printf "# %d  # Number of netcc matrices\n" "3"             >> ${onetcc}
printf "# WITH_ROI_LABELS\n"                                >> ${onetcc}

# Add 'ROI' (= dset) labels, numbers
printf "   ${all_iid}\n"                 >> ${onetcc}
echo   "   `seq 1 1 ${ndset}`"           >> ${onetcc}


# Calculate the data part, dumped into same text file
printf "# Dice_pos\n"
printf "# Dice_pos\n"                    >> ${onetcc}
3ddot                                    \
    -full                                \
    -dodice                              \
    ${all_dset_m1}                       \
    >> ${onetcc}

if ( $status ) then
    exit 1
endif

# Calculate the data part, dumped into same text file
printf "# Dice_neg\n"
printf "# Dice_neg\n"                    >> ${onetcc}
3ddot                                    \
    -full                                \
    -dodice                              \
    ${all_dset_m2}                       \
    >> ${onetcc}

if ( $status ) then
    exit 1
endif

# Calculate the data part, dumped into same text file
printf "# Dice_all\n"
printf "# Dice_all\n"                    >> ${onetcc}
3ddot                                    \
    -full                                \
    -dodice                              \
    ${all_dset_m3}                       \
    >> ${onetcc}

if ( $status ) then
    exit 1
endif

# make plots: both SVG and TIF format
fat_mat2d_plot.py                        \
    -input   ${onetcc}                   \
    -ftype   svg                         \
    -cbar    Reds                        \
    -vmin    0                           \
    -vmax    1
fat_mat2d_plot.py                        \
    -input   ${onetcc}                   \
    -ftype   tif                         \
    -cbar    Reds                        \
    -vmin    0                           \
    -vmax    1

if ( $status ) then
    exit 1
endif

# ======================================================================
# create *.netcc file: for WB Pearson correlation (continuous data)

# Clear output text file
set onetcc = ${odir}/matrix_cont_NSUBJ.netcc
printf "" > ${onetcc}

# Make header
printf "# %d  # Number of network ROIs\n"   "${ndset}"      >> ${onetcc}
printf "# %d  # Number of netcc matrices\n" "1"             >> ${onetcc}
printf "# WITH_ROI_LABELS\n"                                >> ${onetcc}

# Add 'ROI' (= dset) labels, numbers
printf "   ${all_iid}\n"                 >> ${onetcc}
echo   "   `seq 1 1 ${ndset}`"           >> ${onetcc}

# Calculate the data part, dumped into same text file
printf "# Corr_coef\n"
printf "# Corr_coef\n"                   >> ${onetcc}
3ddot                                    \
    -full                                \
    -docor                               \
    -mask   ${dset_mask}                 \
    ${all_dset_res}                      \
    >> ${onetcc}

if ( $status ) then
    exit 1
endif

# Make plots: both SVG and TIF format
fat_mat2d_plot.py                        \
    -input   ${onetcc}                   \
    -ftype   svg                         \
    -cbar    seismic                     \
    -vmin    -1                          \
    -vmax     1
fat_mat2d_plot.py                        \
    -input   ${onetcc}                   \
    -ftype   tif                         \
    -cbar    seismic                     \
    -vmin    -1                          \
    -vmax     1

if ( $status ) then
    exit 1
endif

exit 0
