function feats_binary = compute_max_decbin( feats_binary, options )
%% Extract Max over decimal value of fc7 binary codes, dimensionwise.
%   Input:
%   - feats: Cell array feature maps of binary N x [WH x L]
%           N : number of frames
%           WH : Weight x Height of each frame in feature map
%           L : dimention of single feature vector (4096)
%   - shift_step: shift for overlapp
%   - tracklet_len = length of tracklets
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%
dispstat('','init');

frms = length(feats_binary);
dims= size(feats_binary{1});
n_feats = floor((frms-options.tracklet_len)/options.shift_step)+1;
tmp_m_feats=cell(n_feats,1);

start=1;
for sample_no=1:n_feats
    dispstat(['extract feature ' num2str(sample_no) '/' num2str(n_feats)]);
    tracklet_feats = zeros(dims(1),1);
    for i=1:options.tracklet_len
        tracklet_feats = max(tracklet_feats, bi2de( feats_binary{start+i-1}, 'left-msb'));
    end
    dec_val=tracklet_feats;
    tmp_m_feats{sample_no} = de2bi(dec_val, options.bin_size, 'left-msb');
    start = start + options.shift_step;
end
feats_binary = tmp_m_feats;
end

