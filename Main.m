%% 参数,路径初始化
clear all % 清空工作区
root_path = 'E:\datasets\8-16dB';% 数据集根路径
train_label_path = [root_path, '\train\labels\'];% 训练集label文本保存路径
if(exist(train_label_path, 'dir')  ~= 7)     % 判断文件夹是否存在
   mkdir(train_label_path);                  % 不存在则创建文件夹
end
train_im_path = [root_path, '\train\images\'];% 训练集label文本保存路径
if(exist(train_im_path, 'dir')  ~= 7)     % 判断文件夹是否存在
   mkdir(train_im_path);                  % 不存在则创建文件夹
end
val_label_path = [root_path, '\valid\labels\'];% 验证集label文本保存路径
if(exist(val_label_path, 'dir')  ~= 7)     % 判断文件夹是否存在
   mkdir(val_label_path);                  % 不存在则创建文件夹
end
val_im_path = [root_path, '\valid\images\'];% 验证集label文本保存路径
if(exist(val_im_path, 'dir')  ~= 7)     % 判断文件夹是否存在
   mkdir(val_im_path);                  % 不存在则创建文件夹
end
im_all_num = 1000; %所有图片的数量
im_train_num = 0.8 * im_all_num;%训练集图片的数量
im_val_num = 0.2 * im_all_num;%验证集所有图片的数量
snr = randi([8, 16]); % 设置随机信噪比
%%
% 准备训练数据集，验证数据集
% 计算yolo格式的label参数
for i = 1:im_all_num  
%   图片尺寸:[875,656]
%   横坐标是频率，0-120khz；纵坐标是时间0-1s
%   box  中心坐标(x,y)  宽度 w  高度 h
    disp(['第',num2str(i),'张']);
    if i <= im_train_num % 保存路径为训练集的路径
        im_save_path = train_im_path;
        label_save_path = train_label_path;
    else   % 保存路径为验证集的路径
        im_save_path = val_im_path;
        label_save_path = val_label_path;
    end
    [~, matrix, random_time] = Signals_STFT(snr); % 得到含有信号类型、f1、f2的矩阵
    saveas(gcf,[im_save_path, num2str(i), '.jpg']); % 保存图片
    close(); %关闭图片
    class = matrix(:,1);
    fid = fopen([label_save_path, [num2str(i), '.txt']], 'w'); % 创建label文本文件
    for n = 1:length(matrix(:, 1)) % length(matrix(:, 1))信号个数
        signal_class = class(n);
        if signal_class == 2 % 2FSK区别对待
            x = (matrix(n, 2) + (matrix(n, 3) - matrix(n, 2))/2)/120000;  % 中心点横坐标
            y = random_time(n, 1); % 中心点纵坐标及中心时刻位置
            w = (matrix(n, 3)-matrix(n, 2))/120000 + 14/875;   % 宽度 为了画出的框可以包含信号而增加像素点
            h = random_time(n, 2);  % 高度及信号时长
        elseif signal_class == 3 % 2PSK区别对待
            x = matrix(n, 3)/120000;  % 中心点横坐标及中心频率
            y = random_time(n, 1); % 中心点纵坐标及中心时刻位置
            w = 14/875;   % 宽度 为了画出的框可以包含信号而增加像素点
            h = random_time(n, 2);  % 高度及信号时长   
        elseif signal_class == 1 % FM区别对待
            x = matrix(n, 3)/120000;  % 中心点横坐标及中心频率
            y = random_time(n, 1); % 中心点纵坐标及中心时刻位置
            % 基带信号频率：500  调制指数 5 
            w = 2 * (5+1) * 500/120000 + 14/875;   % 宽度 为了画出的框可以包含信号而增加像素点
            h = random_time(n, 2);  % 高度及信号时长   
        else  % AM和DSB
            x = matrix(n, 3)/120000;  % 中心点横坐标及中心频率
            y = random_time(n, 1); % 中心点纵坐标及中心时刻位置
            w = 2 * matrix(n, 2) / 120000 + 14/875;   % 宽度及带宽 为了画出的框可以包含信号而增加像素点
            h = random_time(n, 2);  % 高度及信号时长
        end
        signal_class = num2str(signal_class); 
        x = num2str(x);
        y = num2str(y);
        w = num2str(w); 
        h = num2str(h); 
        % ascii码 空格32 回车13
        label = strcat(signal_class, 32, x, 32, y, 32, w, 32, h, 13);
        for jj = 1:length(label)
            fprintf(fid, '%s', label(jj));   
        end 
    end
    fclose(fid);
end