function [ project_mat , mean_fc7 ] = binary_factory( motion_feats , boxes, options)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% 2 - ITQ training over features
% scripted in : "train_itq_fc7.m"
disp('3 - ITQ training');
n_iter = 300;
temp_motion_feats = zeros(length(motion_feats)*length(boxes), 4096);
for feat_idx=1:length(motion_feats)
    temp_motion_feats((feat_idx-1)*length(boxes)+1:feat_idx*length(boxes),:)=motion_feats{feat_idx};
end
[ mean_fc7,itq_rot_mat,pca_mapping ] = train_itq( options.bin_size, n_iter, temp_motion_feats );
project_mat = pca_mapping * itq_rot_mat;
end

