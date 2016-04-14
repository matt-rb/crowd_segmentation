function feats_binary = compute_avg_decbin( feats_binary, options )
%% Extract Average over decimal value of fc7 binary codes, dimensionwise.
% !!!!!! if options.binary_based = 1 then the average will converted to 
%        integer value in a binary form
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
if options.binary_based
    dispstat('!!! AVERAGE WILL SAVED BINARY-BASED VALUE NOT EXACT DECIMAL','keepthis');
else
start=1;
for sample_no=1:n_feats
    dispstat(['extract feature ' num2str(sample_no) '/' num2str(n_feats)]);
    tracklet_feats = zeros(dims(1),1);
    for i=1:options.tracklet_len
        tracklet_feats = tracklet_feats + bi2de( feats_binary{start+i-1}, 'left-msb');
    end
    dec_val=floor(tracklet_feats*(1/options.tracklet_len));
    
    if options.binary_based
        tmp_m_feats{sample_no} = de2bi(dec_val, options.bin_size, 'left-msb');
    else
        tmp_m_feats{sample_no} = dec_val;
    end
    
    start = start + options.shift_step;
end
feats_binary = tmp_m_feats;
end

