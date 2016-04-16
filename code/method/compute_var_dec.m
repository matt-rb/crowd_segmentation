function feats_binary = compute_var_dec( feats_binary, options )
%% Compute variance in tracklet, over decimal value of fc7.
%   lets:
%       dec = Decimal ( Binary(fc7) )
%   then:
%       compute_var_dec = var ( dec )
%   and for options.unique = 1:
%       compute_var_dec = var ( unique(dec) )
%------------------------------------------------------------------
%   Input:
%   - feats: Cell array feature maps of binary N x [WH x L]
%           N : number of frames
%           WH : Weight x Height of each frame in feature map
%           L : dimention of single feature vector (4096)
%   - shift_step: shift for overlapp
%   - tracklet_len = length of tracklets
%   - options.unique = 1 : disregard frequented values in tracklet
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%

dispstat('','init');

frms = length(feats_binary);
dims= size(feats_binary{1});
n_feats = floor((frms-options.tracklet_len)/options.shift_step)+1;
tmp_m_feats=cell(n_feats,1);
start=1;

for sample_no=1:n_feats
    dispstat(['extract feature ' num2str(sample_no) '/' num2str(n_feats)]);
    tracklet_feats = zeros(options.tracklet_len,dims(1));
    for i=1:options.tracklet_len
        tracklet_feats(i,:)=bi2de( feats_binary{start+i-1}, 'left-msb');
    end
    
    var_patchs = zeros(dims(1),1);
    for patch_idx=1:dims(1)
        if options.unique
            unique_bins=unique(tracklet_feats(:,patch_idx));
            var_patchs(patch_idx) = var(unique_bins);
        else
            var_patchs(patch_idx) = var(tracklet_feats(:,patch_idx));
        end
    end
    var_patchs(find(var_patchs<options.th))=0;
    tmp_m_feats{sample_no} = var_patchs;
    start = start + options.shift_step;
end
feats_binary = tmp_m_feats;
end

