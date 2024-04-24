function [x ,f1, f2] = DSB(t)
    f = randi([500, 6000]);     %基带信号频率 hz
    fc = randi([50000, 114000]); % 载波频率 hz
    am = 1; % 基带信号幅度
    ac = 1; % 基带信号幅度
    y1 = am * sin(2*pi*f*t); % 基带信号
    y2 = ac * cos(2*pi*fc*t); % 载波
    x = y1 .* y2;
    f1 = f;
    f2 = fc;
end