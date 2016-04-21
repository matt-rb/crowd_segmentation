function [ idx , C ] = kmeans_factory( motion_feats , boxes, options)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% 2 - ITQ training over features
disp('3 - clustring kmeans');
temp_motion_feats = zeros(length(motion_feats)*length(boxes), size(motion_feats{1},2));
for feat_idx=1:length(motion_feats)
    temp_motion_feats((feat_idx-1)*length(boxes)+1:feat_idx*length(boxes),:)=motion_feats{feat_idx};
end

[idx,C] = kmeans(motion_feats,options.no_clusters,'MaxIter',10000,'Display','final','Replicates',10);
end

