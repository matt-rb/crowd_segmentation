clc
clear
startup;
save_data = 0;
diary on

%% 1 - Initialization
% scripted in : "extract_motion_feats.m"
disp('1 - Load frames features.. ');
diary off

% options setup
options.resize_vis = 3;
options.cell_based= 1;
options.w=8;
options.h=5;
options.shift_step=1;
options.hex = 0;
options.bin_size = 8;
options.tracklet_len= 17;
options.feat_type = 'fc7';
options.th = 0;
options.save_frames = 1;

% variable set
feature_types = ...
    {'fc7' , 'max' , 'avg', 'dif' , 'sum' ,...
    'ham' , 'avg_decbin' , 'max_decbin' , ...
    'var_decbin' , 'var_decbin_uniqe' , ...
    'ham_change' ,'ham_change_unique' ,...
    'var_decbin_avg' , ...
    'ham_change_avg' , 'ham_change_avg_unique',...
    'ham_sum' ,'ham_sum_unique' , 'ham_sum_avg' , 'ham_sum_avg_unique',...
    'coa_m'};
tracklet_size =  [5 11 15 21];
bin_sizes = [6 8 12];

% set dataset and feats
load('boxes_ped2.mat');
feat_dir = '../data/output/feat_fc5_nomean_test002';
img_folder = '../data/crowd_frm_test002/';
feats = merge_feats(feat_dir);

%% Loop for visualize variables
%for bin_idx=1:length(bin_sizes)
%for trk_idx=1:length(tracklet_size)
%for type_idx=11:length(feature_types)
%options.bin_size = bin_sizes(bin_idx);
%options.tracklet_len=tracklet_size(trk_idx);
%options.feat_type = feature_types{type_idx};

% directories configuration
options.name_ext = [options.feat_type '_' num2str(options.bin_size) ...
    'bit_trk_' num2str(options.tracklet_len) '_th_' num2str(options.th)];
