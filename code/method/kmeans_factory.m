function [ C , A ] = kmeans_factory( motion_feats , boxes, options)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% 2 - ITQ training over features
disp('3 - clustring kmeans');
run('/home/mahdyar/vlfeat/toolbox/vl_setup')
temp_motion_feats = zeros(length(motion_feats)*length(boxes), size(motion_feats{1},2));
for feat_idx=1:length(motion_feats)
    temp_motion_feats((feat_idx-1)*length(boxes)+1:feat_idx*length(boxes),:)=motion_feats{feat_idx};
end

[C,A] = vl_kmeans(temp_motion_feats',options.no_clusters,'distance','l2','algorithm','ann');
%[idx,C] = kmeans(temp_motion_feats,options.no_clusters,'MaxIter',100,'Display','final','Replicates',5);
end

