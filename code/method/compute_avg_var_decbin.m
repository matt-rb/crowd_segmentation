function feats_binary = compute_avg_var_decbin( feats_binary, options )
%% Compute averag on sum of distance from avg, over decimal value of fc7.
%   lets:
%       dec = Decimal ( Binary(fc7) )
%   then:
%       avg_var_decbin = mean ( sum (dec-mean(dec)) )
%------------------------------------------------------------------
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
    % compute average of decimal values throught the tracklet
    for i=1:options.tracklet_len
        tracklet_feats = tracklet_feats + bi2de( feats_binary{start+i-1}, 'left-msb');
    end
    dec_val=tracklet_feats*(1/options.tracklet_len);
    
    % sum of distances from average throught the all frames in tracklet
    sum_var = zeros(dims(1),1);
    for i=1:options.tracklet_len
        sum_var = sum_var + abs(dec_val - bi2de( feats_binary{start+i-1}, 'left-msb'));
    end
    
    % average of sum of distances
    sum_var = floor(sum_var*(1/options.tracklet_len));
    sum_var(find(sum_var<options.th))=0;
    tmp_m_feats{sample_no} = de2bi(sum_var, options.bin_size, 'left-msb');
    start = start + options.shift_step;
end
feats_binary = tmp_m_feats;
end

