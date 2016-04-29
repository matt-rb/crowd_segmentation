clear;
startup;

options.w=8;
options.h=5;
options.no_clusters = 128;
options.W_measure_type = 'euc';


% 'euc' cluster centers distance variance
% 'dec' decimal values variance
options.bg_mask_type = 'keuc';

options.kmeans_dir='/home/mahdyar/vlfeat/';
feat_dir = '../data/output/ucsd_conv5/UCSDped1/all';
out_file_bg_mask = 'variables/bg_mask_clusters_128_ped1.mat';
out_file_w = 'variables/W_conv5_clusters_128_ped1.mat';
load ('variables/boxes_ped1.mat');
video_list = dir([feat_dir '/T*']);
all_feats= {};
all_feat_idx=1;
for vid_idx=1:length(video_list)
    feat_list = dir([feat_dir '/' video_list(vid_idx).name '/*.mat']);
    for i=1:size(feat_list,1)
       dispstat(['Reading video ' num2str(vid_idx) '/' num2str(length(video_list))...
           ' frame ' num2str(i) '/' num2str(size(feat_list,1))]);
       load([ feat_dir '/' video_list(vid_idx).name '/' feat_list(i).name])
       all_feats{all_feat_idx} = fc7;
       all_feat_idx = all_feat_idx+1;
    end
end

[ cluster_centers , c , mean_data] = kmeans_factory( all_feats , boxes, options);
w_matrix = calculate_w_matrix_clusters(cluster_centers , options);

% 3 - Convert fc7 motion feature maps to binary feature maps
motion_feats_clusters = project_feat2clusters( all_feats , cluster_centers, mean_data);
w_bg_mask= calculate_bg_subtraction(motion_feats_clusters , boxes, cluster_centers, options);

save(out_file_w,'w_matrix','cluster_centers','mean_data');
save(out_file_bg_mask,'w_bg_mask');

