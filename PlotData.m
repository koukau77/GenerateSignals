%% 路径
tic
clear all % 清空工作区
clc % 清空命令行
real_path = 'E:\det\'; % 真实数据的路径\
calculate_rootpath = 'E:\result\'; % 预测结果的路径
 % my_anchor_samplenum
CIOU_DIOU_NMS_5000_path = [calculate_rootpath, 'samplenum\CIOU+DIOU-NMS_5000\detect_results\']; 
CIOU_DIOU_NMS_10000_path = [calculate_rootpath, 'samplenum\CIOU+DIOU-NMS_10000\detect_results\'];
CIOU_DIOU_NMS_20000_path = [calculate_rootpath, 'samplenum\CIOU+DIOU-NMS_20000\detect_results\'];
 % my_anchor_strategy
CIOU_DIOU_NMS_20000_path = [calculate_rootpath, 'strategy\CIOU+DIOU-NMS_20000\detect_results\']; 
CIOU_IOU_NMS_20000_path = [calculate_rootpath, 'strategy\CIOU+IOU-NMS_20000\detect_results\'];
IOU_NMS_20000_path = [calculate_rootpath, 'strategy\IOU-NMS_20000\detect_results\'];

Frcnn_path = 'E:\result\frcnn\';
%% 画出不同信噪比下三个检测指标的图
% 定义接收计算好的检测参数
num = 1000; % 每种db下文本文件的数量
CIOU_DIOU_NMS_5000 = []; % 5000张数据集[dB, Pd, Pf, Eavg]
CIOU_DIOU_NMS_10000 = []; % 10000张数据集[dB, Pd, Pf, Eavg]
CIOU_DIOU_NMS_20000 = []; % 20000张数据集[dB, Pd, Pf, Eavg]
Frcnn_20000 = []; % 用frcnn训练出的结果[dB, Pd, Pf, Eavg]
%% CIOU_DIOU_NMS_5000计算参数
for dB = 0:2:16  % 遍历每个SNR下的label文件夹
    N3ME_5000 = []; % 计算完一个dB后刷新
    for i = 1:num % 遍历每个SNR下的label文件夹下的一共num（1000）个labels文本文件，包括预测和实际
        % 判断文件是否存在，存在就读取文件。yolov5如果一张图检测不到目标就不会输出txt文件。
        if(exist([[CIOU_DIOU_NMS_5000_path, num2str(dB), 'dB\labels\'],[num2str(i),'.txt']], 'file') == 2)     
            ML = PdPfEavg([[real_path, num2str(dB), 'dB\labels\'],[num2str(i),'.txt']],...
                [[CIOU_DIOU_NMS_5000_path, num2str(dB), 'dB\labels\'],[num2str(i),'.txt']]);
            % N3ME_5000 : [N, M, Mt, Mf, Eavg]
            N3ME_5000 = [N3ME_5000; ML];
        else % 不存在就记录下对应的实际信号的个数并开始下一个label文件
            real_data = load([[real_path, num2str(dB), 'dB\labels\'],[num2str(i),'.txt']]);
            N = length(real_data(:,1)); % 一张图中实际信号的个数
            N3ME_5000 = [N3ME_5000; N, 0, 0, 0, 0]; % 记录对应的实际信号的个数N并填充矩阵行数
            disp(['Yolov5,数据集5000中', [num2str(dB),'dB下第', num2str(i), '张一个都没有检测出来']])
            continue;
        end
    end
    N3ME_5000_dB(:, :, dB/2 + 1) = N3ME_5000; % 保存所有db下的结果
    N = sum(N3ME_5000(:, 1)); M = sum(N3ME_5000(:, 2));
    Mt = sum(N3ME_5000(:, 3)); Mf = sum(N3ME_5000(:, 4));
    Eavg = sum(N3ME_5000(:, 5));
%     disp([num2str(dB),'dB下实际信号数量：', num2str(N)])
%     disp([num2str(dB),'dB下检测出的信号数量：', num2str(M)])
%     disp([num2str(dB),'dB下真实信号数量：', num2str(Mt)])
%     disp([num2str(dB),'dB下虚假信号数量：', num2str(Mf)])
    Pd = Mt/N; % 检测概率
    Pf = Mf/M; % 虚警概率
    Eavg = Eavg/(4 * Mt); % 信息参数平均误差
    CIOU_DIOU_NMS_5000 = [CIOU_DIOU_NMS_5000; dB, Pd, Pf, Eavg];
end
%% CIOU_DIOU_NMS_10000计算参数
for dB = 0:2:16  % 遍历每个SNR下的label文件夹
    N3ME_10000 = [];
    for i = 1:num % 遍历每个SNR下的label文件夹下的一共num（1000）个labels文本文件，包括预测和实际
        % 判断文件是否存在，存在就读取文件。yolov5如果一张图检测不到目标就不会输出txt文件。
        if(exist([[CIOU_DIOU_NMS_10000_path, num2str(dB), 'dB\labels\'],[num2str(i),'.txt']], 'file') == 2)     
            ML = PdPfEavg([[real_path, num2str(dB), 'dB\labels\'],[num2str(i),'.txt']],...
                [[CIOU_DIOU_NMS_10000_path, num2str(dB), 'dB\labels\'],[num2str(i),'.txt']]);
            % N3ME_10000 : [N, M, Mt, Mf, Eavg]
            N3ME_10000 = [N3ME_10000; ML];
        else % 不存在就记录下对应的实际信号的个数并开始下一个label文件
            real_data = load([[real_path, num2str(dB), 'dB\labels\'],[num2str(i),'.txt']]);
            N = length(real_data(:,1)); % 一张图中实际信号的个数
            N3ME_10000 = [N3ME_10000; N, 0, 0, 0, 0];   
            disp(['Yolov5,数据集10000中', [num2str(dB),'dB下第', num2str(i), '张一个都没有检测出来']])
            continue;
        end
    end
    N3ME_10000_dB(:, :, dB/2 + 1) = N3ME_10000; % 保存所有db下的结果
    N = sum(N3ME_10000(:, 1)); M = sum(N3ME_10000(:, 2));
    Mt = sum(N3ME_10000(:, 3)); Mf = sum(N3ME_10000(:, 4));
    Eavg = sum(N3ME_10000(:, 5));
%     disp([num2str(dB),'dB下实际信号数量：', num2str(N)])
%     disp([num2str(dB),'dB下检测出的信号数量：', num2str(M)])
%     disp([num2str(dB),'dB下真实信号数量：', num2str(Mt)])
%     disp([num2str(dB),'dB下虚假信号数量：', num2str(Mf)])
    Pd = Mt/N; % 检测概率
    Pf = Mf/M; % 虚警概率
    Eavg = Eavg/(4 * Mt); % 信息参数平均误差
    CIOU_DIOU_NMS_10000 = [CIOU_DIOU_NMS_10000; dB, Pd, Pf, Eavg];
end
%% CIOU_DIOU_NMS_20000计算参数
for dB = 0:2:16  % 遍历每个SNR下的label文件夹
    N3ME_20000 = [];
    for i = 1:num % 遍历每个SNR下的label文件夹下的一共num（1000）个labels文本文件，包括预测和实际
        % 判断文件是否存在，存在就读取文件。yolov5如果一张图检测不到目标就不会输出txt文件。
        if(exist([[CIOU_DIOU_NMS_20000_path, num2str(dB), 'dB\labels\'],[num2str(i),'.txt']], 'file') == 2)     
            ML = PdPfEavg([[real_path, num2str(dB), 'dB\labels\'],[num2str(i),'.txt']],...
                [[CIOU_DIOU_NMS_20000_path, num2str(dB), 'dB\labels\'],[num2str(i),'.txt']]);
            N3ME_20000 = [N3ME_20000; ML];
        else % 不存在就记录下对应的实际信号的个数并开始下一个label文件
            real_data = load([[real_path, num2str(dB), 'dB\labels\'],[num2str(i),'.txt']]);
            N = length(real_data(:,1)); % 一张图中实际信号的个数
            N3ME_20000 = [N3ME_20000; N, 0, 0, 0, 0];
            disp(['Yolov5,数据集20000中', [num2str(dB),'dB下第', num2str(i), '张一个都没有检测出来']])
            continue;
        end
    end
    N3ME_20000_dB(:, :, dB/2 + 1) = N3ME_20000; % 保存所有db下的结果
    N = sum(N3ME_20000(:, 1)); M = sum(N3ME_20000(:, 2));
    Mt = sum(N3ME_20000(:, 3)); Mf = sum(N3ME_20000(:, 4));
    Eavg = sum(N3ME_20000(:, 5));
%     disp([num2str(dB),'dB下实际信号数量：', num2str(N)])
%     disp([num2str(dB),'dB下检测出的信号数量：', num2str(M)])
%     disp([num2str(dB),'dB下真实信号数量：', num2str(Mt)])
%     disp([num2str(dB),'dB下虚假信号数量：', num2str(Mf)])
    Pd = Mt/N; % 检测概率
    Pf = Mf/M; % 虚警概率
    Eavg = Eavg/(4 * Mt); % 信息参数平均误差
    CIOU_DIOU_NMS_20000 = [CIOU_DIOU_NMS_20000; dB, Pd, Pf, Eavg];
end
%% Frcnn计算参数
for dB = 0:2:16  % 遍历每个SNR下的label文件夹
    N3ME_Frcnn = []; % 计算完一个dB后刷新
    for i = 1:num % 遍历每个SNR下的label文件夹下的一共num（1000）个labels文本文件，包括预测和实际
        % 判断文件是否存在，存在就读取文件。yolov5如果一张图检测不到目标就不会输出txt文件。
        if(exist([[Frcnn_path, num2str(dB), 'dB\labels\'],[num2str(i),'.txt']], 'file') == 2)     
            ML = PdPfEavg([[real_path, num2str(dB), 'dB\labels\'],[num2str(i),'.txt']],...
                [[Frcnn_path, num2str(dB), 'dB\labels\'],[num2str(i),'.txt']]);
            % N3ME_5000 : [N, M, Mt, Mf, Eavg]
            N3ME_Frcnn = [N3ME_Frcnn; ML];
        else % 不存在就记录下对应的实际信号的个数并开始下一个label文件
            real_data = load([[real_path, num2str(dB), 'dB\labels\'],[num2str(i),'.txt']]);
            N = length(real_data(:,1)); % 一张图中实际信号的个数
            N3ME_Frcnn = [N3ME_Frcnn; N, 0, 0, 0, 0]; % 记录对应的实际信号的个数N并填充矩阵行数
            disp(['Frcnn,数据集20000中', [num2str(dB),'dB下第', num2str(i), '张一个都没有检测出来']])
            continue;
        end
    end
    N3ME_Frcnn_dB(:, :, dB/2 + 1) = N3ME_Frcnn; % 保存所有db下的结果
    N = sum(N3ME_Frcnn(:, 1)); M = sum(N3ME_Frcnn(:, 2));
    Mt = sum(N3ME_Frcnn(:, 3)); Mf = sum(N3ME_Frcnn(:, 4));
    Eavg = sum(N3ME_Frcnn(:, 5));
%     disp([num2str(dB),'dB下实际信号数量：', num2str(N)])
%     disp([num2str(dB),'dB下检测出的信号数量：', num2str(M)])
%     disp([num2str(dB),'dB下真实信号数量：', num2str(Mt)])
%     disp([num2str(dB),'dB下虚假信号数量：', num2str(Mf)])
    Pd = Mt/N; % 检测概率
    Pf = Mf/M; % 虚警概率
    Eavg = Eavg/(4 * Mt); % 信息参数平均误差
    Frcnn_20000 = [Frcnn_20000; dB, Pd, Pf, Eavg];
end
% CIOU_IOU_NMS_20000 = PdPfEavg(real_path, CIOU_IOU_NMS_20000_path);
% IOU_NMS_20000 = PdPfEavg(real_path, IOU_NMS_20000);
%% Plot
x_axis = 0:2:16;
% CIOU_DIOU_NMS_5000
CIOU_DIOU_NMS_5000_Pd = CIOU_DIOU_NMS_5000(:, 2);
CIOU_DIOU_NMS_5000_Pf = CIOU_DIOU_NMS_5000(:, 3);
CIOU_DIOU_NMS_5000_Eavg = CIOU_DIOU_NMS_5000(:, 4);
% CIOU_DIOU_NMS_10000
CIOU_DIOU_NMS_10000_Pd = CIOU_DIOU_NMS_10000(:, 2);
CIOU_DIOU_NMS_10000_Pf = CIOU_DIOU_NMS_10000(:, 3);
CIOU_DIOU_NMS_10000_Eavg = CIOU_DIOU_NMS_10000(:, 4);
% CIOU_DIOU_NMS_20000
CIOU_DIOU_NMS_20000_Pd = CIOU_DIOU_NMS_20000(:, 2);
CIOU_DIOU_NMS_20000_Pf = CIOU_DIOU_NMS_20000(:, 3);
CIOU_DIOU_NMS_20000_Eavg = CIOU_DIOU_NMS_20000(:, 4);
% Frcnn
Frcnn_20000_Pd = Frcnn_20000(:, 2);
Frcnn_20000_Pf = Frcnn_20000(:, 3);
Frcnn_20000_Eavg = Frcnn_20000(:, 4);

%% yolov5 不同训练数量的检测参数对比
% yolov5 Pd
figure(1) % 检测参数的图
subplot(131)
plot(x_axis, CIOU_DIOU_NMS_5000_Pd*100,'-o','MarkerIndices',1:length(x_axis));
hold on
plot(x_axis, CIOU_DIOU_NMS_10000_Pd*100, '-x','MarkerIndices',1:length(x_axis));
plot(x_axis, CIOU_DIOU_NMS_20000_Pd*100, '-*','MarkerIndices',1:length(x_axis));
set(gca,'XLim',[0 16]); % X轴的数据显示范围
set(gca, 'XTick', 0:2:16); % 设置要显示坐标刻
title('Pd');
xlabel('信噪比（dB）');
ylabel('检测概率（%）');
legend('训练时频图=5000','训练时频图=10000', '训练时频图=20000');
grid on % 加网格
% yolov5 Pf
subplot(132)
plot(x_axis, CIOU_DIOU_NMS_5000_Pf*100, '-o','MarkerIndices',1:length(x_axis));
hold on
plot(x_axis, CIOU_DIOU_NMS_10000_Pf*100, '-x','MarkerIndices',1:length(x_axis));
plot(x_axis, CIOU_DIOU_NMS_20000_Pf*100, '-*','MarkerIndices',1:length(x_axis));
set(gca,'XLim',[0 16]); % X轴的数据显示范围
set(gca, 'XTick', 0:2:16); % 设置要显示坐标刻
title('Pf');
xlabel('信噪比（dB）');
ylabel('虚警概率（%）');
legend('训练时频图=5000','训练时频图=10000', '训练时频图=20000');
grid on
% yolov5 Eavg
subplot(133)
plot(x_axis, CIOU_DIOU_NMS_5000_Eavg*100, '-o','MarkerIndices',1:length(x_axis));
hold on
plot(x_axis, CIOU_DIOU_NMS_10000_Eavg*100, '-x','MarkerIndices',1:length(x_axis));
plot(x_axis, CIOU_DIOU_NMS_20000_Eavg*100, '-*','MarkerIndices',1:length(x_axis));
set(gca,'XLim',[0 16]); % X轴的数据显示范围
set(gca, 'XTick', 0:2:16); % 设置要显示坐标刻
set(gca,'YLim',[0 8]); % Y轴的数据显示范围
title('Eavg');
xlabel('信噪比（dB）');
ylabel('参数估计平均误差（%）');
legend('训练时频图=5000','训练时频图=10000', '训练时频图=20000');
grid on
%% yolov5和Frcnn 检测参数对比
figure(2)
subplot(131) % Pd
plot(x_axis, CIOU_DIOU_NMS_20000_Pd*100, '-*','MarkerIndices',1:length(x_axis));
hold on
plot(x_axis, Frcnn_20000_Pd*100, '-x','MarkerIndices',1:length(x_axis));
set(gca,'XLim',[0 16]); % X轴的数据显示范围
set(gca, 'XTick', 0:2:16); % 设置要显示坐标刻
title('Pd');
xlabel('信噪比（dB）');
ylabel('检测概率（%）');
legend('YOLOV5', 'FRCNN');
grid on % 加网格
subplot(132) % Pf
plot(x_axis, CIOU_DIOU_NMS_20000_Pf*100, '-*','MarkerIndices',1:length(x_axis));
hold on
plot(x_axis, Frcnn_20000_Pf*100, '-x','MarkerIndices',1:length(x_axis));
set(gca,'XLim',[0 16]); % X轴的数据显示范围
set(gca, 'XTick', 0:2:16); % 设置要显示坐标刻
title('Pf');
xlabel('信噪比（dB）');
ylabel('虚警概率（%）');
legend('YOLOV5', 'FRCNN');
grid on
subplot(133) % Eavg
plot(x_axis, CIOU_DIOU_NMS_20000_Eavg*100, '-*','MarkerIndices',1:length(x_axis));
hold on
plot(x_axis, Frcnn_20000_Eavg*100, '-x','MarkerIndices',1:length(x_axis));
set(gca,'XLim',[0 16]); % X轴的数据显示范围
set(gca, 'XTick', 0:2:16); % 设置要显示坐标刻
set(gca,'YLim',[0 8]); % Y轴的数据显示范围
title('Eavg');
xlabel('信噪比（dB）');
ylabel('参数估计平均误差（%）');
legend('YOLOV5', 'FRCNN');
grid on
%% 直方分析图
figure(3)
N3ME_5000_dB_Mt = [];
N3ME_10000_dB_Mt = [];
N3ME_20000_dB_Mt = [];
% 各个数据集不同db下真实信号的个数
bar_x = 0:2:16;
% 训练集5000,10000,20000，0-16db下的真实信号
% [N, M, Mt, Mf, Eavg]
for db = 0:2:16
    N3ME_5000_dB_Mt = [N3ME_5000_dB_Mt, sum(N3ME_5000_dB(:,4,db/2 + 1))];
    N3ME_10000_dB_Mt = [N3ME_10000_dB_Mt, sum(N3ME_10000_dB(:,4,db/2 + 1))];
    N3ME_20000_dB_Mt = [N3ME_20000_dB_Mt, sum(N3ME_20000_dB(:,4,db/2 + 1))];
end
bar_y = [N3ME_5000_dB_Mt(1), N3ME_10000_dB_Mt(1), N3ME_20000_dB_Mt(1); % 0dB
         N3ME_5000_dB_Mt(2), N3ME_10000_dB_Mt(2), N3ME_20000_dB_Mt(2); % 2dB
         N3ME_5000_dB_Mt(3), N3ME_10000_dB_Mt(3), N3ME_20000_dB_Mt(3); % 4dB
         N3ME_5000_dB_Mt(4), N3ME_10000_dB_Mt(4), N3ME_20000_dB_Mt(4); % 6dB
         N3ME_5000_dB_Mt(5), N3ME_10000_dB_Mt(5), N3ME_20000_dB_Mt(5); % 8dB
         N3ME_5000_dB_Mt(6), N3ME_10000_dB_Mt(6), N3ME_20000_dB_Mt(6); % 10dB
         N3ME_5000_dB_Mt(7), N3ME_10000_dB_Mt(7), N3ME_20000_dB_Mt(7); % 12dB
         N3ME_5000_dB_Mt(8), N3ME_10000_dB_Mt(8), N3ME_20000_dB_Mt(8); % 14dB
         N3ME_5000_dB_Mt(9), N3ME_10000_dB_Mt(9), N3ME_20000_dB_Mt(9);]; % 16dB
b = bar(bar_x, bar_y, 'FaceColor', 'flat');
for k = 1:size(bar_y,2)
    b(k).CData = k;
end
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(b(1).YData);
text(xtips1,ytips1,labels1,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')
xtips2 = b(2).XEndPoints;
ytips2 = b(2).YEndPoints;
labels2 = string(b(2).YData);
text(xtips2,ytips2,labels2,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')
xtips3 = b(3).XEndPoints;
ytips3 = b(3).YEndPoints;
labels3 = string(b(3).YData);
text(xtips3,ytips3,labels3,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')
legend('5000','10000', '20000');
toc