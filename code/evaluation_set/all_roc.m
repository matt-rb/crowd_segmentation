load('evaluation_set/RoC_wxwham');
RoC_wxwham = RoCs;
load('evaluation_set/RoC_of');
RoC_of = RoCs;
load('evaluation_set/RoC_w');
RoC_w = RoCs;
load('evaluation_set/RoC_wham');
RoC_wham = RoCs;
load('evaluation_set/RoC_x');
RoC_x = RoCs;

for i=1:12

close all
disp('Plot ROC');
plot(RoC_wxwham{i}(:,2),RoC_wxwham{i}(:,1),'-*')
hold on
plot(RoC_of{i}(:,2),RoC_of{i}(:,1),'-*')
plot(RoC_w{i}(:,2),RoC_w{i}(:,1),'-*')
plot(RoC_wham{i}(:,2),RoC_wham{i}(:,1),'-*')
plot(RoC_x{i}(:,2),RoC_x{i}(:,1),'-*')
plot([0 1] ,[1 0],'red')
grid on
xlabel('FPR'); ylabel('TPR')
title(['ROC for classification / video : ' num2str(i)])
legend('WxWham','OF','W','Wham','X')
file_name=['eval_results/ped2_per_video/ALL-' sprintf('%.3d', i) '.png'];
print(file_name,'-dpng');
close all
%w = waitforbuttonpress;
end
