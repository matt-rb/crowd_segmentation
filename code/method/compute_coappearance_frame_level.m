function measure_l2 = compute_coappearance_frame_level( frames_coapp )
%% Compute coappearance measure over frames (one vs rest).
%   Input:
%   - feats: Cell array feature maps of binary N x [WH x L]
%           N : number of frames
%           WH : Weight x Height of each frame in feature map
%           L : dimention of single feature vector (4096)
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%

dispstat('','init');
%frames_coapp(frames_coapp<0.15)=0;
%video_norm = sqrt(sum(abs(frames_coapp').^2,2));
one_vs_rest = 1;
[bins, frms] = size(frames_coapp);

if one_vs_rest
    measure_l2 = zeros(bins,frms);
    for sample_no=1:frms
        dispstat(['extract feature ' num2str(sample_no) '/' num2str(frms)]);
        frm = frames_coapp(:,sample_no);
        for bin_idx=1:bins
            rest = frm;
            if (frm(bin_idx)>0)
                rest(bin_idx)=[];
                measure_l2(bin_idx,sample_no) = frm(bin_idx) - mean(rest);
            end
        end
    end
    
else
    measure_l2 = zeros(frms,1);
    for sample_no=1:frms
        dispstat(['extract feature ' num2str(sample_no) '/' num2str(frms)]);
        patch = floor(frames_coapp(:,sample_no).*10);
        global_hist = tracklet_hist(nonzeros(patch));
        irr = compute_irregularity(global_hist);
        measure_l2(sample_no) = irr;
    end
end
%measure_l2 = measure_l2 .* video_norm;

%% Max normalization
max_val=max(measure_l2(:));
measure_l2 = measure_l2 .* (1/max_val);
%feats_binary = tmp_m_feats;
end

function irr = compute_irregularity(hist_vector)
dominant = find(hist_vector(2,:)==max(hist_vector(2,:)),1);
irr=0;
for i=1:size(hist_vector,2)
    irr = irr + sqrt((hist_vector(2,dominant) - hist_vector(2,i))^2);
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

