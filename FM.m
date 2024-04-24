function [x, f1, f2] = FM(t)  
    f = 500;     %基带信号频率 hz
    fc = randi([50000, 114000]); % 载波频率 hz
    fs = length(t); % 采样频率
    am = 1; % 基带信号幅度
    ac = 1; % 载波幅度
    mf = 5; % 调频指数
    kf = mf * 2 * pi * f / am;
%     diatf = kf * Am
%     B = 2 * (mf + 1) * fm
    y1 = am * sin(2*pi*f*t); % 基带信号
    phi_t = kf * cumsum(y1)/fs; % 相位积分
    x = ac * cos(2*pi*fc*t + phi_t); % 已调信号
    f1 = f;
    f2 = fc;

    % %绘制功率谱
    % L = length(x);               % 取得序列长度
    % u = fftshift(fft(x ));       % 离散傅里叶变换，求频谱
    % u_pow = pow2db(abs(u).^2);     % 幅度转为dB
    % w = (0:L-1)'*fs/L - 1/2*fs;    % 横坐标-频率
    % figure()
    % plot(w, u_pow);
    % grid on;
    % xlabel('frequency(Hz)');
    % ylabel('magnitude(dB)');
    % title('功率谱');
end