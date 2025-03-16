#!/bin/tcsh

# this is a semi-slow process, so divide up into three batches

# useful input ref dset and location
set ref  = extra_datasets/MNI152_2009_template.nii.gz
set here = $PWD

# Options that are common to the @chauffeur_afni commands, below
set chauff_opts = ( \
            -ulay           ${ref}                                           \
            -ulay_range     "2%" "110%"                                      \
            -set_subbricks  -1 0 0                                           \
            -func_range     5                                                \
            -thr_olay       3                                                \
            -cbar           Reds_and_Blues_Inv                               \
            -opacity        7                                                \
            -montx          1                                                \
            -monty          1                                                \
            -set_dicom_xyz  5 18 18                                          \
            -set_xhairs     OFF                                              \
            -label_mode     1                                                \
            -label_size     3  )


# In general, loop over all 9 hypotheses ( `seq 1 1 9` ), but here just 1 
set all_num = ( 1 ) 

foreach num ( ${all_num} ) 
    set hyp   = "hypo${num}"
    set ilist = `cat list_match_${num}_sort_GO_FIGURE.txt | awk '{print $2}'` 

    set lcol  = ( 255 255 255 )                        # RGB color b/t panels
    set odir  = ${here}/data_04_QC_images_hyp_${num}   # output dir for images

    \mkdir -p ${odir}

    # =========================================================================

    set allbase = ()
    set allid   = ()
    set allfile = ()

    # ----- Make a montage of the zeroth brick of each image.

    foreach nn ( `seq 1 1 ${#ilist}` )
        set nnn     = `printf "%03d" $nn`
        set ff      = "${ilist[$nn]}"
        # base name of vol, and make a list of all prefixes for later
        set ibase   = `3dinfo -prefix_noext "${ff}"`
        set idir    = `dirname "${ff}"`
        set iid     = `printf "${idir}" | tail -c 4`

        set allbase = ( ${allbase} ${ibase} )
        set allid   = ( ${allid}   ${iid} )
        set allfile = ( ${allfile} ${ff} )

        echo "++ iid = '${iid}'; ibase = '${ibase}'; idir = '${idir}'"

        # two sets of images: with and without transparent thr (respectively)
        @chauffeur_afni                                                      \
            -olay           ${ff}                                            \
            -olay_alpha     Linear                                           \
            -olay_boxed     Yes                                              \
            -prefix         ${odir}/img_${nnn}_alpha_${iid}                  \
            -label_string   "::${iid}"                                       \
            ${chauff_opts}

        @chauffeur_afni                                                      \
            -olay           ${ff}                                            \
            -olay_alpha     No                                               \
            -olay_boxed     No                                               \
            -prefix         ${odir}/img_${nnn}_psi_${iid}                    \
            -label_string   "::${iid}"                                       \
            ${chauff_opts}

        if ( $status ) then
            exit 1
        endif

    end

    # =========================================================================

    # get a good number of rows/cols for this input

    set nallbase = ${#allbase}
    adjunct_calc_mont_dims.py ${nallbase} __tmp_${hyp}
    set dims = `tail -n 1 __tmp_${hyp}`

    # =========================================================================

    # output subj list

    set file_subj = "${odir}/list_of_all_subj.txt"
    printf "" > ${file_subj}
    foreach ii ( `seq 1 1 ${nallbase}` )
        printf "%4s  %30s\n" ${allid[$ii]} ${allfile[$ii]} >> ${file_subj}
    end

    # ========================================================================

    # common options for 2dcat, below
    set opts_2dcat = ( \
            -echo_edu                                                     \
            -gap 5                                                        \
            -gap_col ${lcol}                                              \
            -ny ${dims[4]}                                                \
            -nx ${dims[3]}                                                \
            -zero_wrap )

    set all_ss = ( "sag" "cor" "axi" )

    foreach ss ( ${all_ss} )
        # Combine alpha-thresholded images
        2dcat                                                             \
            ${opts_2dcat}                                                 \
            -prefix ${odir}/ALL_alpha_${hyp}_sview_${ss}.jpg              \
            ${odir}/img_*_alpha*${ss}*

        # Combine non-alpha-thresholded images
        2dcat                                                             \
            ${opts_2dcat}                                                 \
            -prefix ${odir}/ALL_psi_${hyp}_sview_${ss}.jpg                \
            ${odir}/img_*_psi*${ss}*

        if ( $status ) then
            exit 1
        endif
    end
end


