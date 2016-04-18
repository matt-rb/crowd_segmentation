load('../data/output/sec1_bin.mat');
dims = size(motion_feats_binary);
h_img_size = dims(2);
w_img_size = dims(3);
bin_size = 8;

img_folder = '../data/crowd_frm/';
tp_size = 1;
dirlist = dir([img_folder, '***.jpg']);
src_image = imread([img_folder dirlist(1).name]);
%% Visualize binary maps
motion_feats_img = zeros(size(src_image,1),size(src_image,2),dims(1));
for sample_no=1:dims(1)
    result = reshape(motion_feats_binary(sample_no,:,:,:),[dims(2) dims(3) bin_size]);
    img = zeros(h_img_size,w_img_size);
    for i=1:h_img_size
        for j=1:w_img_size
            img(i,j) = bi2de( reshape(result(i,j,:),[1 bin_size]), 'left-msb');
        end
    end
    img = resize_binary_map( src_image, img );
    motion_feats_img(:,:,sample_no)=img;
end

%% Visualize binary maps

out_avi = '../data/output/out_max.avi';
shift=5;
visualize_heat_avi( out_avi, img_folder, motion_feats_img, shift );
heatAVI( img_folder, motion_feats_img, out_avi );