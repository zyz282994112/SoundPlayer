function trainVQ(name,m,n)
%m为孤立词数
%n为该孤立词对应的模板个数
%name为矢量量化后的矩阵名称

codebook_size=128;%码书大小
codebook_dimen=24;%M:码书维数
circle_num=20;%码书训练循环次数，可选项，如果根据相对失真作为结束条件，就不使用该变量

signal_num=1;
for j =1:m
    for i=1:n
        fname = sprintf('孤立词%d模板%d.wav',j-1,i);
        xx = wavread(fname);
        [x1,x2]=vad(xx);
        mt = mfcc(xx);
        mt = mt(x1:x2,:);
        train_signal(signal_num+1:size(mt,1)+signal_num,1:size(mt,2))=mt(:,:);
        signal_num = signal_num +size(mt,1);
    end
end

s=zeros(codebook_size,codebook_dimen);%初始化初始码书
final_codebook=zeros(codebook_size,codebook_dimen);%初始化最终码书
y_center=zeros(codebook_size,codebook_dimen);  %初始化新码书质心
r=1;

gap = (signal_num - mod(signal_num,codebook_size))/codebook_size;
%选择初始码书
for i=1:codebook_size
    for j=1:codebook_dimen
    s(i,j)=train_signal(i*gap,j); %每隔gap个样本取一个样本，存入s数组作为初始码书 
    end
end
number=zeros(signal_num,1);

D=50000;%起始平均失真
j2=0;
xiangdui__distort_value=50000;
 for j1=1:circle_num;%让程序循环运行circle_num次结束
  while(xiangdui__distort_value>0.0000001)%当相对失真小于0.000001时结束程序 
   j2=j2+1;%如果以相对失真为循环结束条件，j2可记录下循环次数
   
   %-----求与训练样本距离最近的码书，则距离最近的码书索引就是训练样本所属的码书号------
   for j=1:signal_num    % signal_num：训练样本的个数
       for k=1:codebook_size     
            A=0;
            for m=1:codebook_dimen
                A=A+(train_signal(j,m)-s(k,m))^2;%计算训练样本与当前码书质心的距离
            end
           d(k)=A;
      end
        dm=min(d);%找出训练样本与所有当前码书距离最小值
        %-----找出与训练样本j距离最小的码书的索引
        for  n=1:codebook_size
          if d(n)==dm
             p=n;
          end
        end 
     number(j)=p;
      %-----找出与训练样本j距离最小的码书的索引结束
   end
   %-----求与训练样本距离最近的码书，则距离最近的码书索引就是训练样本所属的码书号结束------
   N1=zeros(codebook_size,1);%N1：每个码书包含的样本个数
   %-----求码书质心过程------
   for t=1:codebook_size
        y=zeros(codebook_dimen,1);  %codebook_dimen:码书维数
        N=0;
        for j=1:signal_num  % signal_num：训练样本的个数
            if t==number(j);
               for m=1:codebook_dimen
                 y(m)=y(m)+train_signal(j,m);
               end
                N=N+1;%计算属于每个码书的样本个数
            end
        end 
        N1(t,1)=N;%属于每个码书的样本个数
        if N1(t,1)>0
             for m=1:codebook_dimen
             y_center(t,m)=y(m)/N1(t,1);%求每个码书的质心
             s(t,m)=y_center(t,m);%把训练出来的质心赋给 s
             final_codebook(t,m)=y_center(t,m);
             end
        end
   end
   %-----求码书质心结束------
   
   %-----求平均失真------
   ave_distort(j2)=0;
   for n=1:signal_num
        for m=1:codebook_dimen
          ave_distort(j2)=ave_distort(j2)+(train_signal(n,m)-s(number(n),m))^2; %求所有训练样本和其所属码书质心的距离
        end
   end
   ave_distort(j2)=ave_distort(j2)/signal_num;%计算第j1次循环的平均失真
   %-----求平均失真结束------
    
   xiangdui__distort(j2)=abs((D-ave_distort(j2))/D); %求相对失真
   D=ave_distort(j2);
   xiangdui__distort_value=xiangdui__distort(j2);
  end
 j1=circle_num;
 end
%把训练好的码书写到文本文件

fname = sprintf('%s.txt',name);
 fid= fopen(fname,'w');
       for t=1:codebook_size
           for m=1:codebook_dimen
              fprintf(fid,'%6.2f ', s(t,m)); 
           end
           fprintf(fid,'\n');
       end
 fclose(fid);
  
 
