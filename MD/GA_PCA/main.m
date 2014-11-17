%------------ Исходные параметры ------------------------------------------
PATH = 'D:\Education\SPbETU\MD\EvoFIT\GA\БАЗЫ ДЛЯ ТЕСТОВ\';
K = 1;
L = 20;
p = 20;
ORIG_FACE_PATH = 'D:\Education\SPbETU\MD\EvoFIT\GA\БАЗЫ ДЛЯ ТЕСТОВ\Base_Sketch\17.jpg';
RESULT_PATH = 'D:\Education\SPbETU\MD\EvoFIT\GA\ОТЧЕТЫ\RESULT_17.11.14\';
%------------ Инициализация класса ----------------------------------------
global gpfm;
gpfm = GA_PCA_FACE_MORPFER(PATH, K, L, p, ORIG_FACE_PATH);
%------------ Задание опций алгоритма--------------------------------------
options = gaoptimset('PopulationType', 'doubleVector',...
    'InitialPopulation', gpfm.RED,...
    'CrossoverFraction', 0.5,...
    'PopulationSize', L,...
    'MutationFcn',{@mutationgaussian,2, 1},...
    'OutputFcns',@plotOutputs);
%------------ Выполнение --------------------------------------------------
[x, fval] = ga(@computeFitness, p, options);
%--------------------------------------------------------------------------
% Вывод результата
figure(3); clf; 
obraz_REC=gpfm.INV_A_KLT * x.'; 
obraz_NEW=norma(reshape(obraz_REC,[gpfm.ROW,gpfm.COL]));
subplot(1,2,1); imshow(gpfm.ORIG_FACE/256);
title(['ORIGINAL ', 'MAX BASE SSIM = ', num2str(max(gpfm.SSIM_HISTORY(1:gpfm.K*gpfm.L)))]);
subplot(1,2,2); imshow(norma(obraz_NEW+gpfm.MEAN_FACE)/256);
title(['Generated sketch', ' SSIM = ', num2str(max(gpfm.SSIM_HISTORY))]);
%--------------------------------------------------------------------------
name = [RESULT_PATH, 'SSIM_', num2str(max(gpfm.SSIM_HISTORY)), '.jpg'];
imwrite(reshape(gpfm.INV_A_KLT * x.',[gpfm.ROW,gpfm.COL]), name, 'jpg');