out_avi = ['../data/output/vis/' options.name_ext '.avi'];
out_hist_dir = ['../data/output/hist/' options.name_ext];
diary(['../data/output/log/' options.name_ext '_' datestr(datetime('now')) '.txt']);
diary on
%% 2 - Create motion features to visualize
disp(['2 - Extract motion features : ' options.feat_type ]);
switch options.feat_type
    case 'fc7'
        %% fc7
        % 1 - Assigne fc7 as features
        options.binary_based = 1;
        options.shift=0;
        
        motion_feats = feats;
        % 2 - ITQ training over features
        [ project_mat , mean_fc7 ] = binary_factory( motion_feats , boxes, options);
        % 3 - Convert fc7 motion feature maps to binary feature maps
        motion_feats_binary = project_feat2bin( motion_feats, project_mat, mean_fc7);
        
    case 'max'
        %% max: delta > D
        options.binary_based = 1;
        options.shift=ceil(options.tracklet_len/2);
        
        motion_feats = compute_max_feats( feats, options.shift_step, options.tracklet_len, options );
        % 2 - ITQ training over features
        [ project_mat , mean_fc7 ] = binary_factory( motion_feats , boxes, options);
        % 3 - Convert fc7 motion feature maps to binary feature maps
        motion_feats_binary = project_feat2bin( motion_feats, project_mat, mean_fc7);
        
    case 'avg'
        %% avg: delta > D
        options.binary_based = 1;
        options.shift=ceil(options.tracklet_len/2);
        
        motion_feats = compute_avg_feats( feats, options.shift_step, options.tracklet_len, options );
        % 2 - ITQ training over features
        [ project_mat , mean_fc7 ] = binary_factory( motion_feats , boxes, options);
        % 3 - Convert fc7 motion feature maps to binary feature maps
        motion_feats_binary = project_feat2bin( motion_feats, project_mat, mean_fc7);
        
    case 'dif'
        %% dif: delta > D
        options.binary_based = 1;
        options.shift=1;
        
        motion_feats = compute_dif_feats( feats , options.cell_based);
        % 2 - ITQ training over features
        [ project_mat , mean_fc7 ] = binary_factory( motion_feats , boxes, options);
        % 3 - Convert fc7 motion feature maps to binary feature maps
        motion_feats_binary = project_feat2bin( motion_feats, project_mat, mean_fc7);
        
    case 'sum'
        %% sum: delta > D
        options.binary_based = 1;
        options.shift=ceil(options.tracklet_len/2);
        
        motion_feats = compute_sum_feats( feats, options.shift_step, options.tracklet_len,options );
        % 2 - ITQ training over features
        [ project_mat , mean_fc7 ] = binary_factory( motion_feats , boxes, options);
        % 3 - Convert fc7 motion feature maps to binary feature maps
        motion_feats_binary = project_feat2bin( motion_feats, project_mat, mean_fc7);
        
    case 'ham'
        %% ham: D > delta
        options.binary_based = 1;
        options.shift=1;
        
        motion_feats = feats;
        % 2 - ITQ training over features
        [ project_mat , mean_fc7 ] = binary_factory( motion_feats , boxes, options);
        % 3 - Convert fc7 motion feature maps to binary feature maps
        motion_feats_binary = project_feat2bin( motion_feats, project_mat, mean_fc7);
        motion_feats_binary = compute_hamming( motion_feats_binary, options);
        
    case 'avg_decbin'
        %% avg_decbin: D > delta
        options.binary_based = 0;
        options.shift=ceil(options.tracklet_len/2);
        
        motion_feats = feats;
        % 2 - ITQ training over features
        [ project_mat , mean_fc7 ] = binary_factory( motion_feats , boxes, options);
        % 3 - Convert fc7 motion feature maps to binary feature maps
        motion_feats_binary = project_feat2bin( motion_feats, project_mat, mean_fc7);
        motion_feats_binary = compute_avg_decbin( motion_feats_binary, options );
        
    case 'max_decbin'
        %% max_bin: D > delta
        options.binary_based = 1;
        options.shift=ceil(options.tracklet_len/2);
        
        motion_feats = feats;
        % 2 - ITQ training over features
        [ project_mat , mean_fc7 ] = binary_factory( motion_feats , boxes, options);
        % 3 - Convert fc7 motion feature maps to binary feature maps
        motion_feats_binary = project_feat2bin( motion_feats, project_mat, mean_fc7);
        motion_feats_binary = compute_max_decbin( motion_feats_binary, options );
        
    case 'var_decbin_avg'
        %% var_decbin_avg: D > delta
        options.binary_based = 0;
        options.shift=ceil(options.tracklet_len/2);
        motion_feats = feats;
        % 2 - ITQ training over features
        [ project_mat , mean_fc7 ] = binary_factory( motion_feats , boxes, options);
        % 3 - Convert fc7 motion feature maps to binary feature maps
        motion_feats_binary = project_feat2bin( motion_feats, project_mat, mean_fc7);
        motion_feats_binary = compute_avg_var_decbin( motion_feats_binary, options );
        
        
    case 'var_decbin'
        %% var_dec: D > delta
        options.unique=0;
        options.binary_based = 0;
        options.shift=ceil(options.tracklet_len/2);
        
        motion_feats = feats;
        % 2 - ITQ training over features
        [ project_mat , mean_fc7 ] = binary_factory( motion_feats , boxes, options);
        % 3 - Convert fc7 motion feature maps to binary feature maps
        motion_feats_binary = project_feat2bin( motion_feats, project_mat, mean_fc7);
        motion_feats_binary = compute_var_dec( motion_feats_binary ,options );
        
    case 'var_decbin_uniqe'
        %% var_dec_uniqe: D > delta
        options.unique=1;
        options.binary_based = 0;
        options.shift=ceil(options.tracklet_len/2);
        
        motion_feats = feats;
        % 2 - ITQ training over features
        [ project_mat , mean_fc7 ] = binary_factory( motion_feats , boxes, options);
        % 3 - Convert fc7 motion feature maps to binary feature maps
        motion_feats_binary = project_feat2bin( motion_feats, project_mat, mean_fc7);
        motion_feats_binary = compute_var_dec( motion_feats_binary ,options);
        
    case 'ham_change'
        %% avg_bin_change: D > delta
        options.binary_based = 0;
        options.ham_avg = 0;
        options.unique = 0;
        options.shift=ceil(options.tracklet_len/2);
        
        motion_feats = feats;
        % 2 - ITQ training over features
        [ project_mat , mean_fc7 ] = binary_factory( motion_feats , boxes, options);
        % 3 - Convert fc7 motion feature maps to binary feature maps
        motion_feats_binary = project_feat2bin( motion_feats, project_mat, mean_fc7);
        motion_feats_binary = compute_ham_change( motion_feats_binary ,options );
        
    case 'ham_change_avg'
        %% ham_change_avg: D > delta
        options.binary_based = 0;
        options.ham_avg = 1;
        options.unique = 0;
        options.shift=ceil(options.tracklet_len/2);
        
        motion_feats = feats;
        % 2 - ITQ training over features
        [ project_mat , mean_fc7 ] = binary_factory( motion_feats , boxes, options);
        % 3 - Convert fc7 motion feature maps to binary feature maps
        motion_feats_binary = project_feat2bin( motion_feats, project_mat, mean_fc7);
        motion_feats_binary = compute_ham_change( motion_feats_binary ,options );
        
    case 'ham_change_unique'
        %% ham_change_unique: D > delta
        options.binary_based = 0;
        options.ham_avg = 0;
        options.unique = 1;
        options.shift=ceil(options.tracklet_len/2);
        
        motion_feats = feats;
        % 2 - ITQ training over features
        [ project_mat , mean_fc7 ] = binary_factory( motion_feats , boxes, options);
        % 3 - Convert fc7 motion feature maps to binary feature maps
        motion_feats_binary = project_feat2bin( motion_feats, project_mat, mean_fc7);
        motion_feats_binary = compute_ham_change( motion_feats_binary ,options );
        
    case 'ham_change_avg_unique'
        %% ham_change_avg_unique: D > delta
        options.binary_based = 0;
        options.ham_avg = 1;
        options.unique = 1;
        options.shift=ceil(options.tracklet_len/2);
        
        motion_feats = feats;
        % 2 - ITQ training over features
        [ project_mat , mean_fc7 ] = binary_factory( motion_feats , boxes, options);
        % 3 - Convert fc7 motion feature maps to binary feature maps
        motion_feats_binary = project_feat2bin( motion_feats, project_mat, mean_fc7);
        motion_feats_binary = compute_ham_change( motion_feats_binary ,options );
        
    case 'ham_sum'
        %% ham_sum: D > delta
        options.binary_based = 0;
        options.ham_avg = 0;
        options.unique = 0;
        options.shift=ceil(options.tracklet_len/2);
        
        motion_feats = feats;
        % 2 - ITQ training over features
        [ project_mat , mean_fc7 ] = binary_factory( motion_feats , boxes, options);
        % 3 - Convert fc7 motion feature maps to binary feature maps
        motion_feats_binary = project_feat2bin( motion_feats, project_mat, mean_fc7);
        motion_feats_binary = compute_ham_sum( motion_feats_binary ,options );
        
    case 'ham_sum_avg'
        %% ham_sum_avg: D > delta
        options.binary_based = 0;
        options.ham_avg = 1;
        options.unique = 0;
        options.shift=ceil(options.tracklet_len/2);
        
        motion_feats = feats;
        % 2 - ITQ training over features
        [ project_mat , mean_fc7 ] = binary_factory( motion_feats , boxes, options);
        % 3 - Convert fc7 motion feature maps to binary feature maps
        motion_feats_binary = project_feat2bin( motion_feats, project_mat, mean_fc7);
        motion_feats_binary = compute_ham_sum( motion_feats_binary ,options );
        
    case 'ham_sum_unique'
        %% ham_sum_unique: D > delta
        options.binary_based = 0;
        options.ham_avg = 0;
        options.unique = 1;
        options.shift=ceil(options.tracklet_len/2);
        
        motion_feats = feats;
        % 2 - ITQ training over features
        [ project_mat , mean_fc7 ] = binary_factory( motion_feats , boxes, options);
        % 3 - Convert fc7 motion feature maps to binary feature maps
        motion_feats_binary = project_feat2bin( motion_feats, project_mat, mean_fc7);
        motion_feats_binary = compute_ham_sum( motion_feats_binary ,options );
        
    case 'ham_sum_avg_unique'
        %% ham_sum_avg_unique: D > delta
        options.binary_based = 0;
        options.ham_avg = 1;
        options.unique = 1;
        options.shift=ceil(options.tracklet_len/2);
        
        motion_feats = feats;
        % 2 - ITQ training over features
        [ project_mat , mean_fc7 ] = binary_factory( motion_feats , boxes, options);
        % 3 - Convert fc7 motion feature maps to binary feature maps
        motion_feats_binary = project_feat2bin( motion_feats, project_mat, mean_fc7);
        motion_feats_binary = compute_ham_sum( motion_feats_binary ,options );
        
    case 'coa_m'
        %% var_dec_uniqe: D > delta
        options.unique=1;
        options.binary_based = 0;
        options.shift=ceil(options.tracklet_len/2);
        options.W_measure_ham = 0;
        
        motion_feats = feats;
        % 2 - ITQ training over features
        [ project_mat , mean_fc7 ] = binary_factory( motion_feats , boxes, options);
        % 3 - Convert fc7 motion feature maps to binary feature maps
        motion_feats_binary = project_feat2bin( motion_feats, project_mat, mean_fc7);
        motion_feats_binary = compute_coappearance_measure( motion_feats_binary ,options);
        
    otherwise
        disp('NO VALUE')
        options.shift=0;
        motion_feats = feats;
end

disp(['Features "' options.feat_type '" are extracted under : ']);
options

%% 3 - Visualize and save heatmap video
pres_rescore = [0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00;...
    0.60 0.60 0.60 0.60 0.60 0.60 0.60 0.60;...
    0.45 0.45 0.45 0.45 0.45 0.45 0.45 0.45;...
    0.20 0.20 0.20 0.20 0.20 0.20 0.20 0.20;...
    0.30 0.30 0.30 0.30 0.30 0.30 0.30 0.30];
pres_rescore = ones(5,8);

disp('4 - Visualize heatmaps');

disp(['saved in : ' out_avi]);
diary off
[motion_feats_img, bin_val_map] = create_image_feat( motion_feats_binary, boxes, img_folder, pres_rescore, options);
visualize_heat_avi( out_avi, img_folder, motion_feats_img,bin_val_map,options);

diary on
disp('5 - creat Hist');
disp(['saved in : ' out_hist_dir]);
diary off
%create_patch_hist( bin_val_map, motion_feats_img, out_hist_dir, options);

%end
%end
%end

