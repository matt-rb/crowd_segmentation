function dif_feats = compute_dif_feats( feats )
%% Extract Avg features dimensionwise.
%   Input:
%   - feats: 4D feature maps of fc7 (N x W x H x L)
%           N : number of frames
%           W , H : weight and height of each frame in feature map 
%           L : dimention of single feature vector (4096)
%   - shift_step: shift for overlapp
%   - tracklet_len = length of tracklets
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%
dispstat('','init');
dims= size(feats);
frms=dims(1);
n_feats = frms-1;
start=1;
dif_feats = zeros(n_feats,dims(2),dims(3),dims(4));
for idx=1:n_feats
    dispstat(['extract feature ' num2str(idx) '/' num2str(n_feats)]);
    for w=1:dims(2)
        for h=1:dims(3)
           tracklet_feats=feats(start:start+1,w,h,:);
           tmp_dif_feats = tracklet_feats(1,1,1,:)-tracklet_feats(2,1,1,:);
           dif_feats(idx,w,h,:)=tmp_dif_feats;
        end
    end
    start = start + 1;
end

end