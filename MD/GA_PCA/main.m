%------------ �������� ��������� ------------------------------------------
% ���� � ��������� ���� ��� (������ ���������)
PATH = '/Users/Valmont/Development/Repo/GitHub/ETU/MD/Experiments/4_Mirror_Face_Sketch/SHIFT_BASE_SKETCH/';
K = 1;  % ���-�� ������� (��������� �� ����������� ��� ������ ��������)
L = 20; % ������ ���������
p = 20; % ���-�� ������� ��������� (PCA_KL)
% ���� � �������
ORIG_FACE_PATH = '/Users/Valmont/Development/Repo/GitHub/ETU/MD/Experiments/4_Mirror_Face_Sketch/orig.jpg';
% ���� ��� ���������� ����������
RESULT_PATH = '/Users/Valmont/Development/Repo/GitHub/ETU/MD/Experiments/4_Mirror_Face_Sketch/GA_RESULT/';
%------------ ������������� ������ ----------------------------------------
global gpfm;
gpfm = GA_PCA_FACE_MORPFER(PATH, K, L, p, ORIG_FACE_PATH);
%------------ ������� ����� ���������--------------------------------------
% �������� ������� ��� ��������� ����������: 
%       'MutationFcn', {@mutationgaussian, 1, 1},...
%       'MutationFcn', {@mutationuniform, 0.05},...
% ������� ��������: 5 ��������� (�������� 'StallGenLimit') �� �����������
% ������ ������������ �������� ��������� 1e-5 (�������� 'TolFun').
options = gaoptimset('PopulationType', 'doubleVector',...
    'InitialPopulation', gpfm.RED,...
    'CrossoverFraction', 0.8,...
    'PopulationSize', L,...
    'MutationFcn', {@mutationuniform, 0.05},...
    'StallGenLimit', 5,...
    'TolFun', 1e-5,...
    'OutputFcns',@plotOutputs);
%------------ ���������� --------------------------------------------------
[x, fval] = ga(@computeFitness, p, options);
%--------------------------------------------------------------------------
% ����� ����������
figure(3); clf; 
obraz_REC=gpfm.INV_A_KLT * x.'; 
obraz_NEW=reshape(obraz_REC,[gpfm.ROW,gpfm.COL]);
sketch = uint8(obraz_NEW+gpfm.MEAN_FACE);

subplot(1,2,1); imshow(uint8(gpfm.ORIG_FACE));
title(['ORIGINAL ', 'MAX BASE SSIM = ', num2str(max(gpfm.SSIM_HISTORY(1:gpfm.K*gpfm.L)))]);
subplot(1,2,2); imshow(sketch);
title(['Generated sketch', ' SSIM = ', num2str(max(gpfm.SSIM_HISTORY))]);
%---------------------- ���������� ���������� -----------------------------
name = [RESULT_PATH, 'SSIM_', num2str(max(gpfm.SSIM_HISTORY)), '.jpg'];
imwrite(sketch, name, 'jpg');