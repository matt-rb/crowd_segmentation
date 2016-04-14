function dif_feats = compute_dif_feats( feats, cell_based )
%% Extract Avg features dimensionwise.
%   Input:
%   - feats: 4D feature maps of fc7 (N x W x H x L)
%           N : number of frames
%           W , H : weight and height of each frame in feature map
%           L : dimention of single feature vector (4096)
%           or/
%           : a cell array N x [ WH L]
%              N : number of frames
%              WH:  WeightxHeight of each frame in feature map
%              L : dimention of single feature vector (4096)
%   - cell_based : if input is a cell array = 1 , else = 0
%   - shift_step: shift for overlapp
%   - tracklet_len = length of tracklets
%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%
dispstat('','init');
dims= size(feats);
frms=dims(1);
n_feats = frms-1;
start=1;
if cell_based
    dif_feats = cell(n_feats,1);
else
    dif_feats = zeros(n_feats,dims(2),dims(3),dims(4));
end
for idx=1:n_feats
    dispstat(['extract feature ' num2str(idx) '/' num2str(n_feats)]);
    if cell_based
        dif_feats{idx}=abs(feats{idx}-feats{idx+1});
    else
        for h=1:dims(2)
            for w=1:dims(3)
                tracklet_feats=feats(start:start+1,h,w,:);
                tmp_dif_feats = abs(reshape(tracklet_feats(1,1,1,:),[1 4096])-reshape(tracklet_feats(2,1,1,:),[1 4096]));
                dif_feats(idx,h,w,:)=tmp_dif_feats;
            end
        end
        start = start + 1;
    end
end

end