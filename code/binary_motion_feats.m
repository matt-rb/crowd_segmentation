clear ;
startup;
load('../data/output/sec1.mat');
dims = size(motion_feats);
h_img_size = dims(3);
w_img_size = dims(2);
bin_size = 8;

%% Convert motion feature maps to binary feature maps
load('../data/output/itq_max.mat');
project_mat = pca_mapping * itq_rot_mat;
tt = repmat(mean_fc7(1,:),[h_img_size 1]);

tt2 = repmat(tt,[w_img_size 1]);
tt2 = reshape(tt2,[w_img_size h_img_size 4096]);
%tt2 = permute(tt2,[3 2 1]);



motion_feats_binary = zeros(dims(1),dims(2),dims(3),bin_size);

for idx=1:dims(1)
    data_features=reshape(motion_feats(idx,:,:,:),[dims(2) dims(3) dims(4)]);
    data_features=bsxfun(@minus,tt2,data_features);
    data_features=bsxfun(@rdivide,data_features,sqrt(sum(data_features.^2,2)));
    c = multiprod(project_mat', permute(data_features,[3 1 2]));
    motion_feats_binary(idx,:,:,:) = sign(max(permute(c,[2 3 1]),0));
end


save('../data/output/sec1_bin.mat','motion_feats_binary');

visulizaion_binary_map;