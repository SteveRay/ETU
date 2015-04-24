%------------ Исходные параметры ------------------------------------------
% Путь к начальной базе лиц (первая популяция)
PATH = '/Users/Valmont/Development/Repo/GitHub/ETU/MD/Experiments/4_Mirror_Face_Sketch/SHIFT_BASE_SKETCH/';
K = 1;  % кол-во классов (поведение не проверялось при другом значении)
L = 20; % размер популяции
p = 20; % кол-во главных компонент (PCA_KL)
% Путь к эталону
ORIG_FACE_PATH = '/Users/Valmont/Development/Repo/GitHub/ETU/MD/Experiments/4_Mirror_Face_Sketch/orig.jpg';
% Путь для сохранения результата
RESULT_PATH = '/Users/Valmont/Development/Repo/GitHub/ETU/MD/Experiments/4_Mirror_Face_Sketch/GA_RESULT/';
%------------ Инициализация класса ----------------------------------------
global gpfm;
gpfm = GA_PCA_FACE_MORPFER(PATH, K, L, p, ORIG_FACE_PATH);
%------------ Задание опций алгоритма--------------------------------------
% Варианты мутации для улучшения результата: 
%       'MutationFcn', {@mutationgaussian, 1, 1},...
%       'MutationFcn', {@mutationuniform, 0.05},...
% Условие останова: 5 поколений (параметр 'StallGenLimit') не превосходят
% порога минимального среднего изменения 1e-5 (параметр 'TolFun').
options = gaoptimset('PopulationType', 'doubleVector',...
    'InitialPopulation', gpfm.RED,...
    'CrossoverFraction', 0.8,...
    'PopulationSize', L,...
    'MutationFcn', {@mutationuniform, 0.05},...
    'StallGenLimit', 5,...
    'TolFun', 1e-5,...
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
%---------------------- Сохранение результата -----------------------------
name = [RESULT_PATH, 'SSIM_', num2str(max(gpfm.SSIM_HISTORY)), '.jpg'];
imwrite(sketch, name, 'jpg');