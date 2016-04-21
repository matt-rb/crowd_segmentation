function motion_feats_clusters = project_feat2clusters( motion_feats, cluster_centers, mean_data)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%% 3 - Project fc7 feature to clusters
motion_feats_clusters = cell(length(motion_feats),1);
rep_mean = repmat(mean_data(1,:),[size(motion_feats{1},1) 1]);
for feat_idx=1:length(motion_feats)
    data_features = motion_feats{feat_idx};
    data_features=bsxfun(@minus,rep_mean,data_features);
    data_features=bsxfun(@rdivide,data_features,sqrt(sum(data_features.^2,2)));
    data_features=double(data_features)';
    dw = slmetric_pw(data_features,cluster_centers, 'eucdist' );
    [~,idw] = min(dw');
    motion_feats_clusters{feat_idx}=idw';
end
end

