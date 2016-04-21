function feats_binary = compute_coappearance_measure_clusters( motion_feats_clusters, optical_flow, w_matrix,w_bg_mask, boxes, options )
%% Compute coappearance measure in tracklet, over decimal value of fc7.
%   lets:
%       dec = Decimal ( Binary(fc7) )
%   then:
%       compute_coappearance_measure = CoA ( dec )
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
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%

dispstat('','init');

frms = length(motion_feats_clusters);
dims= size(motion_feats_clusters{1});
n_feats = floor((frms-options.tracklet_len)/options.shift_step)+1;
tmp_m_feats=cell(n_feats,1);
start=1;


for sample_no=1:n_feats
    dispstat(['extract feature ' num2str(sample_no) '/' num2str(n_feats) '--' num2str(start)]);
    tracklet_feats = zeros(options.tracklet_len,dims(1));
    for i=1:options.tracklet_len
        tracklet_feats(i,:)=motion_feats_clusters{start+i-1};
    end
    
    measure_patchs = zeros(dims(1),1);
    for patch_idx=1:dims(1)
        patch = tracklet_feats(:,patch_idx);
        global_hist = tracklet_hist(patch);
        irr = compute_irregularity(global_hist, w_matrix);
        measure_patchs(patch_idx) = irr * w_bg_mask(boxes(patch_idx,5),boxes(patch_idx,6));
    end
    tmp_m_feats{sample_no} = measure_patchs;
    start = start + options.shift_step;
end

%% Max normalization
max_val=max(max(cellfun(@(x) max(x(:)),tmp_m_feats(:))));
tmp_m_feats = cellfun(@(x) x(:).* (1/max_val),tmp_m_feats(:),'UniformOutput',false);
feats_binary = tmp_m_feats;
for feat_idx=1:length(feats_binary)
    tmp_feat = feats_binary{feat_idx};
    %% fusion with optical flow
    if (options.fusion_with_OF)
        of_feats=optical_flow{feat_idx+options.shift-1};
        for patch_idx=1:length(tmp_feat)
            %of_value=abs(of_feats(boxes(patch_idx,5),boxes(patch_idx,6),1)-...
            %of_feats(boxes(patch_idx,5),boxes(patch_idx,6),end));
            of_value=of_feats(boxes(patch_idx,5),boxes(patch_idx,6))/2;
            tmp_feat(patch_idx) = (tmp_feat(patch_idx)/2)+of_value;
            %tmp_feat(patch_idx) = of_value;
        end
    end
    %%
    
    
    %if (norm(tmp_feat)<0.75)
    %if (sum(tmp_feat)<2.5)
    %    tmp_feat((tmp_feat>0))=0;
    %end
    
    %% one VS rest
     for bin_idx=1:length(tmp_feat)
         rest = tmp_feat;
         if (tmp_feat(bin_idx)>0)
             rest(bin_idx)=[];
             tmp_feat(bin_idx) = abs(tmp_feat(bin_idx) - mean(rest));
         end
     end
    %% -----------------------
    
    tmp_feat(tmp_feat(:)<=options.th)=0;
    feats_binary{feat_idx} = tmp_feat;
end
end

function irr = compute_irregularity(hist_vector, w_matrix)
dominant = find(hist_vector(2,:)==max(hist_vector(2,:)),1);
irr=0;
for i=1:size(hist_vector,2)
    W = w_matrix(hist_vector(1,i),hist_vector(1,dominant));
    %original
    irr = irr + W * sqrt((hist_vector(2,dominant) - hist_vector(2,i))^2);
    
    % x
    %irr = irr + sqrt((hist_vector(2,dominant) - hist_vector(2,i))^2);
    
    % W x Wham
    %W_ham = w_matrix_ham(hist_vector(1,i)+1,hist_vector(1,dominant)+1);
    %irr = irr + W*W_ham;
end
end


function hist_vector = tracklet_hist(tracklet)
bins = unique(tracklet);
hist_vector = zeros(2,length(bins));
hist_vector(1,:) = bins;
for hist_idx=1:length(bins)
    hist_vector(2,hist_idx) = sum(tracklet==bins(hist_idx));
end
end

