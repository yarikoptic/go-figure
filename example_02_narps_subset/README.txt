This demo contains a set of AFNI-based (Cox, 1996) processing scripts
and data for some visualizing group-level results generated from the
publicly available NARPS (Botvinik-Nezer et al., 2020) FMRI data. This
set of data and scripts were used in Ex. 2 of the "Go Figure" draft.

This demo looks at how similarity/variability across NARPS teams
results is not absolute, but instead depends heavily on whether (and
how) thresholding is applied.  These are a representative subset of
the NARPS teams results, simply to fit corresponding montages and
similarity matrices into a single figure. NARPS only gathered
statistics datasets from teams, so that's all we have to work with
here.

---------------------------------------------------------------------------

Data description
----------------

  extra_datasets/
    Two reference datasets used in this analysis:
    MNI152_2009_template_SSW.nii.gz : the processing's reference template, 
                                      used for underlaying in images
    MNI152_mask_222.nii.gz          : a group-level whole brain mask from 
                                      the MNI template, regridded to 
                                      2x2x2 mm**3

  list_match_1_sort_GO_FIGURE.txt
    2 column text file, with the second column listing the input 
    datasets in the order in which they should be placed in the 
    montages and similarity matrices (from earlier calculation of 
    similarity to principal components across dsets)

  data_00_basic_narps_hyp_1/
    Input directories, containing group level results from NARPS's
    teams for Hypothesis 1 (which are also the same for Hyp 3). These
    datasets are generally on different grids, and we had to denote
    the data as being in "standard space" separately in several cases.

  data_01_res222_hyp_1/
    An output directory from do_01_*.tcsh, which contains NARPS teams'
    results that have been regridded to the same grid, by referrring to
    MNI152_mask_222.nii.gz; this allows similarity measures to be 
    estimated across the dsets. This directory also contains relevant
    masks for each dset*.nii.gz: a mask of positive-valued clusters, 
    of negative-valued clusters, and of all (signless) clusters.

  data_04_QC_images_hyp_1/
    An output directory from do_04_*.tcsh, which contains images of
    each NARPS teams stats results, overlaid on the MNI template
    (img*png files). There are sets of axial, sagittal and coronal
    images, as well as of transparently thresholded ("*alpha*png") and
    opaquely thresholded ("*psi*.png", note the pronunciation)
    images. There is also a montage for each view and style of
    image-izing ("ALL*.jpg").

  data_41_similar_matrices_1/
    An output directory from do_41_*.tcsh, which contains images of
    similarity matrices for Dice coefficients (for opaquely thresholded
    data) and Pearson Correlation coefs (for unthresholded data).

---------------------------------------------------------------------------

Scripts description
-------------------

  Each of the following scripts would be run by simply executing:
    tcsh NAME.tcsh
  They don't need to be run here, because the data_*/ directories have
  already been populated, when distributed. The output directories of 
  each have matching enumeration and names.

  do_01_resam_same_grid.tcsh
    Make resampled versions of the input NARPS teams' stats dsets, to have
    the same grid. Also make threshold-based masks for each.

  do_04_QC_images.tcsh
    Make individual images of NARPS teams' stats dsets (in sets of slice-
    views, as well as thresholding choices). Also make a montage of 
    each relevant batch.

  do_41_similar_matrices.tcsh
    Make images of similarity matrices for the dichotomized/thresholded
    data (with Dice coefficients) and for the continuous/unthresholded
    data (with Pearson correlation).
