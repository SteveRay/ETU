%%% G. Kukharev
 clear all; 
 clc;
% LL1='D:\Ab\0_2014\Face_Sketch_Jain_NEW\';
%------ for ssim_index ------
K=[0.01 0.03];
L=255; window = ones(8); 
%------------------------------
 
            
          
          NUM=1; KT_ALL=[];
         %--------------------------
         SIM_1_ALL=[]; SIM_2_ALL=[];
          SIM_11_ALL=[]; SIM_22_ALL=[];
for ttt=1:5   
   
             SIM1=0; SIM2=0;
             SHIFT1 = []; SHIFT2 = []; SHIFT3 = [];
             MEAN1 = [];  MEAN2 = [];  MEAN3 = [];
             
              
              delta=10;
              ORIGINAL = imread('5a.jpg');
              [M1,N1,q1]=size(ORIGINAL);
              if q1>1, ORIGINAL=rgb2gray(ORIGINAL); end;
              ORIGINAL=norma(double(ORIGINAL))/255; %1.5*double 
              figure(1); clf;
              subplot(231); imshow(ORIGINAL); %'5ab.jpg'
              title('Photo');

               obraz = imread('6.jpg'); % SKETCH
               [M,N,q]=size(obraz);
               if q>1, obraz=rgb2gray(obraz); end;
               obraz_Input=obraz;
               subplot(232); imshow(obraz_Input); %(jj-1)*2+jj
               xlabel(num2str([M,N]));% pause(.1);
       
             SUM=0;
           for kt=1:10    
               if kt==1, obraz=norma(double(obraz_Input))/255;
                          kt1=0; kt2=0; kt3=0; SUM=SUM+obraz; 
                           Shift=obraz; MEAN=obraz;
                             Data_S=zeros(M,N,11); Data_S(:,:,1)=Shift;
                               Data_M=zeros(M,N,11); Data_M(:,:,1)=MEAN;                       
               else 
                 kt1=(fix(rand*delta)+1); %.*sign(randn); 
                 kt2=(fix(rand*delta)+1); %.*sign(randn);
                 kt3=(fix(rand*delta/2)+1).*sign(randn); 
                 KT_ALL=[KT_ALL [kt1; kt2; kt3]];
                                                
                         if kt1>0, obraz1=obraz_Input(kt1:M,:); 
                         else      obraz1=[obraz_Input(1:abs(kt1),:); obraz_Input];
                         end;
                             obraz=imresize(obraz1,[M,N]);
                       
                         if kt2>0, obraz1=obraz(:,kt2:N); 
                         else      obraz1=obraz(:,1:N-abs(kt2));
                         end;
                             obraz=imresize(obraz1,[M,N]); 
                              
                         if kt3>0,obraz=[obraz(:,kt3+1:N) obraz(:,1:kt3)];
                         else     obraz=[obraz(:,N-abs(kt3)+1:N) obraz(:,1:N-abs(kt3))];
                         end;
                             Shift=norma(double(obraz))/255;
                             Data_S(:,:,kt)=Shift;
                             SUM=SUM+Shift;
                             MEAN=SUM/kt;
                             Data_M(:,:,kt)=MEAN;
                             if kt<5, SHIFT1=[SHIFT1 Shift]; 
                                      MEAN1=[MEAN1 MEAN];
                             end;
                             if kt>4 && kt<8, SHIFT2=[SHIFT2 Shift]; 
                                              MEAN2=[MEAN2 MEAN]; 
                             end;            
                             if kt>7, SHIFT3=[SHIFT3 Shift]; 
                                      MEAN3=[MEAN3 MEAN]; 
                             end;            
                             
               end;                     
                            subplot(234); imshow(Shift); %(jj-1)*2+jj+1
                            title(['Shift = ', num2str([kt1 kt2 kt3 ])]);
                mssim1 = ssim_index1(norma(ORIGINAL), norma(Shift)); %, K, window, L
                xlabel(['Index Sim = ',num2str(mssim1)]);
                      SIM1(kt)=mssim1;
                      figure(1); subplot(235); imshow(MEAN);%(jj-1)*2+jj+2
                      title(['Sum for ' num2str(kt) ' Faces']); 
                       mssim2 = ssim_index1(norma(ORIGINAL), norma(MEAN)); %, K, window, L
                xlabel(['Index Sim = ',num2str(mssim2)]);
                 SIM2(kt)=mssim2;
                  pause% (.05);
           end;        
               SHIFT =[SHIFT1;SHIFT2;SHIFT3];
               MEAN =[MEAN1; MEAN2;MEAN3];
               
  
              figure(2); clf; subplot(121); imshow(SHIFT);title('Forensic Shift Sketch'); 
              subplot(122); imshow(MEAN);   title('Forensic MEAN Sketch');
              figure(1); subplot(133);  plot(SIM1,'r'); grid; hold on; plot(SIM2,'b');
              title('Sim: Original/Shift(r) & MEAN(b) Sketch');
 
                    SIM_1_ALL=[SIM_1_ALL; SIM1];
                    SIM_2_ALL=[SIM_2_ALL; SIM2];
  
                    %KT_ALL, [SIM_1_ALL; SIM_2_ALL],
                                
              DATA=Data_S;
               Proga2;  %Method_1D_PCA_for_Sketches;
                 pause; 
                    DATA=Data_M;
                       Proga2; %Method_1D_PCA_for_Sketches
                         pause;
end;
