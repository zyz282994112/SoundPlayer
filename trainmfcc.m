function trainmfcc(m,n)

for j =1:m
    for i=1:n
        fname = sprintf('¹ÂÁ¢´Ê%dÄ£°å%d.wav',j-1,i);
        xx = wavread(fname);
        [x1,x2]=vad(xx);
        mt = mfcc(xx);
        mt = mt(x1:x2,:);
        fname = sprintf('%dmfcc%d.txt',j-1,i);
        fid= fopen(fname,'w');
           for t=1:size(mt,1)
               for m=1:size(mt,2)
                  fprintf(fid,'%f ',mt(t,m)); 
               end
               fprintf(fid,'\n');
           end
         fclose(fid);
    end
end
