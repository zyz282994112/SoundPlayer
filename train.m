num = 12;%%�����ʸ���
count = 30;%%ÿ�������ʵ�������

% %ѵ��ʸ��������(ѵ��ʱȥע��)
% trainVQ('all',num,count);
% 
% %ѵ��ģ��(ѵ��ʱȥע��)
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

%%��ȡģ��
for i = 1:num
    fname = sprintf('tr%d.txt',i);
    aa(i).tr = load(fname);
    fname = sprintf('e%d.txt',i);
    bb(i).e = load(fname);
end
    
%%��ʶ��ģ�崦��
juzhen = load('all.txt');
Fs=11025;
fprintf('˵��������\n');
x= wavrecord(5*Fs, Fs, 'int16');
%x=wavread('������9ģ��23.wav');
fprintf('¼������������\n');
[x1 x2] = vad(x);
m = mfcc(x);
m = m(x1:x2,:);
    
%%�������
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

%%��������������
logseq=zeros(num,1);
for i = 1:num
    [tmpstate(i).pstate,logseq(i)] = hmmdecode(seq',aa(i).tr,bb(i).e);
    fprintf('%f  ',logseq(i));
end
[tmp,maxnum]=max(logseq);
if tmp > i || tmp < i
    fprintf('\n%dΪʶ����\n',maxnum-1);
end



