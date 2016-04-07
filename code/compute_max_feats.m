function max_feats = compute_max_feats( feats, shift_step, tracklet_len )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

dims= size(feats);
frms=dims(1);
n_max_feats = floor((frms-tracklet_len)/shift_step)+1;
start=1;
max_feats = zeros(n_max_feats,dims(2),dims(3),dims(4));
for idx=1:n_max_feats
    for w=1:dims(2)
        for h=1:dims(3)
           tracklet_feats=feats(start:start+tracklet_len-1,w,h,:);
           tmp_max_feats = max(tracklet_feats,[],1);
           max_feats(idx,w,h,:)=tmp_max_feats;
        end
    end
    start = start + shift_step;
end

end

