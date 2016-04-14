function feats = merge_feats( feat_dir )
%% Merge several feat file to unique
%   input:
%       feat_dir : string - direcory of feat files
%   output:
%       feats : merged feat file
%%        
    dispstat('','init');
    dispstat('Merging feat files...','keepthis');
    feat_list = dir([feat_dir '/*.mat']);
    feats = cell(size(feat_list,1),1);
    for i=1:size(feat_list,1)
       dispstat(['Reading ' num2str(i) '/' num2str(size(feat_list,1))]);
       load([ feat_dir '/' feat_list(i).name])
       feats{i} = fc7;
    end
end