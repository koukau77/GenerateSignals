% 生成用于验证模型的图片和标签文件
clear all % 清空工作区
num = 1000; %每个信噪比下图片的数量
for snr = 0:2:16
    save_path = ['E:\yolov5\data\images\', num2str(snr), 'dB\'];% 数据集根路径
    label_path = [save_path, 'labels\'];
    if(exist(label_path, 'dir')  ~= 7)     % 判断文件夹是否存在
       mkdir(label_path);                  % 不存在则创建文件夹
    end
    for i = 1:num
        [~, matrix, random_time] = Signals_STFT(snr); % 得到含有信号类型、f1、f2的矩阵
        saveas(gcf,[save_path, num2str(i), '.jpg']); % 保存图片
        close(); %关闭图片
        class = matrix(:,1);
        fid = fopen([label_path, [num2str(i), '.txt']], 'w'); % 创建label文本文件
        for n = 1:length(matrix(:, 1)) % length(matrix(:, 1))信号个数
            signal_class = class(n);
            if signal_class == 2 % 2FSK区别对待
                x = (matrix(n, 2) + (matrix(n, 3) - matrix(n, 2))/2)/120000;  % 中心点横坐标及中心频率
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
        disp(['信噪比为',num2str(snr),'dB下的第',num2str(i),'张']);
    end
end