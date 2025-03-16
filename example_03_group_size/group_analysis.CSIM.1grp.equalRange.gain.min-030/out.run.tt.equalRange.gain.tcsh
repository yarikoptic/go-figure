set data_dir = /data/SSCC_NARPS/globus_sync/ademo_narps/data_23_ap_task_b
3dttest++ -prefix ttest++_result_030 -setA equalRange.gain sub-002 /data/SSCC_NARPS/globus_sync/ademo_narps/data_23_ap_task_b/sub-002/sub-002.results/stats.sub-002_REML+tlrc.HEAD[Resp#1_Coef] sub-004 /data/SSCC_NARPS/globus_sync/ademo_narps/data_23_ap_task_b/sub-004/sub-004.results/stats.sub-004_REML+tlrc.HEAD[Resp#1_Coef] sub-006 /data/SSCC_NARPS/globus_sync/ademo_narps/data_23_ap_task_b/sub-006/sub-006.results/stats.sub-006_REML+tlrc.HEAD[Resp#1_Coef] sub-008 /data/SSCC_NARPS/globus_sync/ademo_narps/data_23_ap_task_b/sub-008/sub-008.results/stats.sub-008_REML+tlrc.HEAD[Resp#1_Coef] sub-010 /data/SSCC_NARPS/globus_sync/ademo_narps/data_23_ap_task_b/sub-010/sub-010.results/stats.sub-010_REML+tlrc.HEAD[Resp#1_Coef] sub-014 /data/SSCC_NARPS/globus_sync/ademo_narps/data_23_ap_task_b/sub-014/sub-014.results/stats.sub-014_REML+tlrc.HEAD[Resp#1_Coef] sub-018 /data/SSCC_NARPS/globus_sync/ademo_narps/data_23_ap_task_b/sub-018/sub-018.results/stats.sub-018_REML+tlrc.HEAD[Resp#1_Coef] sub-020 /data/SSCC_NARPS/globus_sync/ademo_narps/data_23_ap_task_b/sub-020/sub-020.results/stats.sub-020_REML+tlrc.HEAD[Resp#1_Coef] sub-022 /data/SSCC_NARPS/globus_sync/ademo_narps/data_23_ap_task_b/sub-022/sub-022.results/stats.sub-022_REML+tlrc.HEAD[Resp#1_Coef] sub-024 /data/SSCC_NARPS/globus_sync/ademo_narps/data_23_ap_task_b/sub-024/sub-024.results/stats.sub-024_REML+tlrc.HEAD[Resp#1_Coef] sub-026 /data/SSCC_NARPS/globus_sync/ademo_narps/data_23_ap_task_b/sub-026/sub-026.results/stats.sub-026_REML+tlrc.HEAD[Resp#1_Coef] sub-036 /data/SSCC_NARPS/globus_sync/ademo_narps/data_23_ap_task_b/sub-036/sub-036.results/stats.sub-036_REML+tlrc.HEAD[Resp#1_Coef] sub-038 /data/SSCC_NARPS/globus_sync/ademo_narps/data_23_ap_task_b/sub-038/sub-038.results/stats.sub-038_REML+tlrc.HEAD[Resp#1_Coef] sub-040 /data/SSCC_NARPS/globus_sync/ademo_narps/data_23_ap_task_b/sub-040/sub-040.results/stats.sub-040_REML+tlrc.HEAD[Resp#1_Coef] sub-044 /data/SSCC_NARPS/globus_sync/ademo_narps/data_23_ap_task_b/sub-044/sub-044.results/stats.sub-044_REML+tlrc.HEAD[Resp#1_Coef] sub-046 /data/SSCC_NARPS/globus_sync/ademo_narps/data_23_ap_task_b/sub-046/sub-046.results/stats.sub-046_REML+tlrc.HEAD[Resp#1_Coef] sub-050 /data/SSCC_NARPS/globus_sync/ademo_narps/data_23_ap_task_b/sub-050/sub-050.results/stats.sub-050_REML+tlrc.HEAD[Resp#1_Coef] sub-052 /data/SSCC_NARPS/globus_sync/ademo_narps/data_23_ap_task_b/sub-052/sub-052.results/stats.sub-052_REML+tlrc.HEAD[Resp#1_Coef] sub-054 /data/SSCC_NARPS/globus_sync/ademo_narps/data_23_ap_task_b/sub-054/sub-054.results/stats.sub-054_REML+tlrc.HEAD[Resp#1_Coef] sub-056 /data/SSCC_NARPS/globus_sync/ademo_narps/data_23_ap_task_b/sub-056/sub-056.results/stats.sub-056_REML+tlrc.HEAD[Resp#1_Coef] sub-058 /data/SSCC_NARPS/globus_sync/ademo_narps/data_23_ap_task_b/sub-058/sub-058.results/stats.sub-058_REML+tlrc.HEAD[Resp#1_Coef] -mask group_mask.inter.nii.gz -Clustsim -seed 5
++ 3dttest++: AFNI version=AFNI_24.3.06 (Oct 31 2024) [64-bit]
++ Authored by: Zhark++
++ option -setA :: processing as LONG form (label label dset label dset ...)
++ have 21 volumes corresponding to option '-setA'
++ 206167 voxels in -mask dataset
++ Number of -Clustsim threads set to 16
++ loading -setA datasets
++ t-testing:0123456789.0123456789.0123456789.0123456789.0123456789.!
++ ---------- End of analyses -- freeing workspaces ----------
++ Creating FDR curves in output dataset
[7m*+ WARNING:[0m Smallest FDR q [1 equalRange.g_Zscr] = 0.483155 ==> few true single voxel detections
 + Added 1 FDR curve to dataset
++ Output dataset ./ttest++_result_030.resid.nii
++ ================ Starting -Clustsim calculations ================
 + === temporary files will have prefix ttest++_result_030 ===
 + === running 16 -randomsign jobs (630 iterations per job) ===
 + === creating 4,156,326,720 (4.2 billion) bytes of pseudo-data in .sdat files ===
 + --- 3dClustSim reads .sdat files to compute cluster-threshold statistics ---
 + --- there is 269,891,911,680 (270 billion) bytes of memory on your system ---
++ 3dttest++: AFNI version=AFNI_24.3.06 (Oct 31 2024) [64-bit]
++ Authored by: Zhark++
++ 206167 voxels in -mask dataset
++ option -setA :: processing as SHORT form (all values are datasets)
++ have 21 volumes corresponding to option '-setA'
++ random seeds are 5 314159270
++ opened file ./ttest++_result_030.0000.sdat for output
++ loading -setA datasets
++ t-test randomsign:0123456789.0123456789.0123456789.0123456789.0123456789.01!
++ saving main effect t-stat MIN/MAX values in ./ttest++_result_030.0000.minmax.1D
++ output short-ized file ./ttest++_result_030.0000.sdat with 206167 values for each of 630 volumes
 + ======= end of .sdat output run of 3dttest++ =======
 + 3dttest++ ===== simulation jobs have finished (247.1 s elapsed)
 + 3dttest++ ===== starting 3dClustSim A: elapsed = 252.8 s
++ 3dClustSim: AFNI version=AFNI_24.3.06 (Oct 31 2024) [64-bit]
++ Authored by: RW Cox and BD Ward
++ Loading -insdat datasets
++ -insdat had 10080 volumes = new '-niter' value
++ Startup clock time = 0.0 s
++ Using 16 OpenMP threads
Simulating:0123456789.0123456789.0123456789.0123456789.012345678!
++ Clock time now = 349.3 s
++ Command fragment to put cluster results into a dataset header;
 + (also echoed to file ttest++_result_030.CSimA.cmd for your scripting pleasure)
 + Append the name of the datasets to be patched to this command:
 3drefit -atrstring AFNI_CLUSTSIM_NN1_1sided file:ttest++_result_030.CSimA.NN1_1sided.niml -atrstring AFNI_CLUSTSIM_NN2_1sided file:ttest++_result_030.CSimA.NN2_1sided.niml -atrstring AFNI_CLUSTSIM_NN3_1sided file:ttest++_result_030.CSimA.NN3_1sided.niml -atrstring AFNI_CLUSTSIM_NN1_2sided file:ttest++_result_030.CSimA.NN1_2sided.niml -atrstring AFNI_CLUSTSIM_NN2_2sided file:ttest++_result_030.CSimA.NN2_2sided.niml -atrstring AFNI_CLUSTSIM_NN3_2sided file:ttest++_result_030.CSimA.NN3_2sided.niml -atrstring AFNI_CLUSTSIM_NN1_bisided file:ttest++_result_030.CSimA.NN1_bisided.niml -atrstring AFNI_CLUSTSIM_NN2_bisided file:ttest++_result_030.CSimA.NN2_bisided.niml -atrstring AFNI_CLUSTSIM_NN3_bisided file:ttest++_result_030.CSimA.NN3_bisided.niml 
++ 3drefit: AFNI version=AFNI_24.3.06 (Oct 31 2024) [64-bit]
++ Authored by: RW Cox
++ Processing AFNI dataset ./ttest++_result_030+tlrc.HEAD
 + atrcopy
++ applying attributes
++ 3drefit processed 1 datasets
++ 3dttest++ ----- Cleaning up intermediate files:
removed 'ttest++_result_030.resid.nii'
removed './ttest++_result_030.0000.sdat'
removed './ttest++_result_030.0001.sdat'
removed './ttest++_result_030.0002.sdat'
removed './ttest++_result_030.0003.sdat'
removed './ttest++_result_030.0004.sdat'
removed './ttest++_result_030.0005.sdat'
removed './ttest++_result_030.0006.sdat'
removed './ttest++_result_030.0007.sdat'
removed './ttest++_result_030.0008.sdat'
removed './ttest++_result_030.0009.sdat'
removed './ttest++_result_030.0010.sdat'
removed './ttest++_result_030.0011.sdat'
removed './ttest++_result_030.0012.sdat'
removed './ttest++_result_030.0013.sdat'
removed './ttest++_result_030.0014.sdat'
removed './ttest++_result_030.0015.sdat'
removed 'ttest++_result_030.CSimA.NN1_1sided.niml'
removed 'ttest++_result_030.CSimA.NN1_2sided.niml'
removed 'ttest++_result_030.CSimA.NN1_bisided.niml'
removed 'ttest++_result_030.CSimA.NN2_1sided.niml'
removed 'ttest++_result_030.CSimA.NN2_2sided.niml'
removed 'ttest++_result_030.CSimA.NN2_bisided.niml'
removed 'ttest++_result_030.CSimA.NN3_1sided.niml'
removed 'ttest++_result_030.CSimA.NN3_2sided.niml'
removed 'ttest++_result_030.CSimA.NN3_bisided.niml'
 + 3dttest++ =============== -Clustsim work is finished :) ===============
++ ----- 3dttest++ says so long, farewell, and happy trails to you :) -----
