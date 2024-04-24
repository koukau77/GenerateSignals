% X�����й����׹��Ƶ����޳��������У�
% WINDOW��ָ����������Ĭ��ֵΪhamming����
% NFFT��DFT�ĵ����� NFFT> X��Ĭ��ֵΪ256��
% Fs �����ƹ��������ߵĳ���Ƶ�ʣ�Ĭ��ֵΪ1��
% Pxx�������׹���ֵ�� 
% F��Pxxֵ����Ӧ��Ƶ�ʵ� 
% NOVERLAPָ���ֶ��ص��������� �����NOVERLAP=L/2����ɵõ��ص�50%��Welch��ƽ������ͼ 
% pxx = pwelch(x,window,noverlap,nfft) 
% specifies the number of discrete Fourier transform (DFT) points to use in the PSD estimate.
% The default nfft is the greater of 256 or the next power of 2 greater than the length of the segments.
clear all
%% ���Ƶ�׹���
% welch����
fs = 240000;
[x, ~, ~] = Signals_STFT(-1);
Nx = length(x); % �źŵ���
ns = 8; % �ź�x[n]�ֳ�ns��
ov = 0.5; % ��֮���ص�50%
lsc = floor(Nx/(ns-(ns-1)*ov)); % ÿ�εĵ���
noverlap = floor(ov*lsc); % �ص�����
nfft = max(256,2^nextpow2(lsc)); % nfft����
[pxx,y] = pwelch(x, hamming(lsc), noverlap, nfft, fs);
plot(y,10*log10(pxx));
xlabel('Frequency (Hz)');
ylabel('PSD (dB/Hz)');
%% ����Ӧ��׹���

%% ��׵���

%% �źż��


