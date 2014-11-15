%------------ Исходные параметры ------------------------------------------
PATH = 'D:\Education\SPbETU\MD\EvoFIT\GA\База лиц\Faces94\';
K = 1;
L = 20;
p = 20;
a = 1;
ORIG_FACE_PATH = 'D:\Education\SPbETU\MD\EvoFIT\GA\Sketch_generator\001.jpg';
%------------- Инициализация класса ---------------------------------------
global gpfm;
gpfm = GA_PCA_FACE_MORPFER(PATH, K, L, p, a, ORIG_FACE_PATH);
%------------ Задание опций алгоритма--------------------------------------
options = gaoptimset('PopulationType', 'doubleVector',...
    'InitialPopulation', gpfm.RED,...
    'CrossoverFraction', 0.5,...
    'PopulationSize', L,...
    'MutationFcn',{@mutationgaussian,1, 1},...
    'OutputFcns',@plotOutputs);
%------------ Выполнение --------------------------------------------------
[x, fval] = ga(@computeFitness, p, options);
%--------------------------------------------------------------------------
% Вывод результата
figure(3); clf; 
obraz_REC=gpfm.INV_A_KLT * x.'; 
obraz_NEW=norma(reshape(obraz_REC,[gpfm.ROW,gpfm.COL]));
subplot(1,2,1); imshow(gpfm.ORIG_FACE/256);
title('Model face');
subplot(1,2,2); imshow(norma(obraz_NEW+gpfm.MEAN_FACE)/256);
title(['Generated sketch', ' SSIM = ', num2str(max(gpfm.SSIM_HISTORY))]);
