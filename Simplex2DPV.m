function  [TFRMAT,outcood] = Simplex2DPV(coos, centerx,centery,imgtst, imgref, w, flag)
%
% res............图像的尺寸 2*2 长和宽
% coos....... ...初值参数，3*4 列存放4个单纯形顶点
% imgtst.........浮动图像 二维矩阵灰度图象        
% imgref.........参考图象 二维矩阵灰度图象        
% w..............权值矩阵 和图像同尺寸            
% outcood........极值处的参数向量 3*1             
% Label等为状态参数，可以带出察看状态。            
% 标志flag作为区分 flag=1 PV flag=2 PI flag=3 TRI  

TFRMAT=zeros(3);

[r,c] = size(coos);


if(c~=(r+1)) 
    msgbox('错误的维数！','','warn');
    return;
end

if(r~=3)
    msgbox('错误的维数！','','warn');
    return;
end

n=c;
F=zeros(1,n);


% 原始图像数据归一化
imgt     = (imgref-min(imgref(:)))/(max(imgref(:))-min(imgref(:)));
imgs     = (imgtst-min(imgtst(:)))/(max(imgtst(:))-min(imgtst(:)));
JSMI  =zeros(1,80); 

for I=1:n
    cood=coos(:,I);
    T=coos2mat(cood,centerx,centery);
    if flag==1  
        Temp = nmiw2(imgref,imgt,imgs,inv(T),w);   
        F(I)=Temp(2);                           % 得到nmiw2的第二项
    end
end


count=0;

while (count<300)
    count = count+1;
    Fmax=max(F);
    Fmin=min(F);
    Xmaxind=find(F==max(F));
    Xminind=find(F==min(F));
    SumX=sum(coos,2);
    Xmax=coos(:,Xmaxind(1));
    Xhatt=SumX-Xmax;
    Xhatt=Xhatt/(n-1);
    Xref=2*Xhatt-coos(:,Xmaxind(1));
    T=coos2mat(Xref,centerx,centery);
    
    
    if(flag==1)
        Temp = nmiw2(imgref,imgt,imgs,inv(T),w);
        Fref = Temp(2);
    end

    if(Fmin(1)>Fref(1))
        %开始扩展
        Xexp=2*Xref-Xhatt;
        T=coos2mat(Xexp,centerx,centery);
        
        if(flag==1)
            Temp = nmiw2(imgref,imgt,imgs,inv(T),w);
            Fexp = Temp(2);
        end
        if(Fexp(1)<Fref(1))
            Xnew=Xexp;
        else
            Xnew=Xref;
        end
    else
        if(Xmaxind(1)==1)
            intmFmax=2;
        else
            intmFmax=1;
        end

        for I=1:n
            if( I~=Xmaxind(1))
                if(F(I)>F(intmFmax))
                    intmFmax=I;
                end
            end
        end

        if F(intmFmax)>Fref(1)
            Xnew=Xref;
        else
            if Fmax(1)<=Fref(1)
                Xnew=(Xmax+Xhatt)/2;
            else
                Xnew=(Xref+Xhatt)/2;
            end
        end
    end

    % 替换
    d = (sum((Xnew - Xmax).^2)).^0.5;
   
   
    if(d<0.000005 || Fmin(1)<=-2 )
        msgbox('误差已经小于0.000005！','','warn');
        TFRMAT = coos2mat(coos(:,Xminind(1)),centerx,centery);
        outcood= coos(:,Xminind(1));
        msgbox(['最小的H是' num2str(Fmin(1)) ],'','warn');
        return ;
    end
    
    coos(:,Xmaxind(1))=Xnew;
    
    T=coos2mat(Xnew,centerx,centery);
    if(flag==1)
        temp = nmiw2(imgref,imgt,imgs,inv(T),w);
        Fnew=temp(2);
    end

    F(Xmaxind)=Fnew;
    if(Fnew(1)>Fmax(1))
        Xminvec=coos(:,Xminind(1));
        for a=1:n
            NewX=(coos(:,a)+Xminvec)/2;
            coos(:,a)=NewX;
            
            T=coos2mat(NewX,centerx,centery);
            
            if(flag==1)
                temp = nmiw2(imgref,imgt,imgs,inv(T),w);
                F(a)=temp(2);
            end
        end
    end
        
    % 以另外一本书上的标准判断！
    tmax=max(F);
    tmin=min(F);
    delta=2*abs(tmax(1)-tmin(1))/(abs(tmax(1))+abs(tmin(1)));
%     sts->Panels->Items[2]->Text=FloatToStr(delta);
%     sts->Panels->Items[1]->Text=FloatToStr(-tmin.r(1));

%     % 中间结果，待屏蔽
%     Fmin=min(F);
%     JSMI(count) = Fmin;
    if(delta<0.00001 )
        disp('误差已经很小了！');
        disp(num2str(count));
        TFRMAT=coos2mat(coos(:,Xminind(1)),centerx,centery);
        outcood=coos(:,Xminind(1));
        disp(['最小的H是' num2str(Fmin(1))]);
        return ;
    end

    if(mod(count,20)==0)
        Fmin=min(F);
        if strcmp(questdlg('需要停止吗？',num2str(Fmin(1)),'OK','Cancel','OK'),'OK') ==1
            TFRMAT=coos2mat(coos(:,Xminind(1)),centerx,centery);
            outcood=coos(:,Xminind(1));
            return;
         end
    end
end

disp('已经完成了300次搜索了！');

TFRMAT=coos2mat(coos(:,Xminind(1)),centerx,centery);
outcood=coos(:,Xminind(1));
return 