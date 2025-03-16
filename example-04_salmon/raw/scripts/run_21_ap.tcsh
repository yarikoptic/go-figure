#!/bin/tcsh

# DESC: run AP to fully process FMRI data (here, for the salmon scan)

# Process one or more subjects via corresponding do_*.tcsh script,
# looping over subj+ses pairs.
# Run on a slurm/swarm system (like Biowulf) or on a desktop.

# To execute:  
#     tcsh RUN_SCRIPT_NAME

# ---------------------------------------------------------------------------

# use slurm? 1 = yes, 0 = no, def: use if available
set use_slurm = $?SLURM_CLUSTER_NAME

# --------------------------------------------------------------------------

# specify script to execute
set cmd           = 21_ap

# upper directories
set dir_scr       = $PWD
set dir_inroot    = ..
set dir_log       = ${dir_inroot}/logs
set dir_swarm     = ${dir_inroot}/swarms
set dir_basic     = ${dir_inroot}/data_00_basic

# names for logging and swarming/running
set cdir_log      = ${dir_log}/logs_${cmd}
set scr_swarm     = ${dir_swarm}/swarm_${cmd}.txt
set scr_cmd       = ${dir_scr}/do_${cmd}.tcsh

# --------------------------------------------------------------------------

# create log and swarm dirs
\mkdir -p ${cdir_log}
\mkdir -p ${dir_swarm}

# clear away older swarm script 
if ( -e ${scr_swarm} ) then
    \rm ${scr_swarm}
endif

# --------------------------------------------------------------------------
# create list of subj to process

# ***** choose who to process (def: get list of all subj IDs for proc)
cd ${dir_basic}
set all_subj = ( sub-* )
cd -

cat <<EOF

++ Proc command:  ${cmd}
++ Found ${#all_subj} subj:

EOF

# -------------------------------------------------------------------------
# build swarm command from subj+ses lists

# loop over all subj
foreach subj ( ${all_subj} )

    # choose sessions per subj (def: get list of all subj IDs for proc)
    cd ${dir_basic}/${subj}
    set all_ses = ( ses-* )
    cd -

    # loop over all ses
    foreach ses ( ${all_ses} )
        echo "++ Prepare cmd for: ${subj} - ${ses}"

        # log file name for each subj+ses pair
        set log = ${cdir_log}/log_${cmd}_${subj}_${ses}.txt

        # append cmd to the swarm script (verbosely, but don't use '-e')
        # and log terminal text.
        echo "tcsh -xf ${scr_cmd} ${subj} ${ses} \\"    >> ${scr_swarm}
        echo "     |& tee ${log}"                       >> ${scr_swarm}
    end
end

# -------------------------------------------------------------------------
# run swarm command

cd ${dir_scr}

echo "++ And start swarming: ${scr_swarm}"

if ( $use_slurm ) then
    # swarm, if we are on a slurm-job system

    # NB: these parameter settings depend very much on the job being
    # done, the size of the data involved, and the software being
    # used. Each task will get its own setup like this, which might
    # have to be testd over time.

    swarm                                                          \
        -f ${scr_swarm}                                            \
        --partition=norm,quick                                     \
        --threads-per-process=8                                    \
        --gb-per-process=10                                        \
        --time=01:59:00                                            \
        --gres=lscratch:5                                          \
        --logdir=${cdir_log}                                       \
        --job-name=job_${cmd}                                      \
        --merge-output                                             \
        --usecsh
else
    # ... otherwise, simply execute the processing script
    tcsh ${scr_swarm}
endif

