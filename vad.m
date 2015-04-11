function [x1,x2]=vad(x)

framelen=240;%֡��
frameinc=80;%֡��
amp1 = 10;%��ʱ��ʱ����������
amp2 = 2;%��ʱ��ʱ����������
zcr1 = 10;%��ʱ�����ʸ�����
zcr2 = 5;%��ʱ�����ʵ�����
maxsilence = 8;%8*10ms ����������������������
minlen = 75;%75*10ms ������С����,��С�ڴˣ�����Ϊ������

status =0;%��ʼ״̬Ϊ����״̬
count = 0;%��ʼ������
silence = 0;%�����γ���

%�����ʼ���
%��ʵ�ָ��ݹ�ʽ��TΪ�������
%Zn = 1/2sum{|sgn[Xn(m)-T]-sgn[Xn(m-1)-T]|+|sgn[Xn(m)+T]-sgn[Xn(m-1)+T]};
tmp1 = enframe(x(1:end-1),framelen,frameinc);
tmp2 = enframe(x(2:end),framelen,frameinc);
signs = (tmp1.*tmp2)<0; %���tmp1��tmp2�����С��0��ֵΪ1������Ϊ0
diffs = (tmp1-tmp2)>0.02;%�����˹����ʵ�һ��������ޣ��Ӷ���ֹ��Ƶ����(��T = 0.01)
zcr = sum(signs.*diffs,2);

%�����ʱ����(En = sum{|Xw(m)|})Ϊ���ټ��������ʲ��ö�ʱƽ����ֵ�����ʱ����
%filter����Ϊ���������������
amp = sum(abs(enframe(filter([1 -0.9375], 1, x), framelen, frameinc)), 2);

%������������
amp1 = min(amp1, max(amp)/4);
amp2 = min(amp2, max(amp)/8);

%�˵���
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

count = count -silence/2;%�Ƿ����ȡ���˲����������������������ʱ����¼�Ƶľ�������
x2 = x1 + count - 1;%��¼����������
                
            
    
    
    