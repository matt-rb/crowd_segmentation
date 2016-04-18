clc
clear
startup;

load('boxes_ped2.mat');
img_name = '../data/crowd_frm_test002/001.tif';
img= imread(img_name);
for i=1:length(boxes)
    tmp = img;
    tmp(boxes(i,2):boxes(i,4),boxes(i,1):boxes(i,3))=0;
    boxes(i,:)
    imshow(tmp);
    k = waitforbuttonpress; 
end

