clc
clear
startup;
save_data = 0;

%% 1 - Extract motion features
% scripted in : "extract_motion_feats.m"
disp('1 - Load frames features.. ');
load('../data/input/sec1.mat');
tracklet_len=5;
shift_step=1;
feat_type = 'fc7';
disp(['2 - Extract motion features : ' feat_type ]);
%feats = repmat(feats(1:2,:,:,:),100,1,1,1); 
switch feat_type
    case 'fc7'
        shift=0;
        motion_feats = feats;
    case 'max'
        shift=floor(tracklet_len/2);
        motion_feats = compute_max_feats( feats, shift_step, tracklet_len );
    case 'avg'
        shift=floor(tracklet_len/2);
        motion_feats = compute_avg_feats( feats, shift_step, tracklet_len );
    case 'dif'
        shift=1;
        motion_feats = compute_dif_feats( feats );
    case 'sum'
        shift=floor(tracklet_len/2);
        motion_feats = compute_sum_feats( feats, shift_step, tracklet_len );
    otherwise
        disp('NO VALUE')
        shift=0;
        motion_feats = feats;
end

if save_data
    disp(['saving motion features to: ../data/output/sec1_' feat_type '.mat']);
    save(['../data/output/sec1_' feat_type '.mat'],'motion_feats');
end

%% 2 - ITQ training over features
% scripted in : "train_itq_fc7.m"
disp('3 - ITQ training');
dims = size(motion_feats);
bin_size = 4;
n_iter = 100;
temp_motion_feats=reshape(motion_feats,[dims(1)*dims(2)*dims(3) dims(4)]);
[ mean_fc7,itq_rot_mat,pca_mapping ] = train_itq( bin_size, n_iter, temp_motion_feats );
if save_data
    disp(['saving ITQ matrix to: ../data/output/itq_' feat_type '.mat']);
    save(['../data/output/itq_' feat_type '.mat'],'itq_rot_mat','pca_mapping','mean_fc7');
end

%% 3 - Convert fc7 motion feature maps to binary feature maps
% scripted in : "binary_motion_feats.m"
disp('4 - Generate binary features');
dims = size(motion_feats);
h_img_size = dims(3);
w_img_size = dims(2);

project_mat = pca_mapping * itq_rot_mat;
tt = repmat(mean_fc7(1,:),[h_img_size 1]);
tt2 = repmat(tt,[w_img_size 1]);
tt2 = reshape(tt2,[w_img_size h_img_size 4096]);
motion_feats_binary = zeros(dims(1),dims(2),dims(3),bin_size);

if save_data
    disp(['save ITQ binary features to: ../data/output/sec1_bin' feat_type '.mat']);
    save(['../data/output/sec1_bin' feat_type '.mat'],'motion_feats_binary');
end

for idx=1:dims(1)
    data_features=reshape(motion_feats(idx,:,:,:),[dims(2) dims(3) dims(4)]);
    data_features=bsxfun(@minus,tt2,data_features);
    data_features=bsxfun(@rdivide,data_features,sqrt(sum(data_features.^2,2)));
    c = multiprod(project_mat', permute(data_features,[3 1 2]));
    motion_feats_binary(idx,:,:,:) = sign(max(permute(c,[2 3 1]),0));
end

%% 4 - Visualize and save heatmap video
% scripted in : "visualizaion_binary_map.m"
disp('5 - Visualize heatmaps');
out_avi = ['../data/output/out_' feat_type '.avi'];
img_folder = '../data/crowd_frm/';
%shift=0;
resize_vis=3;
dims = size(motion_feats_binary);
h_img_size = dims(2);
w_img_size = dims(3);
dirlist = dir([img_folder, '***.jpg']);
src_image = imread([img_folder dirlist(1).name]);

motion_feats_img = zeros(size(src_image,1),size(src_image,2),dims(1));
bin_val_map = zeros(dims(2), dims(3), dims(1));
for sample_no=1:dims(1)
    result = reshape(motion_feats_binary(sample_no,:,:,:),[dims(2) dims(3) bin_size]);
    img = zeros(h_img_size,w_img_size);
    for i=1:h_img_size
        for j=1:w_img_size
            img(i,j) = bi2de( reshape(result(i,j,:),[1 bin_size]), 'left-msb');
        end
    end
    img = flip(img,1);
    img = flip(img,2);
    bin_val_map(:,:,sample_no) = img;
    img = resize_binary_map( src_image, img );
    %img = flip(img,1);
    motion_feats_img(:,:,sample_no) = img;
end


visualize_heat_avi( out_avi, img_folder, motion_feats_img, shift, resize_vis,bin_val_map);
%heatAVI( img_folder, motion_feats_img, out_avi, shift);

