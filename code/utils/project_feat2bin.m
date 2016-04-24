function motion_feats_binary = project_feat2bin( motion_feats, project_mat, mean_fc7)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%% 3 - Convert fc7 motion feature maps to binary feature maps
% scripted in : "binary_motion_feats.m"
motion_feats_binary = cell(length(motion_feats),1);
rep_mean = repmat(mean_fc7(1,:),[size(motion_feats{1},1) 1]);
for feat_idx=1:length(motion_feats)
    data_features = motion_feats{feat_idx};
    data_features=bsxfun(@minus,rep_mean,data_features);
    data_features=bsxfun(@rdivide,data_features,sqrt(sum(data_features.^2,2)));
    c = data_features * project_mat;
    motion_feats_binary{feat_idx}=sign(max(c,0));
end
end

