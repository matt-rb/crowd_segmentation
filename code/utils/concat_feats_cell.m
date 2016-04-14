function [ feats ] = concat_feats_cell( feat_dir,cell_based )
%% Merge several feat file to unique
%   input:
%       feat_dir : string - direcory of feat files
%   output:
%       feats : merged feat file
%%
    if ~exist('cell_based','var')
        cell_based =1;
    end
        
    dispstat('','init');
    dispstat('Merging feat files...','keepthis');
    feat_list = dir([feat_dir '/*.mat']);
    if cell_based
        feats = cell(size(feat_list,1),1);
    else
        load([ feat_dir '/' feat_list(1).name]);
        dims= size(x);
        feats = zeros(size(feat_list,1),dims(2),dims(3),dims(1));
    end
    for i=1:size(feat_list,1)
        if ~feat_list(i).isdir
            dispstat(['Reading ' num2str(i) '/' num2str(size(feat_list,1))]);
            load([ feat_dir '/' feat_list(i).name])
            if cell_based
                feats{i-2} = permute(x, [2 3 1]);
            else
                feats(i,:,:,:) = permute(x, [2 3 1]);
            end
        end
    end
end