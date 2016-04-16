clear;
startup;

options.w=8;
options.h=5;
options.bin_size = 8;
options.W_measure_type = 'euc';
feat_dir = '../data/output/ucsd_conv5/UCSDped2/all';
out_file_mapping = 'itq_8_fc5_ped1.mat';
out_file_w = 'W_8bit_ped1.mat';
load ('boxes_ped2.mat');
video_list = dir([feat_dir '/T*']);
all_feats= {};
all_feat_idx=1;
for vid_idx=1:length(video_list)
    feat_list = dir([feat_dir '/' video_list(vid_idx).name '/*.mat']);
    for i=1:size(feat_list,1)
       dispstat(['Reading ' num2str(i) '/' num2str(size(feat_list,1))]);
       load([ feat_dir '/' video_list(vid_idx).name '/' feat_list(i).name])
       all_feats{all_feat_idx} = fc7;
       all_feat_idx = all_feat_idx+1;
    end
end

[ project_mat , mean_fc7 ] = binary_factory( all_feats , boxes, options);
% 3 - Convert fc7 motion feature maps to binary feature maps
motion_feats_binary = project_feat2bin( all_feats, project_mat, mean_fc7);
w_matrix = calculate_w_matrix(motion_feats_binary , all_feats , options);

save(out_file_w,'w_matrix');
save(out_file_mapping,'project_mat','mean_fc7');

