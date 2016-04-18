
clc
clear
startup;

%% 1 - Initialization
disp('1 - Initialization with');
% general options setup
options.save_frames = 0;
options.resize_vis = 3;

% feature extraction options
options.cell_based= 1;
options.w=8;
options.h=5;
options.shift_step=1;
options.hex = 0;
options.bin_size = 8;
options.tracklet_len= 17;
options.feat_type = 'coa_m';
options.th = 0;
% W_measure_type = 'euc' , 'ham' , 'dec'
options.W_measure_type = 'euc';
options.binary_based = 0;
options.shift=ceil(options.tracklet_len/2);


% set dataset and feats
load('boxes_ped2.mat');
load('W_conv5_8bit_ped2');
load('itq_8_conv5_ped2');
feat_dir = '../data/ucsd_conv5/UCSDped2/Test';
img_folder = '../data/ucsd/UCSDped2/Test/Test001/';
options.gt_folder='../data/ucsd/UCSDped2/gt/';
options.segments_file=['../data/output/motion_feats_conv5_th_' num2str(options.th) '_ped2.mat'];
pres_rescore = ones(5,8);

disp(options);
dispstat('','init');

%% 2 - Compute coappearance measure for all videos
dispstat('2 - Compute coappearance measure for all videos','keepthis');
feat_dirlist = dir([feat_dir,'/T*']);
all_CoAp=cell(length(feat_dirlist),1);

for video_sample_idx=1:length(feat_dirlist)

dispstat(['compute sample: ' num2str(video_sample_idx) '/' num2str(length(feat_dirlist))]);
sample_dir = [feat_dir '/' feat_dirlist(video_sample_idx).name];
feats = merge_feats(sample_dir);
motion_feats = feats;

% Convert deep feature maps to binary feature maps
motion_feats_binary = project_feat2bin( motion_feats, project_mat, mean_fc7);
motion_feats_binary = compute_coappearance_measure( motion_feats_binary , w_matrix, options);
[motion_feats_img, bin_val_map] = create_image_feat( motion_feats_binary, boxes, img_folder, pres_rescore, options);

max_val=max(motion_feats_img(:));
motion_feats_img = motion_feats_img .* (1/max_val);
for im_idx=1:size(motion_feats_img,3)
    all_CoAp{video_sample_idx,im_idx} = motion_feats_img(:,:,im_idx);
end
end
save(options.segments_file, 'all_CoAp','options');


