org_img = imread('../data/crowd_frm/001.jpg');
idx=1;
for h_idx=1:5
    for w_idx=1:8
        img = org_img;
        start_h_idx = (h_idx-1)*30+1;
        end_h_idx = min(h_idx*30,158);
        start_w_idx = (w_idx-1)*30+1;
        end_w_idx = min(w_idx*30,238); 
        img (start_h_idx:end_h_idx,start_w_idx:end_w_idx)=0;
        imwrite(img,['patch_h_' num2str(h_idx) '_w_' num2str(w_idx) '.jpg']);
    end
end