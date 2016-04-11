function visualize_heat_avi( out_avi, img_folder, feat_matrix, shift , resize_vis, bin_val_map)
%% Visualize heatmap on the frames. Fusion heat matrix over farmes with
% "shift" frames.
%   input:
%       - out_avi : output file address
%       - img_folder : folder contains .jpg frames
%       - feat_matrix : 3D matrix [X Y N], where [X Y] are heat matrix for 
%                       each frame, and N is totall number of heat maps.
%       - shift : to adjust beginig frame.
%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% read frame folder and initialize video writer object
dispstat('','init');
dispstat('Creating video file...','keepthis');
dirlist = dir([img_folder, '***.jpg']);
aviobj1 = VideoWriter(out_avi);
aviobj1.FrameRate = 15;
open(aviobj1);

%% fusion heatmaps and frames
for sample_no=1:size(feat_matrix,3)
    dispstat(['writing frame ' num2str(sample_no) '/' num2str(size(feat_matrix,3)) ]);
    img_org_name = [img_folder dirlist(sample_no+shift).name];
    org_img= imread(img_org_name);
    img_background= feat_matrix(:,:,sample_no);
    fusion = imfuse(img_background,org_img, 'falsecolor','Scaling','joint','ColorChannels',[2 0 1]);
    fusion = imfuse(img_background,org_img,'Scaling','independent','ColorChannels',[1 2 0]);
    %imagesc(img)
    %imagesc(fusion);
    fusion = imresize(fusion,resize_vis);
    for h_idx=1:size(bin_val_map,1)
        for w_idx=1:size(bin_val_map,2)
            position =  [(w_idx-1)*30*resize_vis (h_idx-1)*32*resize_vis+30];
            fusion = insertText(fusion,position,bin_val_map(h_idx,w_idx,sample_no),'AnchorPoint','LeftBottom');
        end
    end
    %imwrite(fusion,['../data/output/frms/' dirlist(sample_no+shift).name]);
    writeVideo(aviobj1,fusion);
    %w = waitforbuttonpress;
end
close(aviobj1);
end

