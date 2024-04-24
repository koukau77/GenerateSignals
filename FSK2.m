function [x, f1, f2] = FSK2(t)
    f1 = randi([20000, 80000]);    % 1所对应的频率
    f2 = f1 + 20000;               % 0所对应的频率
    m = round(rand(1, 10));  
    bit_num = length(m); 
%     disp(' Binary information at Trans mitter :');
%     disp(m);
    x = 0;
    ratio = 1/bit_num;
    for i = 1:1:bit_num
        if (m(i) == 1)
            y = cos(2*pi*f1*t) .* (t>(i-1)*ratio & t<i*ratio);
        else
            y = cos(2*pi*f2*t) .* (t>(i-1)*ratio & t<i*ratio);
        end
        x = x + y; 
    end
end