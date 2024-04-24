function [x_signal, signals_matrix, random_time] = Signals_STFT(snr)
    tic
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
    for i = 1:signals_num
        random_time(i, 2) = unifrnd(0.2, 1.0); % 信号时长0.2-1s随机
        random_time(i, 1) = unifrnd(random_time(i, 2)/2,...
            1 - random_time(i, 2)/2); % 信号中心时刻在保证信号在图内的前提下在随机
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
    x_signal = awgn(x_signal, snr); % 加入高斯白噪声
    %% 短时傅里叶 sftf并画图
    [s, f, t2] = spectrogram(x_signal, window, noverlap, nfft, fs);
    k = 2/(fs*(window'*window));
    imagesc(f, t2,10*log10(abs(s).*abs(s)*k)');
    set(gca,'looseInset', [0 0 0 0]);% 消除图像的白边
    set(gca, 'xtick', [], 'ytick',[],  'xcolor', 'w', 'ycolor', 'w')% 去掉坐标轴
    colorbar('off'); % 去掉图像右边的色块
    toc
end