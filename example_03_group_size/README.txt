The demo contains a set of AFNI-based (Cox, 1996) processing scripts
and data for some visualizing group-level results generated from the
publicly available NARPS (Botvinik-Nezer et al., 2020) FMRI data. This
set of data and scripts were used in Ex. 3 of the "Go Figure" draft.

This demo looks at the changes to reported group results for both
opaque and transparent thresholding, as the group size changes. The
full group contains 47 subjects from the equalRange group of the NARPS
open data. The original group size was 54 subjects, but 7 were
excluded as part of processing QC.

The group analysis in each case was a simple 1-sample t-test, run via
AFNI's 3dttest++ generated from the following command (only the number
of subjects in the group changed in this demo):

    gen_group_command.py                                  \
        -command        3dttest++                         \
        -prefix         ttest++_result_${nnndrop2}        \
        -write_script   ${tt_script}                      \
        -dsets          ${all_dset_reml}                  \
        -dset_sid_list  ${all_subj}                       \
        ${drop_opt}                                       \
        -subj_prefix    sub-                              \
        -set_labels     ${label}                          \
        -subs_betas     "${beta}"                         \
        -verb           2                                 \
        -options                                          \
              -mask     ${mask_name}                      \
              -Clustsim                                   \
              -seed     5                                 \
        |& tee out.ggc


---------------------------------------------------------------------------

Data description
----------------

  group_analysis.CSIM.1grp.equalRange.gain.min-0??/
    Input directories, containing group level results from NARPS's
    equalRange group, for the 'gain' stimulus contrast. The last 2
    numbers encode how many subjects were _removed_ from the original
    47.  Thus, group*.min-005/ contains results from 42 subjects.

  extra_datasets/
    Two reference datasets used in this analysis:
    group_mask.inter.nii.gz         : a group-level whole brain mask
    MNI152_2009_template_SSW.nii.gz : the processing's reference template, 
                                      used for underlaying in images

  clust_min_cases_ex3/
    The output directory, whose contents are entirely created by running
    do_40*.tcsh and do_41*.tcsh. The main outputs are the images, shown 
    in Fig. 3 of the main paper.

---------------------------------------------------------------------------

Scripts description
-------------------

  Each of the following scripts would be run by simply executing:
    tcsh NAME.tcsh
  They don't need to be run here, because the clust_min_cases_ex3/
  directory has already been populated, when distributed.

  do_40_check_clust.tcsh
    Make images showing the clusters (with and without transparent
    thresholding), using @chauffeur_afni.

  do_41_dice_pearson_coeffs.tcsh
    Make images showing similarity matrices for thresholded and
    unthresholded datasets. These are estimated with Dice and Pearson
    correlation coefficients, respectively.
