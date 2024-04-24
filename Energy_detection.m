% X：进行功率谱估计的有限长输入序列；
% WINDOW：指定窗函数，默认值为hamming窗；
% NFFT：DFT的点数， NFFT> X，默认值为256；
% Fs ：绘制功率谱曲线的抽样频率，默认值为1；
% Pxx：功率谱估计值； 
% F：Pxx值所对应的频率点 
% NOVERLAP指定分段重叠的样本数 ，如果NOVERLAP=L/2，则可得到重叠50%的Welch法平均周期图 
% pxx = pwelch(x,window,noverlap,nfft) 
% specifies the number of discrete Fourier transform (DFT) points to use in the PSD estimate.
% The default nfft is the greater of 256 or the next power of 2 greater than the length of the segments.
clear all
%% 宽带频谱估计
% welch参数
fs = 240000;
[x, ~, ~] = Signals_STFT(-1);
Nx = length(x); % 信号点数
ns = 8; % 信号x[n]分成ns段
ov = 0.5; % 段之间重叠50%
lsc = floor(Nx/(ns-(ns-1)*ov)); % 每段的点数
noverlap = floor(ov*lsc); % 重叠点数
nfft = max(256,2^nextpow2(lsc)); % nfft点数
[pxx,y] = pwelch(x, hamming(lsc), noverlap, nfft, fs);
plot(y,10*log10(pxx));
xlabel('Frequency (Hz)');
ylabel('PSD (dB/Hz)');
%% 自适应噪底估计

%% 噪底抵消

%% 信号检测


