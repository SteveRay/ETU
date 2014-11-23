%------------ Исходные параметры ------------------------------------------
PATH = 'D:\Education\SPbETU\MD\EvoFIT\GA\БАЗЫ ДЛЯ ТЕСТОВ\';
K = 1;
L = 20;
p = 20;
ORIG_FACE_PATH = 'D:\Education\SPbETU\MD\EvoFIT\GA\БАЗЫ ДЛЯ ТЕСТОВ\Base_Sketch\01.jpg';
RESULT_PATH = 'D:\Education\SPbETU\MD\EvoFIT\GA\ОТЧЕТЫ\RESULT_17.11.14\';
%------------ Инициализация класса ----------------------------------------
global gpfm;
gpfm = GA_PCA_FACE_MORPFER(PATH, K, L, p, ORIG_FACE_PATH);
%------------ Задание опций алгоритма--------------------------------------
options = gaoptimset('PopulationType', 'doubleVector',...
    'InitialPopulation', gpfm.RED,...
    'CrossoverFraction', 0,...
    'PopulationSize', L,...
    'MutationFcn', {@mutationuniform, 0.01},...
    'OutputFcns',@plotOutputs);
%------------ Выполнение --------------------------------------------------
[x, fval] = ga(@computeFitness, p, options);
%--------------------------------------------------------------------------
% Вывод результата
figure(3); clf; 
obraz_REC=gpfm.INV_A_KLT * x.'; 
obraz_NEW=reshape(obraz_REC,[gpfm.ROW,gpfm.COL]);
sketch = uint8(obraz_NEW+gpfm.MEAN_FACE);

subplot(1,2,1); imshow(uint8(gpfm.ORIG_FACE));
title(['ORIGINAL ', 'MAX BASE SSIM = ', num2str(max(gpfm.SSIM_HISTORY(1:gpfm.K*gpfm.L)))]);
subplot(1,2,2); imshow(sketch);
title(['Generated sketch', ' SSIM = ', num2str(max(gpfm.SSIM_HISTORY))]);
%--------------------------------------------------------------------------
name = [RESULT_PATH, 'SSIM_', num2str(max(gpfm.SSIM_HISTORY)), '.jpg'];
% imwrite(sketch, name, 'jpg');