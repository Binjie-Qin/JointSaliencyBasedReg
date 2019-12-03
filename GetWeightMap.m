function salient = GetWeightMap(dataa,datab,radius, th, s)
% 得到两幅给定图像的惯性矩阵相似图,夹角（加权图）
% 注意：两幅图像应该同样尺寸，否则之前应该预调整
% 
[width,height] = size(dataa);
%为了加快速度而定~
coop = zeros(1,2);

DATA = zeros(width+1,height+1);
DATB = zeros(width+1,height+1);

dataatemp=dataa;
databtemp=datab;

% 图像平滑 调整s
if s~=0
   dataatemp=smoothimage(dataatemp,s);
   databtemp=smoothimage(databtemp,s);
else
   dataatemp=dataa;
   databtemp=datab;
end

dataatemp=GetEnergyImage(dataatemp,0);
databtemp=GetEnergyImage(databtemp,0);


DATA(2:width+1,2:height+1)=dataatemp;
DATB(2:width+1,2:height+1)=databtemp;

thresholdd = th;

maxa=max(dataatemp(:));
maxb=max(databtemp(:));
mina=min(dataatemp(:));
minb=min(databtemp(:));
% 去除一些值很小的的点。
thresholda=mina + thresholdd*(maxa-mina);
thresholdb=minb + thresholdd*(maxb-minb);
%    Mm coor;
maxea = 0;
maxeb = 0;
% maxva,maxvb;
simil = 0;
salient=zeros(width,height);
% count(0);
count = 0;


maxva = zeros(width-2*radius,height-2*radius,2);
maxea = zeros(width-2*radius,height-2*radius);

maxvb = zeros(width-2*radius,height-2*radius,2);
maxeb = zeros(width-2*radius,height-2*radius);


for J = 1+radius : height-radius
    for I=1+radius : width-radius
        if DATA(I,J)>thresholda && DATB(I,J)>thresholdb
            [maxea(I,J), maxva(I,J,:)] = enertiaeig([I,J],DATA,radius); 
            [maxeb(I,J), maxvb(I,J,:)] = enertiaeig([I,J],DATB,radius);
        end
    end
end

for J=1+radius : height-radius
    for I=1+radius : width-radius

%        count = count+1;
       if DATA(I,J)>thresholda && DATB(I,J)>thresholdb
           if maxea(I,J)==0 || maxeb(I,J)==0
               simil=0;
           else
               vect1 = dot(maxva(I,J,:),maxvb(I,J,:));
               simil = vect1;
               vect2 = dot(maxva(I,J,:),maxva(I,J,:));
               simil = simil/sqrt(vect2);
               vect3 = dot(maxvb(I,J,:),maxvb(I,J,:));
               simil = simil/sqrt(vect3);
               % cos(夹角)
               simil = abs(simil);
           end

           salient(I,J)=simil;
       end
    end
end
