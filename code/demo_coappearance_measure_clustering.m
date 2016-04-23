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
options.tracklet_len= 17;
options.feat_type = 'coa_m';
options.th = 0.27;
% W_measure_type = 'euc' , 'ham' , 'dec'
options.W_measure_type = 'euc';

% 'euc' cluster centers distance variance
% 'dec' decimal values variance
% 'keuc' for kmeans
options.bg_mask_type = 'keuc';
exp_id='_xwovrsof_1t2_SP';

% set dataset and feats
load('variables/boxes_ped2.mat');
load('variables/W_conv5_clusters_128_ped2');
load('variables/bg_mask_clusters_128_ped2.mat');

% directories configuration
options.name_ext = ['trk_' num2str(options.tracklet_len)...
    '_th_' num2str(options.th) exp_id];
out_avi = ['../data/output/vis/' options.name_ext '.avi'];
feat_dir = '../data/ucsd_conv5/UCSDped2/Test/Test001';
img_folder = '../data/ucsd/UCSDped2/Test/Test001/';
options.gt_folder='../data/ucsd/UCSDped2/gt/Test002_gt/';
options.optical_flow='../data/output/motion_feats_OF_ped2.mat';

load(options.optical_flow, 'all_OF_map');
options.fusion_with_OF =1;
optical_flow = all_OF_map(2,:);
feats = merge_feats(feat_dir);

%% 2 - Create motion features to visualize
disp(['2 - Extract motion features : ' options.feat_type ]);
options.unique=1;
options.binary_based = 0;
options.shift=ceil(options.tracklet_len/2);
motion_feats = feats;

% 3 - Project motion feature maps to cluster centers
motion_feats_clusters = project_feat2clusters( motion_feats, cluster_centers, mean_data);

%w_bg_mask = calculate_bg_subtraction(motion_feats_clusters , boxes, cluster_centers, options );
w_bg_mask = w_bg_mask .* (1/max(w_bg_mask(:)));
w_bg_mask = w_bg_mask>0.3;
%w_bg_mask = w_bg_mask .* (w_bg_mask>0.3);

motion_feats_clusters = compute_coappearance_measure_clusters( motion_feats_clusters ,optical_flow, w_matrix,w_bg_mask, boxes, options);

disp(['Features "' options.feat_type '" are extracted under : ']);
disp(options);



disp('4 - Visualize heatmaps');
disp(['saved in : ' out_avi]);

pres_rescore = ones(options.h,options.w);
[motion_feats_img, bin_val_map] = create_image_feat( motion_feats_clusters, boxes, img_folder, pres_rescore, options);
%motion_feats_img = apply_super_pixel(motion_feats_img, img_folder, options);
visualize_heat_avi( out_avi, img_folder, motion_feats_img,bin_val_map,options);
