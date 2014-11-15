    
       function [A_KLT,Lambda,M_COV]=PCA_KL(D,p);
     
%  ������� �.�., �������� �.�., 2006 
 
%  �������� PCA_KL.m 
%  ���������� ������ ���������� M_COV, ������ 
%  �������������� ��������-����� A_KLT � 
%  ����������� �������� Lambda �� ������ ������ PCA/KLT
%  ��� �������, ����� ������ DIM > KL=K*L;
%  ������������ ����������� ������������: ���
%  ������������ ���������� ������������-�������: 
%                  eig, sort, diag, sum.      
%  ��������������:
%  D      - ������� �������� ������ ������� DIM �� KL , ��� 
%  DIM    - ����������� ������� ���������,
%  KL     - ����� ����� �������;
%  p      � ���������� ���������� ����������� �����:
%                "p" ������ ���� ������ "DIM";
%  A_KLT  �  ������� �������������� ��������-����� (KLT);
%  Lambda �  ����������� ����� ���  ������� ���������� M_COV;
%  M_COV    �  ������� ����������;                     
%  v1       �  ����������� ������� ���  ������� M_COV.
%-----------------------------------------------------------
%    ��������� �������� �� ������ �������, ���������� 
%    � ���������� ������� �.�., �������� �.�. �������� 
%    ������������� �������� �� ����������� �����/ 
%    ������������ ������� (����), ���, 2006, 176 �.

%%%----------------------------
% ���������� ������� ����������
              [DIM,KL]=size(D);
              M_COV=(D'*D);  %%��� ������������
              % M_COV=(D'*D)/(DIM*KL);  %% ��� ������������
% ���������� ����������� ����� � ��������������� ��   ��������    
              [W2,Lambda]=eig(M_COV);save EigenVector W2 Lambda ;
               Lambda=diag(Lambda);
                 [a,ind1]=sort(-Lambda); a=-a; Lambda=a;
                  %[Lambda,ind1]=sort(Lambda,'descend');
                    W2=W2(:,ind1); 
                    W2_inv=W2';I2=W2*W2_inv;
 % ������������ ����������
                    V1=diag(1./sqrt(Lambda))*(D*W2)'; % ������������
                    save RES V1  Lambda  D W2;
                    %v1=(D*W2)'; %  ��� ������������
                    Lambda=Lambda(1:p);   Lambda=Lambda'; 
                    A_KLT=V1(1:p,:);
                     