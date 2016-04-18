clc
clear
startup;

%% 1 - Initialization
disp('1 - Initialize Optical flow Evaluation');
options.w=8;
options.h=5;
options.shift=1;
options.binary_based = 0;
load('boxes_ped2');
pres_rescore = ones(5,8);


feat_dir = '../data/ucsd_optical_flow/UCSDped2';
img_folder = '../data/ucsd/UCSDped2/Test/Test001/';
options.gt_folder='../data/ucsd/UCSDped2/gt/';
options.segments_file='../data/output/motion_feats_OF_ped2.mat';
disp(options);
dispstat('','init');

%% 2 - Compute optical flow
dispstat('2 - Compute optical flow for all videos','keepthis');
%compute_OF;
load(options.segments_file);

%% Evaluation options
dispstat('3 - Evaluation','keepthis');
UCSDped2;
options.th_roc=0;
options.itrnum = 21;
options.ClipOfFrame = options.shift;
options.threshold_pixellevel = 0.39;

disp('Create grand truth annotation');
[ImgGrandtruth,TestVideoFile_new] = Create_GT_UCSD_Frame(options,TestVideoFile);

disp('Evaluation results..');
result = SegmentResultMatrix(all_OF,TestVideoFile_new,ImgGrandtruth,options);
TP1 = TruePositiveValue(result,all_OF,options);
[TPR,FPR,Roc1] = ROCValue(TP1,all_OF,options);

close all
disp('Plot ROC');
plot(Roc1(:,2),Roc1(:,1),'-*')
grid on
xlabel('FPR'); ylabel('TPR')
title('ROC for classification by logistic regression')

