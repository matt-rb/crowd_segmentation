function sum_feats = compute_sum_feats( feats, shift_step, tracklet_len, options )
%% Extract Sum features dimensionwise.
%   Input:
%   - feats: 4D feature maps of fc7 (N x W x H x L)
%           N : number of frames
%           W , H : weight and height of each frame in feature map
%           L : dimention of single feature vector (4096)
%   - shift_step: shift for overlapp
%   - tracklet_len = length of tracklets
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%
dispstat('','init');
if options.cell_based
    frms = length(feats);
    dims= size(feats{1});
else
    dims= size(feats);
    frms=dims(1);
end
n_feats = floor((frms-tracklet_len)/shift_step)+1;
%% extract motion features
if options.cell_based
    start=1;
    sum_feats = cell(n_feats,1);
    for idx=1:n_feats
        dispstat(['extract feature ' num2str(idx) '/' num2str(n_feats)]);
        tracklet_feats = zeros(dims(1),dims(2));
        for i=1:tracklet_len
            tracklet_feats = tracklet_feats + feats{start+i-1};
        end
        sum_feats{idx}=tracklet_feats;
        start = start + shift_step;
    end
else
    start=1;
    sum_feats = zeros(n_feats,dims(2),dims(3),dims(4));
    for idx=1:n_feats
        dispstat(['extract feature ' num2str(idx) '/' num2str(n_feats)]);
        for w=1:dims(2)
            for h=1:dims(3)
                tracklet_feats=feats(start:start+tracklet_len-1,w,h,:);
                tmp_sum_feats = sum(tracklet_feats,1);
                sum_feats(idx,w,h,:)=tmp_sum_feats;
            end
        end
        start = start + shift_step;
    end
end
end