function [x, f1, f2] = FM(t)  
    f = 500;     %�����ź�Ƶ�� hz
    fc = randi([50000, 114000]); % �ز�Ƶ�� hz
    fs = length(t); % ����Ƶ��
    am = 1; % �����źŷ���
    ac = 1; % �ز�����
    mf = 5; % ��Ƶָ��
    kf = mf * 2 * pi * f / am;
%     diatf = kf * Am
%     B = 2 * (mf + 1) * fm
    y1 = am * sin(2*pi*f*t); % �����ź�
    phi_t = kf * cumsum(y1)/fs; % ��λ����
    x = ac * cos(2*pi*fc*t + phi_t); % �ѵ��ź�
    f1 = f;
    f2 = fc;

    % %���ƹ�����
    % L = length(x);               % ȡ�����г���
    % u = fftshift(fft(x ));       % ��ɢ����Ҷ�任����Ƶ��
    % u_pow = pow2db(abs(u).^2);     % ����תΪdB
    % w = (0:L-1)'*fs/L - 1/2*fs;    % ������-Ƶ��
    % figure()
    % plot(w, u_pow);
    % grid on;
    % xlabel('frequency(Hz)');
    % ylabel('magnitude(dB)');
    % title('������');
end