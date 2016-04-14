function feats_binary = compute_hamming( feats_binary, options )
%% Hamming distance between two consequtive binary codes along tracklet.
%   Input:
%   - feats: Cell array feature maps of binary N x [WH x L]
%           N : number of frames
%           WH : Weight x Height of each frame in feature map
%           L : dimention of single feature vector (4096)
%   - options.hex=1 : if input features are the hex value of binary codes.
%   - tracklet_len = length of tracklets
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%
tmp_m_feats=cell(length(feats_binary)-1,1);
        if options.hex
            for sample_no=1:length(tmp_m_feats)
                val1 = bi2de( feats_binary{sample_no}, 'left-msb');
                val2 = bi2de( feats_binary{sample_no+1}, 'left-msb');
                tmp_m_feats{sample_no} = de2bi(abs(val1-val2), options.bin_size, 'left-msb');
            end
        else
            for sample_no=1:size(feats_binary,1)-1
                val1= feats_binary{sample_no};
                val2 = feats_binary{sample_no+1};
                tmpval = zeros(length(val1),options.bin_size);
                for s_idx=1:length(val1)
                    ham = pdist([val1(s_idx,:) ; val2(s_idx,:)], 'minkowski',1);
                    tmpval(s_idx,:) = de2bi(ham, options.bin_size, 'left-msb');
                end
                tmp_m_feats{sample_no} = tmpval;
            end
        end
        feats_binary = tmp_m_feats;
end

