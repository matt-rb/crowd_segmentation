clear ;
startup;
load('../data/output/sec1.mat');
dims = size(motion_feats);
pca_size = 8;
n_iter = 100;
temp_motion_feats=reshape(motion_feats,[dims(1)*dims(2)*dims(3) dims(4)]);
[ mean_fc7,itq_rot_mat,pca_mapping ] = train_itq( pca_size, n_iter, temp_motion_feats );
save('../data/output/itq_max.mat','itq_rot_mat','pca_mapping','mean_fc7');