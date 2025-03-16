# apply any data directories with variables
set data_dir = /data/SSCC_NARPS/globus_sync/ademo_narps/data_23_ap_task_b

3dttest++                                                                                   \
   -prefix ttest++_result_030                                                               \
   -setA equalRange.gain                                                                    \
      sub-002 "$data_dir/sub-002/sub-002.results/stats.sub-002_REML+tlrc.HEAD[Resp#1_Coef]" \
      sub-004 "$data_dir/sub-004/sub-004.results/stats.sub-004_REML+tlrc.HEAD[Resp#1_Coef]" \
      sub-006 "$data_dir/sub-006/sub-006.results/stats.sub-006_REML+tlrc.HEAD[Resp#1_Coef]" \
      sub-008 "$data_dir/sub-008/sub-008.results/stats.sub-008_REML+tlrc.HEAD[Resp#1_Coef]" \
      sub-010 "$data_dir/sub-010/sub-010.results/stats.sub-010_REML+tlrc.HEAD[Resp#1_Coef]" \
      sub-014 "$data_dir/sub-014/sub-014.results/stats.sub-014_REML+tlrc.HEAD[Resp#1_Coef]" \
      sub-018 "$data_dir/sub-018/sub-018.results/stats.sub-018_REML+tlrc.HEAD[Resp#1_Coef]" \
      sub-020 "$data_dir/sub-020/sub-020.results/stats.sub-020_REML+tlrc.HEAD[Resp#1_Coef]" \
      sub-022 "$data_dir/sub-022/sub-022.results/stats.sub-022_REML+tlrc.HEAD[Resp#1_Coef]" \
      sub-024 "$data_dir/sub-024/sub-024.results/stats.sub-024_REML+tlrc.HEAD[Resp#1_Coef]" \
      sub-026 "$data_dir/sub-026/sub-026.results/stats.sub-026_REML+tlrc.HEAD[Resp#1_Coef]" \
      sub-036 "$data_dir/sub-036/sub-036.results/stats.sub-036_REML+tlrc.HEAD[Resp#1_Coef]" \
      sub-038 "$data_dir/sub-038/sub-038.results/stats.sub-038_REML+tlrc.HEAD[Resp#1_Coef]" \
      sub-040 "$data_dir/sub-040/sub-040.results/stats.sub-040_REML+tlrc.HEAD[Resp#1_Coef]" \
      sub-044 "$data_dir/sub-044/sub-044.results/stats.sub-044_REML+tlrc.HEAD[Resp#1_Coef]" \
      sub-046 "$data_dir/sub-046/sub-046.results/stats.sub-046_REML+tlrc.HEAD[Resp#1_Coef]" \
      sub-050 "$data_dir/sub-050/sub-050.results/stats.sub-050_REML+tlrc.HEAD[Resp#1_Coef]" \
      sub-052 "$data_dir/sub-052/sub-052.results/stats.sub-052_REML+tlrc.HEAD[Resp#1_Coef]" \
      sub-054 "$data_dir/sub-054/sub-054.results/stats.sub-054_REML+tlrc.HEAD[Resp#1_Coef]" \
      sub-056 "$data_dir/sub-056/sub-056.results/stats.sub-056_REML+tlrc.HEAD[Resp#1_Coef]" \
      sub-058 "$data_dir/sub-058/sub-058.results/stats.sub-058_REML+tlrc.HEAD[Resp#1_Coef]" \
   -mask group_mask.inter.nii.gz -Clustsim -seed 5

