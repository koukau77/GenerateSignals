function [x ,f1, f2] = DSB(t)
    f = randi([500, 6000]);     %�����ź�Ƶ�� hz
    fc = randi([50000, 114000]); % �ز�Ƶ�� hz
    am = 1; % �����źŷ���
    ac = 1; % �����źŷ���
    y1 = am * sin(2*pi*f*t); % �����ź�
    y2 = ac * cos(2*pi*fc*t); % �ز�
    x = y1 .* y2;
    f1 = f;
    f2 = fc;
end