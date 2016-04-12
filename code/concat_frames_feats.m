clear ;
startup;
feat_dir = '../data/output/sp_val_alex/';
out_dir = '../data/input/sec_sp_val.mat';
fprintf('Read data files...\n');
feats = concat_feats_cell( feat_dir , 0);
fprintf(['Save data to a single file: ' out_dir '\n']);
save(out_dir, 'feats');