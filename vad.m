function [x1,x2]=vad(x)

framelen=240;%帧长
frameinc=80;%帧移
amp1 = 10;%初时短时能量高门限
amp2 = 2;%初时短时能量低门限
zcr1 = 10;%初时过零率高门限
zcr2 = 5;%初时过零率低门限
maxsilence = 8;%8*10ms 语音段中允许的最大静音长度
minlen = 75;%75*10ms 语音最小长度,若小于此，则认为是噪音

status =0;%初始状态为静音状态
count = 0;%初始语音段
silence = 0;%静音段长度

%过零率计算
%（实现根据公式：T为最低门限
%Zn = 1/2sum{|sgn[Xn(m)-T]-sgn[Xn(m-1)-T]|+|sgn[Xn(m)+T]-sgn[Xn(m-1)+T]};
tmp1 = enframe(x(1:end-1),framelen,frameinc);
tmp2 = enframe(x(2:end),framelen,frameinc);
signs = (tmp1.*tmp2)<0; %点乘tmp1与tmp2，结果小于0的值为1，否则为0
diffs = (tmp1-tmp2)>0.02;%设置了过零率的一个最低门限，从而防止低频干扰(即T = 0.01)
zcr = sum(signs.*diffs,2);

%计算短时能量(En = sum{|Xw(m)|})为减少计算量，故采用短时平均幅值替代短时能量
%filter作用为减少随机噪声干扰
amp = sum(abs(enframe(filter([1 -0.9375], 1, x), framelen, frameinc)), 2);

%调整能量门限
amp1 = min(amp1, max(amp)/4);
amp2 = min(amp2, max(amp)/8);

%端点检测
for n = 1:length(zcr)
    goto = 0;
    switch status
        case{0,1}
            if amp(n)>amp1
                status = 2;
                silence = 0;
                count =count+1;
            elseif amp(n)>amp2 || zcr(n)>zcr2
                status = 1;
                count = count +1;
            else
                status =0;
                count = 0;
            end
        case 2,
            if amp(n) > amp2 || zcr(n) > zcr2
                count = count +1;
            else
                silence = silence+ 1;
                if silence < maxsilence
                    count = count +1;
                elseif count < minlen
                    count =0;
                    status =0;
                    silence = 0;
                else 
                    status =3;
                end
            end
        case 3,
            break;
    end
end

count = count -silence/2;%是否可以取消此步？即不考虑最后语音结束时额外录制的静音部分
x2 = x1 + count - 1;%记录语音结束点
                
            
    
    
    