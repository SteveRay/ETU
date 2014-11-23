%------------ Исходные параметры ------------------------------------------
PATH = 'D:\Education\SPbETU\MD\EvoFIT\GA\Sketch_generator\Generated_Base\';
K = 1;
L = 19;
p = 19;
ORIG_FACE_PATH = 'D:\Education\SPbETU\MD\EvoFIT\GA\Sketch_generator\5.jpg';
RESULT_PATH = 'D:\Education\SPbETU\MD\EvoFIT\GA\ОТЧЕТЫ\RESULT_21.11.14_no mean_mutation_exp\';
%------------ Инициализация класса ----------------------------------------
global gpfm;
gpfm = GA_PCA_FACE_MORPFER(PATH, K, L, p, ORIG_FACE_PATH);
%------------ Задание опций алгоритма--------------------------------------
options = gaoptimset('PopulationType', 'doubleVector',...
    'InitialPopulation', gpfm.RED,...
    'CrossoverFraction', 0.8,...
    'PopulationSize', L,...
    'MutationFcn', {@mutationuniform, 0.01},...
    'OutputFcns',@plotOutputs);
    %'MutationFcn',{@mutationgaussian,2, 1},...
%------------ Выполнение --------------------------------------------------
[x, fval] = ga(@computeFitness, p, options);
%--------------------------------------------------------------------------
% Вывод результата
figure(3); clf; 
obraz_REC=gpfm.INV_A_KLT * x.'; 
obraz_NEW=reshape(obraz_REC,[gpfm.ROW,gpfm.COL]);
sketch = uint8(obraz_NEW);

subplot(1,2,1); imshow(uint8(gpfm.ORIG_FACE));
title(['ORIGINAL ', 'MAX BASE SSIM = ', num2str(max(gpfm.SSIM_HISTORY(1:gpfm.K*gpfm.L)))]);
subplot(1,2,2); imshow(sketch);
title(['Generated sketch', ' SSIM = ', num2str(max(gpfm.SSIM_HISTORY))]);
%--------------------------------------------------------------------------
name = [RESULT_PATH, 'SSIM_', num2str(max(gpfm.SSIM_HISTORY)), '.jpg'];
imwrite(sketch, name, 'jpg');