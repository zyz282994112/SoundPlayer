function [final_IR,final_E] = trainHMM(module_num,n,name)
%%
%nΪ�ù����ʶ�Ӧ��ģ�����
%nameΪʸ��������ľ�������
%module_numΪҪѵ���Ĺ����ʱ�ʶ��

statenum = 5;
xulienum = 128;

%%��ȡ����ģ��
juzhen = load('all.txt');

%%��ʼ�����С�״̬ת�ƾ��󣬻�������
tr = ones(statenum,statenum)/(statenum*statenum);%״̬��ѡ��6��
e = ones(statenum,xulienum)/(statenum*xulienum);
final_IR = zeros(statenum,statenum)/(statenum*statenum);
final_E = zeros(statenum,xulienum)/(statenum*xulienum);

%%��ȡ��ʶ��ģ��
for d=1:1:n
    fname = sprintf('������%dģ��%d.wav',module_num-1,d);
    module = wavread(fname);
    [x1,x2]=vad(module);
    mt = mfcc(module);
    mt = mt(x1:x2,:);
    seq = zeros(size(mt,1),1);
    
    %%�������
    for i = 1:size(mt,1)
        min = 9999;
        for j = 1:size(juzhen,1)
            tmp = norm(mt(i,:)-juzhen(j,:));
            if tmp < min
                min = tmp;
                tag = j;
            end
        end
        seq(i) = tag;
    end

    %%ѵ��HMM����
%    if d == 1
        [estIR(d).tr,estE(d).e] = hmmtrain(seq,tr,e); 
%    else
%        [estIR(d).tr,estE(d).e] = hmmtrain(seq,estIR(d-1).tr,estE(d-1).e);
%    end
end

for d = 1:n
    final_IR = final_IR + estIR(d).tr;
    final_E = final_E + estE(d).e;
end;
final_IR = final_IR/n;
final_E = final_E/n;

