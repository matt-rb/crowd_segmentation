
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
options.th = 0.3;
% W_measure_type = 'euc' , 'ham' , 'dec'
options.W_measure_type = 'euc';
options.binary_based = 0;
options.shift=ceil(options.tracklet_len/2);


% set dataset and feats
load('variables/boxes_ped2.mat');
%load('variables/W_conv5_8bit_ham_ped2');
%w_matrix_ham = w_matrix;
load('variables/W_conv5_8bit_ped2');
load('variables/itq_8_conv5_ped2');
load('variables/bg_mask_ped2.mat');
feat_dir = '../data/ucsd_conv5/UCSDped2/Test';
img_folder = '../data/ucsd/UCSDped2/Test/Test001/';
options.gt_folder='../data/ucsd/UCSDped2/gt/';
options.segments_file=['../data/output/feats_conv5_th_' num2str(options.th) '_of_ovrs.mat'];
pres_rescore = ones(5,8);

% optical flow setup
options.optical_flow='../data/output/motion_feats_OF_ped2.mat';
options.fusion_with_OF =1;
load(options.optical_flow, 'all_OF_map');

disp(options);
dispstat('','init');

%% 2 - Compute coappearance measure for all videos
dispstat('2 - Compute coappearance measure for all videos','keepthis');
feat_dirlist = dir([feat_dir,'/T*']);
all_CoAp=cell(length(feat_dirlist),1);
all_bin_val_map=cell(length(feat_dirlist),1);

% background mask
w_bg_mask = w_bg_mask .* (1/max(w_bg_mask(:)));
w_bg_mask = w_bg_mask>0.3;

for video_sample_idx=1:length(feat_dirlist)

optical_flow = all_OF_map(video_sample_idx,:);
dispstat(['compute sample: ' num2str(video_sample_idx) '/' num2str(length(feat_dirlist))]);
sample_dir = [feat_dir '/' feat_dirlist(video_sample_idx).name];
feats = merge_feats(sample_dir);
motion_feats = feats;

% Convert deep feature maps to binary feature maps
motion_feats_binary = project_feat2bin( motion_feats, project_mat, mean_fc7);
motion_feats_binary = compute_coappearance_measure( motion_feats_binary ,optical_flow, w_matrix,w_bg_mask, boxes, options);
[motion_feats_img, bin_val_map] = create_image_feat( motion_feats_binary, boxes, img_folder, pres_rescore, options);

% max_val=max(motion_feats_img(:));
% motion_feats_img = motion_feats_img .* (1/max_val);
for im_idx=1:size(motion_feats_img,3)
     all_CoAp{video_sample_idx,im_idx} = motion_feats_img(:,:,im_idx);
     all_bin_val_map{video_sample_idx,im_idx} = bin_val_map(:,:,im_idx);
end
end
disp(['saving data to : ' options.segments_file]);
%options_extracted_feats=options;
save(options.segments_file, 'all_CoAp','all_bin_val_map','options');


