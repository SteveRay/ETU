 %----------  �������� ������ � ���������  -------------
      %�������� ������ � �������� Data_S � Data_M;
      p=10;
      K=10; Kn=10;
     % ������� ��������� ������ �������   
            Kn=1; % ��������� ��������
              Kk=10; % �������� ��������
  %---------------------------------------------------          
     % ������� ����� � ����
          MEAN_FACE=0;

            figure(3); clf; 
    % - ���������� ������� ������� � ������ � ����
   MEAN_FACE=0;
    for kk=1:K
                                            
              obraz = DATA(:,:,kk); 
                 [M,N]=size(obraz);
                   subplot(2,3,1); imshow(obraz);
                     title(['Face from DB:  ',num2str(kk)]);
                  MEAN_FACE=MEAN_FACE+obraz; 
             subplot(2,3,2); imshow(MEAN_FACE/kk);
             pause(.01);
     end;       
                                      
   % ------ ���������� �������� ������ � ����   
          MEAN_FACE=MEAN_FACE/K;
            subplot(2,3,3); imshow(MEAN_FACE);
               title('Mean Face in Base');
               pause(.01);     
               % MEAN_FACE=mean2(MEAN_FACE);
%---- ���������� ������� ���������� -------------
    
     D=[];
    for kk=1:K
               obraz = DATA(:,:,kk);  
               subplot(2,3,4); imshow(obraz);
               title(['Ref.Image:  ',num2str(kk)]);
                    obraz=double(obraz);
                    obraz=obraz-MEAN_FACE; %MMM; 
                    subplot(2,3,5); imshow(norma(obraz)/256); 
                    title(['Ref.Image - Mean Face']);pause(.01); 
%                     MMM=mean2(obraz);
%                     obraz=obraz-MMM;
%                     subplot(2,2,2); imshow(obraz);%%% ����!!!������!!!
               obraz=obraz/norm(obraz);                          
               D=[D obraz(:)];
               pause (.1);
       end; 
        % ������ ������� ��������� � �� ����������       
               [A_KLT,Lambda]=PCA_KL(D,p);
               
               Lambda=abs(Lambda);
               subplot(2,3,6); stem(1:p, Lambda(1:p)); grid;
               title('EigenValues');
               
      %--   �������������� 1D KLT (�������� �������� ������ 
        %      � ����� ������������ ���������) -----   
               RED=A_KLT*D;
               
            
   % - ����������� ���������� �������� � 3D ������������ ���������              
               graf_3dK_number(RED,10,1,Kn,4); pause(.1);
               title('Input DataBase in 3D subspace')
            %   graf_3dK_number(RED,L,K,Kn,3); view(0,90);
            
     %--Eigen Faces------------------       
          
          
           TEK1=[]; TEK2=[];
    for k=1:K
  
              EF=reshape(A_KLT(k,:),[M,N]);
                EF=norma(EF)/256;
                 if k<6, TEK1=[TEK1 EF];
                 else    TEK2=[TEK2 EF];
                 end;
    end;
         EigenFaces_MATRIX=[TEK1;TEK2];
         figure(5); clf;  
         imshow(EigenFaces_MATRIX); pause(.1);
      %---------------------------------------  
%   figure(6);           
%     for kk=1:K
%               obraz = DATA(:,:,kk);  
%                subplot(2,3,4); imshow(obraz);
%                title(['Ref.Image:  ',num2str(kk)]);
%                           pause(.01);
%                     obraz=double(obraz);
%                     obraz=obraz-MEAN_FACE; %MMM; 
%                     red=A_KLT*obraz(:);
%                 for j=1:p  
%                     INV_A_KLT=A_KLT(1:j,:)';
%                     obraz_REC=INV_A_KLT*red(1:j);
%                     obraz_NEW=reshape(obraz_REC,[M,N]);
%                     subplot(2,3,5); imshow(norma(obraz_NEW)/256);
%                     title('Reconstruction'); xlabel('Without Mean Face');
%                     subplot(2,3,6); imshow(norma(obraz_NEW+MEAN_FACE)/256);
%                     
%                     title(['Used  ', num2str(j), '  EigenFaces']);
%                     xlabel('With Mean Face');
%                     
%                  pause(.1);    
%                 end;
%               pause
%     end;
      
  
% ����� ���������               