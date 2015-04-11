num = 12;%%孤立词个数
count = 30;%%每个孤立词的样本数

% %训练矢量分类器(训练时去注释)
% trainVQ('all',num,count);
% 
% %训练模板(训练时去注释)
% for i = 1:num
%     [tmpa,tmpb]=trainHMM(i,count,'all');
%     aa(i).tr = tmpa;
%     bb(i).e = tmpb;
%     fname = sprintf('tr%d.txt',i);
%     fid= fopen(fname,'w');
%     for tt=1:size(aa(i).tr,1)
%        for mm=1:size(aa(i).tr,2)
%           fprintf(fid,'%f ', aa(i).tr(tt,mm)); 
%        end
%        fprintf(fid,'\n');
%     end
%     fclose(fid);
%     fname = sprintf('e%d.txt',i);
%     fid= fopen(fname,'w');
%     for tt=1:size(bb(i).e,1)
%        for mm=1:size(bb(i).e,2)
%           fprintf(fid,'%f ', bb(i).e(tt,mm)); 
%        end
%        fprintf(fid,'\n');
%     end
%     fclose(fid);
% end

%%读取模板
for i = 1:num
    fname = sprintf('tr%d.txt',i);
    aa(i).tr = load(fname);
    fname = sprintf('e%d.txt',i);
    bb(i).e = load(fname);
end
    
%%待识别模板处理
juzhen = load('all.txt');
Fs=11025;
fprintf('说话！！！\n');
x= wavrecord(5*Fs, Fs, 'int16');
%x=wavread('孤立词9模板23.wav');
fprintf('录音结束！！！\n');
[x1 x2] = vad(x);
m = mfcc(x);
m = m(x1:x2,:);
    
%%获得序列
seq = zeros(size(m,1),1);
for i = 1:size(m,1)
    min = 9999;
    for j = 1:size(juzhen,1)
        tmp = norm(m(i,:)-juzhen(j,:));
        if tmp < min
            min = tmp;
            tag = j;
        end
    end
    seq(i) = tag;
end

%%计算最大概率序列
logseq=zeros(num,1);
for i = 1:num
    [tmpstate(i).pstate,logseq(i)] = hmmdecode(seq',aa(i).tr,bb(i).e);
    fprintf('%f  ',logseq(i));
end
[tmp,maxnum]=max(logseq);
if tmp > i || tmp < i
    fprintf('\n%d为识别结果\n',maxnum-1);
end



