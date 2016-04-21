clc
clear
startup;

%% 1 - Initialization
disp('1 - Load frames features.. ');

% options setup
options.save_frames = 0;
options.resize_vis = 3;
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

% 'euc' cluster centers distance variance
% 'dec' decimal values variance
options.bg_mask_type = 'euc';

exp_id='_fusion_of';
% set dataset and feats
load('variables/boxes_ped2.mat');
load('variables/W_conv5_8bit_ped2');
load('variables/itq_8_conv5_ped2');
load('variables/bg_mask_ped2.mat');

feat_dir = '../data/ucsd_conv5/UCSDped2/Test/Test007';
img_folder = '../data/ucsd/UCSDped2/Test/Test007/';
options.gt_folder='../data/ucsd/UCSDped2/gt/Test002_gt/';

%options.segments_file='../data/output/motion_feats_conv5_ped2.mat';
options.optical_flow='../data/output/motion_feats_OF_ped2.mat';
options.fusion_with_OF =1;
load(options.optical_flow, 'all_OF_map');
optical_flow = all_OF_map(7,:);

feats = merge_feats(feat_dir);
%tracklet_size =  [5 11 15 17 21];
%for trk_idx=1:length(tracklet_size)
%options.tracklet_len=tracklet_size(trk_idx);

% directories configuration
options.name_ext = [options.feat_type '_' num2str(options.bin_size) ...
    'bit_trk_' num2str(options.tracklet_len) '_th_' num2str(options.th)...
    '_W' options.W_measure_type exp_id];
out_avi = ['../data/output/vis/' options.name_ext '_ovsr.avi'];
out_hist_dir = ['../data/output/hist/' options.name_ext];
diary(['../data/output/log/' options.name_ext '_' datestr(datetime('now')) '.txt']);

%% 2 - Create motion features to visualize
disp(['2 - Extract motion features : ' options.feat_type ]);

%% var_dec_uniqe: D > delta
options.unique=1;
options.binary_based = 0;
options.shift=ceil(options.tracklet_len/2);

motion_feats = feats;
% 2 - ITQ training over features
%[ project_mat , mean_fc7 ] = binary_factory( motion_feats , boxes, options);

% 3 - Convert fc7 motion feature maps to binary feature maps
motion_feats_binary = project_feat2bin( motion_feats, project_mat, mean_fc7);
%w_matrix = calculate_w_matrix(motion_feats_binary , motion_feats , options);
%w_bs_mask = calculate_bg_subtraction(motion_feats_binary , boxes, cluster_centers, options );

w_bg_mask = w_bg_mask .* (1/max(w_bg_mask(:)));
w_bg_mask = w_bg_mask>0.3;

motion_feats_binary = compute_coappearance_measure( motion_feats_binary , optical_flow, w_matrix, w_bg_mask, boxes, options);

disp(['Features "' options.feat_type '" are extracted under : ']);
disp(options);

pres_rescore = ones(options.h,options.w);

disp('4 - Visualize heatmaps');

disp(['saved in : ' out_avi]);

[motion_feats_img, bin_val_map] = create_image_feat( motion_feats_binary, boxes, img_folder, pres_rescore, options);
visualize_heat_avi( out_avi, img_folder, motion_feats_img,bin_val_map,options);
%end
