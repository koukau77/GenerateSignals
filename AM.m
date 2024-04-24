function [x ,f1, f2] = AM(t)
    f = randi([1000, 6000]);     %�����ź�Ƶ�� hz
    fc = randi([50000, 114000]); % �ز�Ƶ�� hz
    am = 1; % �����źŷ���
    ac = 1; % �ز��źŷ���
    y1 = am * cos(2*pi*f*t); % �����ź�
    y2 = ac * cos(2*pi*fc*t); % �ز�
    a = 1;
    x = (a+y1) .* y2;
    f1 = f;
    f2 = fc;
end