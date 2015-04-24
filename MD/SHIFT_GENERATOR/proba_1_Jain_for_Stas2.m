%%% G. Kukharev
 clear all; 
 clc;
 LL1='/Users/Valmont/Development/Repo/GitHub/ETU/MD/Experiments/4_Mirror_Face_Sketch/';
 LL2='/Users/Valmont/Development/Repo/GitHub/ETU/MD/Experiments/4_Mirror_Face_Sketch/SHIFT_BASE_SKETCH/';
%------ for ssim_index ------
K=[0.01 0.03];
L=255; window = ones(8); 
%------------------------------
          
          NUM=1; KT_ALL=[];
          NUM_FACES = 20;
          ROW=4; COL=5;
       %--------------------------
delta=15;   
             SIM1=0;  
             
              r1=[LL1 'sketch.jpg']; r2=[LL1 'sketch.jpg']; 
              
              ORIGINAL = imread(r1);
              ORIGINAL=norma(double(ORIGINAL)); %1.5*double
              obraz = imread(r2);
 
 
             [M,N,q]=size(obraz);
             if q>1, obraz=rgb2gray(obraz); end;
             %obraz_Input=obraz;
             %obraz_Input = fliplr(obraz);
             obraz_Input = double(fliplr((obraz))) + 50*rands(M,N); 
             SHIFT=zeros(M,N,ROW,COL);
              figure(1);
              subplot(121); imshow(obraz_Input); title('ORIGINAL');
              xlabel(num2str([M,N]));
              
            takt=0;row=0;col=0;
           for kt=1:NUM_FACES    
               takt=takt+1;
               row=fix((takt-1)/COL)+1;
               col=takt-(row-1)*COL;
               if kt==1, obraz=norma(double(obraz_Input))/255;
                       kt1=0; kt2=0; kt3=0; 
                       Shift=obraz;
                       SHIFT(:,:,row,1)=Shift;  
               else 
                 kt1=(fix(rand*delta)+1).*sign(randn); 
                 kt2=(fix(rand*delta)+1).*sign(randn);
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
                             
                             SHIFT(:,:,row,col)=Shift;       
                end;        

              %!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! и пользовать для сравнения
%                    subplot(122); imshow(Shift); 
%                    title(['Shift = ', num2str([kt1 kt2 kt3 ])]);
%                    mssim1 = ssim_index(ORIGINAL, norma(Shift),K,window,L); %, K, window, L
%                    xlabel(['Index Sim = ',num2str(mssim1)]);
%                    SIM1(kt)=mssim1;

                  pause(.05);
           end;        
                 D=0; D1=0;
                 for row=1:ROW 
                     for col=1:COL 
                         if col==1 D1=SHIFT(:,:,row,1); else  D1=[D1 SHIFT(:,:,row,col)];   end;
                     end;
                     if row==1 D=D1; else D=[D; D1]; end;
                 end;
                   
              figure(2); clf; subplot(111); imshow(D); 
              title('Forensic Shift Sketch');  
              figure(3); clf; subplot(121); plot(SIM1,'r'); grid; 
              title('Sim: Original/Shift(r) ');

% exporting to base
counter = 0;
for row = 1 : ROW
    for col = 1 : COL
        counter = counter + 1;
       imwrite(SHIFT(:,:,row,col),[LL2 num2str(counter) '.jpg'], 'jpg');
    end;
end;
%figure(4); plot( KT_ALL); grid;  figure(2); 