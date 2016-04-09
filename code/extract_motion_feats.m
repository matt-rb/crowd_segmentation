
clear ;
startup;
load('../data/input/sec1.mat');
tracklet_len=11;
shift_step=1;
%motion_feats = compute_max_feats( feats, shift_step, tracklet_len );
motion_feats = compute_avg_feats( feats, shift_step, tracklet_len );
save('../data/output/sec1.mat','motion_feats');