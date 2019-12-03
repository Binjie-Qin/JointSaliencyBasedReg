function  [TFRMAT,outcood] = Simplex2DPV(coos, centerx,centery,imgtst, imgref, w, flag)
%
% res............ͼ��ĳߴ� 2*2 ���Ϳ�
% coos....... ...��ֵ������3*4 �д��4�������ζ���
% imgtst.........����ͼ�� ��ά����Ҷ�ͼ��        
% imgref.........�ο�ͼ�� ��ά����Ҷ�ͼ��        
% w..............Ȩֵ���� ��ͼ��ͬ�ߴ�            
% outcood........��ֵ���Ĳ������� 3*1             
% Label��Ϊ״̬���������Դ����쿴״̬��            
% ��־flag��Ϊ���� flag=1 PV flag=2 PI flag=3 TRI  

TFRMAT=zeros(3);

[r,c] = size(coos);


if(c~=(r+1)) 
    msgbox('�����ά����','','warn');
    return;
end

if(r~=3)
    msgbox('�����ά����','','warn');
    return;
end

n=c;
F=zeros(1,n);


% ԭʼͼ�����ݹ�һ��
imgt     = (imgref-min(imgref(:)))/(max(imgref(:))-min(imgref(:)));
imgs     = (imgtst-min(imgtst(:)))/(max(imgtst(:))-min(imgtst(:)));
JSMI  =zeros(1,80); 

for I=1:n
    cood=coos(:,I);
    T=coos2mat(cood,centerx,centery);
    if flag==1  
        Temp = nmiw2(imgref,imgt,imgs,inv(T),w);   
        F(I)=Temp(2);                           % �õ�nmiw2�ĵڶ���
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
        %��ʼ��չ
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

    % �滻
    d = (sum((Xnew - Xmax).^2)).^0.5;
   
   
    if(d<0.000005 || Fmin(1)<=-2 )
        msgbox('����Ѿ�С��0.000005��','','warn');
        TFRMAT = coos2mat(coos(:,Xminind(1)),centerx,centery);
        outcood= coos(:,Xminind(1));
        msgbox(['��С��H��' num2str(Fmin(1)) ],'','warn');
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
        
    % ������һ�����ϵı�׼�жϣ�
    tmax=max(F);
    tmin=min(F);
    delta=2*abs(tmax(1)-tmin(1))/(abs(tmax(1))+abs(tmin(1)));
%     sts->Panels->Items[2]->Text=FloatToStr(delta);
%     sts->Panels->Items[1]->Text=FloatToStr(-tmin.r(1));

%     % �м�����������
%     Fmin=min(F);
%     JSMI(count) = Fmin;
    if(delta<0.00001 )
        disp('����Ѿ���С�ˣ�');
        disp(num2str(count));
        TFRMAT=coos2mat(coos(:,Xminind(1)),centerx,centery);
        outcood=coos(:,Xminind(1));
        disp(['��С��H��' num2str(Fmin(1))]);
        return ;
    end

    if(mod(count,20)==0)
        Fmin=min(F);
        if strcmp(questdlg('��Ҫֹͣ��',num2str(Fmin(1)),'OK','Cancel','OK'),'OK') ==1
            TFRMAT=coos2mat(coos(:,Xminind(1)),centerx,centery);
            outcood=coos(:,Xminind(1));
            return;
         end
    end
end

disp('�Ѿ������300�������ˣ�');

TFRMAT=coos2mat(coos(:,Xminind(1)),centerx,centery);
outcood=coos(:,Xminind(1));
return 