The data and script in this directory are used to create the brain
images used in Fig. 1 of the "Go Figure" draft.

The data were the result of an earlier study, see: 

  Chen G, Pine DS, Brotman MA, Smith AR, Cox RW, Taylor PA, Haller SP
  (2022). Hyperbolic trade-off: the importance of balancing trial and
  subject sample sizes in neuroimaging. NeuroImage 247:118786.
  https://pubmed.ncbi.nlm.nih.gov/34906711/

# --------------------------------------------------------------------------------

To generate images in this directory, run the included script as follows:

  tcsh do_01_make_images.tcsh

# --------------------------------------------------------------------------------

Datasets in the directory ab initio:

  dset_coef_stat.nii.gz            : main dset here, the results of 3dLMEr 
                                     modeling. Contains 2 subvolumes: 
                                     [0] the effect estimate
                                     [1] the stats volume (Z-stat)

  mask.nii.gz                      : whole brain mask of the dset*.nii.gz dset,
                                     though likely in future work we would not
                                     apply a mask to the results (see Ex. 4)

  csim_output_A_times3_mb2b.nii.gz : intermediate file from 3dClustSim execution,
                                     to create smoothed background "noise" for
                                     Image 3 in Fig. 1D (the fourth member of 
                                     the neuroimaging Quartet in Ex. 1)

  MNI152_2009_template_SSW.nii.gz  : MNI template distributed by AFNI (with extra
                                     subvolumes for running sswarper2, etc.)
