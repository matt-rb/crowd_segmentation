function feats_binary = compute_ham_sum( feats_binary, options )
%% Compute sum hamming distances along a tracklet.
%   Input:
%   - feats: Cell array feature maps of binary N x [WH x L]
%           N : number of frames
%           WH : Weight x Height of each frame in feature map
%           L : dimention of single feature vector (4096)
%   - shift_step: shift for overlapp
%   - tracklet_len = length of tracklets
%-----------------------------------------------------------
%   options.unique = 1 : unique values in the tracklet
%   options.ham_avg = 1 : compute average instead of sum
%   options.binary_based = 1 : output features will convert to binary codes
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%
dispstat('','init');

frms = length(feats_binary);
dims= size(feats_binary{1});
n_feats = floor((frms-options.tracklet_len)/options.shift_step)+1;
tmp_m_feats=cell(n_feats,1);
start=1;

for sample_no=1:n_feats
    dispstat(['extract feature ' num2str(sample_no) '/' num2str(n_feats)]);
    sum_var = zeros(dims(1),1);
    history = ones(dims(1),options.tracklet_len)*(-1);
    for i=1:options.tracklet_len-1
        val1= feats_binary{start+i-1};
        val2 = feats_binary{start+i};
        for s_idx=1:length(val1)
            ham = pdist([val1(s_idx,:) ; val2(s_idx,:)], 'minkowski',1);
            if options.unique
                history(i,s_idx) = bi2de(val1(s_idx,:), 'left-msb');
                % how much change
                if ham>0 && isempty(find(history(:,s_idx)==bi2de(val2(s_idx,:), 'left-msb'), 1))
                    sum_var(s_idx) = sum_var(s_idx) + ham;
                end
            else
                if ham>0
                    sum_var(s_idx) = sum_var(s_idx) + ham;
                end
            end
        end
    end
    
    if options.ham_avg
        sum_var = sum_var*(1/options.tracklet_len);
    end
    %sum_var = sum_var.*pres_rescore;
    sum_var(find(sum_var<options.th))=0;
    if options.binary_based
        sum_var = ceil(sum_var);
        tmp_m_feats{sample_no} = de2bi(sum_var, options.bin_size, 'left-msb');
    else
        tmp_m_feats{sample_no} = sum_var;
    end
    start = start + options.shift_step;
end
feats_binary = tmp_m_feats;
end

