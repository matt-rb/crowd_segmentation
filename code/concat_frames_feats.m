clear ;
startup;
feat_dir = '../data/crowd_feats/';
out_dir = '../data/input/sec1.mat';
fprintf('Read data files...\n');
feats = concat_feats_cell( feat_dir , 0);
fprintf(['Save data to a single file: ' out_dir '\n']);
save(out_dir, 'feats');