function [final_IR,final_E] = trainHMM(module_num,n,name)
%%
%n为该孤立词对应的模板个数
%name为矢量量化后的矩阵名称
%module_num为要训练的孤立词标识数

statenum = 5;
xulienum = 128;

%%读取聚类模板
juzhen = load('all.txt');

%%初始化序列、状态转移矩阵，混淆矩阵
tr = ones(statenum,statenum)/(statenum*statenum);%状态数选择6个
e = ones(statenum,xulienum)/(statenum*xulienum);
final_IR = zeros(statenum,statenum)/(statenum*statenum);
final_E = zeros(statenum,xulienum)/(statenum*xulienum);

%%读取待识别模板
for d=1:1:n
    fname = sprintf('孤立词%d模板%d.wav',module_num-1,d);
    module = wavread(fname);
    [x1,x2]=vad(module);
    mt = mfcc(module);
    mt = mt(x1:x2,:);
    seq = zeros(size(mt,1),1);
    
    %%获得序列
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

    %%训练HMM参数
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

