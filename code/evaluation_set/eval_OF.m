clc
clear
startup;

%% 1 - Initialization
disp('1 - Initialize Optical flow Evaluation');
options.w=8;
options.h=5;
options.shift=1;
options.binary_based = 0;
load('variables/boxes_ped2');
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
options.itrnum = 10;
options.ClipOfFrame = options.shift;
options.threshold_pixellevel = 0.39;

disp('Create grand truth annotation');
%[ImgGrandtruth,TestVideoFile_new] = Create_GT_UCSD_Frame(options,TestVideoFile);
load('variables/gt_ped2.mat','ImgGrandtruth','TestVideoFile_new');
RoCs=cell(12,1);

for i=1:12
start=i;
end_vid=i;
disp(['Evaluation results ' num2str(i)]);
result = SegmentResultMatrix(all_OF(start:end_vid,:),TestVideoFile_new(start:end_vid),ImgGrandtruth(start:end_vid,:),options);
TP1 = TruePositiveValue(result,all_OF(start:end_vid,:),options);
[TPR,FPR,Roc1] = ROCValue(TP1,all_OF(start:end_vid,:),options);

close all
disp(sprintf('Plot %.3d', i));
plot(Roc1(:,2),Roc1(:,1),'-*')
hold on
plot([0 1] ,[1 0],'red')
grid on
xlabel('FPR'); ylabel('TPR')
title(['ROC for classification/ ' strrep(options.segments_file(29:end-4), '_', ' ')])
file_name=['eval_results/new/' sprintf('%.3d', i) '_of.png'];
print(file_name,'-dpng');
%w = waitforbuttonpress;
RoCs{i}=Roc1;
end
save('evaluation_set/RoC_of.mat','RoCs');
%save('evaluation_set/RoC_of_overall.mat','Roc1');