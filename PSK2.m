function [x, f1, f2] = PSK2(t)
    f = randi([50000, 114000]); % ÔØ²¨ÆµÂÊ hz
    x = round(rand(1, 8));  
    bit_num = length(x); 
%     disp(' Binary information at Trans mitter :');
%     disp(x);
    ratio = 1/bit_num;
    x = 0;
    for i = 1:1:bit_num
        if (x(i) == 1)
            y = cos(2*pi*f*t) .* (t>(i-1)*ratio & t<i*ratio);
        else
            y = cos(2*pi*f*t + pi) .* (t>(i-1)*ratio & t<i*ratio);
        end
        x = x + y; 
    end
    f1 = 0;
    f2 = f;
end