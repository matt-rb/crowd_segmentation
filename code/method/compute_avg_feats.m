function avg_feats = compute_avg_feats( feats, shift_step, tracklet_len )
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
n_feats = floor((frms-tracklet_len)/shift_step)+1;
start=1;
avg_feats = zeros(n_feats,dims(2),dims(3),dims(4));
for idx=1:n_feats
    dispstat(['extract feature ' num2str(idx) '/' num2str(n_feats)]);
    for w=1:dims(2)
        for h=1:dims(3)
           tracklet_feats=feats(start:start+tracklet_len-1,w,h,:);
           tmp_avg_feats = mean(tracklet_feats,1);
           avg_feats(idx,w,h,:)=tmp_avg_feats;
        end
    end
    start = start + shift_step;
end

end