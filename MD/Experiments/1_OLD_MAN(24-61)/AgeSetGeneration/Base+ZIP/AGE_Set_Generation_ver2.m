clear all;
clc; clf;
 %LL1='D:\Data_Base\Base_AGE\Base_AGE_G\S2\';
 LL1='C:\Users\Steve Ray\AppData\Roaming\Skype\My Skype Received Files\Base+ZIP\Base+ZIP\Base_AGE_1\S2\';
%----------------------
  Par=20;        
       HB = fspecial('disk',Par);  % ''  average 

    figure(1);clf;          
       for  kk=1:39
    
               %-- Чтение контрольного образа ---
               r=[LL1  num2str(kk) '.jpg'];  
                 obraz1 = imread(r); 
                  obraz1=imresize(obraz1,2);
                   
                    subplot(131); imshow(obraz1);
                      title(['Face = ',num2str(kk)]);
                         xlabel(['Age: ' num2str(25+kk) ' years'])
                           [M,N,q]=size(obraz1);
 
% figure(2); clf;
               photo=obraz1;
               photo1=photo;                                                              
%                   subplot(241); imshow(photo); 
                    
                         photo=double(photo)/255; 
                           % --- Blur filtracja ---- 
                        OBCon=imfilter(photo,HB,'replicate'); 
%                      subplot(242); imshow(OBCon);title('1');
%                    title('(2) Blur for Input Photo');
                OBCon2=OBCon-photo;
%               subplot(243);imshow(OBCon2);title('(3) Result:(2)-(1)');
                OBtmp=1-OBCon2;
                   mmm=mean2(OBtmp);
                      Kontury=(OBtmp-mmm)*7+mmm; 
%                         subplot(244); 
%                           imshow(Kontury);title('(4) Contour'); 
                              %-- Creating hair --------   
                                 Hair=2*photo;     
%                                subplot(245); imshow(Hair);title('(5) Hair')        
                             Whole=Kontury.*Hair;
                           mmm=mean2(Whole);
                        Whole2=(Whole-mmm)*9+mmm;  
%                       subplot(246);imshow(Whole);title('(6) Sketch Color');
                   Whole_GRAY=rgb2gray(Whole);
%                  subplot(247);imshow(Whole_GRAY);title('(7) Sketch Gray');     
        %-----------------
          subplot(132); imshow(Whole_GRAY); title('Sketch Gray');  
          [Ix Iy]=prewitt(Whole_GRAY);  %sobel
          subplot(133); imshow(Ix);
  
                         pause(.1);
       end;
