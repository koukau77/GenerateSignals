% 生成用于验证模型的图片和标签文件
clear all % 清空工作区
num = 1000; %每个信噪比下图片的数量
for i = 1:num
    %% stft参数设置
    wlen = 1024;% 设置窗口长度
    window = hamming(wlen);% 设置海明窗的窗长
    hop = 1;% 每次平移的步长
    noverlap = wlen - hop; % 重叠长度
%     f = 0:117.1875:120000;% 设置频率刻度hz,出图很慢,不用
    nfft = 2^nextpow2(length(window)); % nfft点数
    fs = 240000;    % 采样频率 频率坐标轴为采样频率的一半
    %% 信号参数设置
    dt = 1/fs;    % 时间精度
    times_tart = 0; % 开始时间
    time_end = 1;   % 结束时间
    t = times_tart:dt:time_end - dt; % 设置时间坐标轴起止时间
    signals_matrix = []; % 用来整合信号类型和频率的矩阵 格式为 class f1 f2
    random_time = []; % 用来整合信号中心时刻和时长的矩阵 格式为 时长 中心时刻
    x_signal = 0; % 整合完毕的信号
    class = [0, 1, 2, 3]; % 设置信号种类(从0开始同python)
                          % 0 AM 1 FM 2 2FSK 3 2PSK 4 DSB
    signals_num = randi([2, 8]); % 每张图信号的数量：2～8随机
    for ii = 1:signals_num
        random_time(ii, 2) = unifrnd(0.1, 1.0); % 信号时长0.2-1s随机
        random_time(ii, 1) = unifrnd(random_time(ii, 2)/2,...
            1 - random_time(ii, 2)/2); % 信号中心时刻在保证信号在图内的前提下在随机
    end
    %% 整合信号
    for nnum = 1:signals_num % 每张图一共signals_num个信号
        % 随机抽选class中的一个信号种类
        signal_class = class(randi([1, length(class)]));
        % 创建信号
        [x, f1, f2] = CreateSignal(signal_class, t);
        % 将创建的signals_num个信号放入信号矩阵中
        signals_matrix = [signals_matrix; signal_class, f1, f2];
        % signals_matrix尺寸为 signals_num * 3
        x_signal = x_signal + x.*(t > (random_time(nnum, 1) - random_time(nnum, 2)/2) ...
        & t < (random_time(nnum, 1) + random_time(nnum, 2)/2));
    end
    x_signal = x_signal .* Z_Rayleigh(8,100,t); % 经过瑞利衰落信道
    x_signal = real(x_signal); % 取实部
    for snr = 0:2:16
        x_signal = awgn(x_signal, 16-snr); % 加入高斯白噪声
        save_path = ['E:\yolov5\data\images\', num2str(16-snr), 'dB\'];% 数据集根路径
        label_path = [save_path, 'labels\'];
        if(exist(label_path, 'dir')  ~= 7)     % 判断文件夹是否存在
           mkdir(label_path);                  % 不存在则创建文件夹
        end
        %% 短时傅里叶 sftf并画图
%         gx_signal = gpuArray(x_signal);
        [s, f, t2] = spectrogram(x_signal, window, noverlap, nfft, fs);
        k = 2/(fs*(window'*window));
        imagesc(f, t2,10*log10(abs(s).*abs(s)*k)');
        set(gca,'looseInset', [0 0 0 0]);% 消除图像的白边
        set(gca, 'xtick', [], 'ytick',[],  'xcolor', 'w', 'ycolor', 'w')% 去掉坐标轴
        colorbar('off'); % 去掉图像右边的色块
        saveas(gcf,[save_path, num2str(i), '.jpg']); % 保存图片
        close(); %关闭图片
        class = signals_matrix(:,1);
        fid = fopen([label_path, [num2str(i), '.txt']], 'w'); % 创建label文本文件
        for n = 1:length(signals_matrix(:, 1)) % length(matrix(:, 1))信号个数
            signal_class = class(n);
            if signal_class == 2 % 2FSK区别对待
                x = (signals_matrix(n, 2) + (signals_matrix(n, 3) - signals_matrix(n, 2))/2)/120000;  % 中心点横坐标及中心频率
                y = random_time(n, 1); % 中心点纵坐标及中心时刻位置
                w = (signals_matrix(n, 3)-signals_matrix(n, 2))/120000 + 14/875;   % 宽度 为了画出的框可以包含信号而增加像素点
                h = random_time(n, 2);  % 高度及信号时长
            elseif signal_class == 3 % 2PSK区别对待
                x = signals_matrix(n, 3)/120000;  % 中心点横坐标及中心频率
                y = random_time(n, 1); % 中心点纵坐标及中心时刻位置
                w = 14/875;   % 宽度 为了画出的框可以包含信号而增加像素点
                h = random_time(n, 2);  % 高度及信号时长   
            elseif signal_class == 1 % FM区别对待
                x = signals_matrix(n, 3)/120000;  % 中心点横坐标及中心频率
                y = random_time(n, 1); % 中心点纵坐标及中心时刻位置
                % 基带信号频率：500  调制指数 5 
                w = 2 * (5+1) * 500/120000 + 14/875;   % 宽度 为了画出的框可以包含信号而增加像素点
                h = random_time(n, 2);  % 高度及信号时长   
            else  % AM和DSB
                x = signals_matrix(n, 3)/120000;  % 中心点横坐标及中心频率
                y = random_time(n, 1); % 中心点纵坐标及中心时刻位置
                w = 2 * signals_matrix(n, 2) / 120000 + 14/875;   % 宽度及带宽 为了画出的框可以包含信号而增加像素点
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
        disp(['信噪比为',num2str(16-snr),'dB下的第',num2str(i),'张']);
    end
end