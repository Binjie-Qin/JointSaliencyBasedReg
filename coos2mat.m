function tfr = coos2mat( coos, centerx, centery)
% ��һ����ά������ת��Ϊ�任����
% centerx,centeryΪ��ת����
% coos��һ�����е����������ֱ����x,yλ�ƺ���ת�Ƕ�

% if coos.rows()!=3){ShowMessage("ά�����ԣ�");return 0;};
if length(coos)~=3 
    disp('ά�����ԣ�');
end

tfr1 = [1,0,-centerx; 0 1 -centery;0 0 1];

tfr2=inv(tfr1);

tfr3 = [1 0 coos(1,1); 0 1 coos(2,1); 0 0 1];

tfr = [cos(pi*coos(3,1)/180) -sin(pi*coos(3,1)/180)  0;
       sin(pi*coos(3,1)/180) cos(pi*coos(3,1)/180)   0;
       0                          0                  1];

tfr=tfr3*tfr2*tfr*tfr1;
