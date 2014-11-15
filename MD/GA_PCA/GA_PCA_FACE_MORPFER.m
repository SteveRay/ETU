% ������ �.�.,  2014�. 

classdef GA_PCA_FACE_MORPFER < handle
    % ����� ��������� ���� ��������� ������, ������� ���������� �
    % ���� ���������� ������������� ���������, � ��� �� ��� �������� ���� 
    % ������������� ����������� �� ������ ��������. 
    % �������� �������:
    % - � ������������ ������ ���������� ���������� ������� ��������� 
    % ��������� ���� ��� (PCA).
    % - ������� computeFitness() ������������ ga ��� ���������� ���������� 
    % ������������.
    % - eliminateBackground() ������� ������������� �������� �����������, �
    % ������� ���������� �������� �������� ��������� �� ������� ���������
    % � ��������� "����� ����".
    % ������������ ��������� ������� �������: norma(), PCA_KL(), ssim_index().
    
    % ���������� ������
    properties (SetAccess = public)
        ROW;
        COL;
        K;
        L;
        p;
        a;
        A_KLT;
        INV_A_KLT;
        RED;
        ORIG_FACE;
        INITIAL_FACES_DATA;
        MEAN_FACE;
        SSIM_HISTORY;
    end
    
    methods
        % ����� - �����������, ���������� ��������������������� ���������
        % ������ GA_PCA_FACE_MORPFER, ������� ���������:
        % @PATH - ���� � ���� ��� ��� ��������� ���������.
        % ���������� � ����������� ����: 
        %   ������ �������� � ����� � ������ � ������� 'dd', ������� � '01'
        %   ����������� � ������� ������� .jpg, ����� � ������� 'd',
        %                                      ������� � '1'.
        % @K - ���������� ������� ��� ���������.
        % @L - ���������� ������� � ������ ������.
        % @p - ���������� ���������� ����������� �����:
        %                "p" ������ ���� ������ [FACE](ROW * COL).
        % @a - �������� ���� �������� � ��������� (0; 1].
        % @ORIG_FACE_PATH - ������ ���� � ����� - �������.
        function GPFM = GA_PCA_FACE_MORPFER(PATH, K, L, p, a, ORIG_FACE_PATH)
            GPFM.K = K;
            GPFM.L = L;
            GPFM.p = p; 
            GPFM.a = a;
            image = double(imread(ORIG_FACE_PATH));
            [GPFM.ROW, GPFM.COL] = size(image);
            GPFM.ORIG_FACE = norma(image);
            GPFM.INITIAL_FACES_DATA = [];
            % ���������� ���� ��� ��� �������� ��������� ���������    
            DATA = 0; GPFM.MEAN_FACE = 0;
            for k = 1 : K
                for l = 1 : L        
                    if k <= 9  
                        path_k = ['0', num2str(k)]; 
                    else
                        path_k = num2str(k);
                    end;
                    path_l = num2str(l); 
                    path = [PATH path_k '\' path_l '.jpg'];
                    
                    image = imread(path); 
                    image = double(image); 
                    image = norma(image); 
                    DATA = DATA + image;
                    
                    GPFM.INITIAL_FACES_DATA = [GPFM.INITIAL_FACES_DATA image(:)];
                end;
                DATA = DATA / L;
                GPFM.MEAN_FACE = GPFM.MEAN_FACE + DATA;
            end;
            GPFM.MEAN_FACE = GPFM.MEAN_FACE / K;
            % ��������� ���� ���, ���������� �������� ����
            for k = 1 : K
                GPFM.INITIAL_FACES_DATA(:, k) = GPFM.INITIAL_FACES_DATA(:, k) - GPFM.MEAN_FACE(:);
                GPFM.INITIAL_FACES_DATA(:, k) = GPFM.INITIAL_FACES_DATA(:, k) / norm(GPFM.INITIAL_FACES_DATA(:, k));
            end
            % ���������� ������� �������� ������ � ����� ������������.
            % ��������� ���������������, ��� ������ �������� ������ � ga.
            % ������� ��� �������� ��������� ��������� � ga �������:
            %   row - population size (���������� ��������� ���)
            %   col - number of params (���������� ����������� ���������� 
            %                           � ������� ����).
            [GPFM.A_KLT, ~, ~] = PCA_KL(GPFM.INITIAL_FACES_DATA, p);
            GPFM.INV_A_KLT =  GPFM.A_KLT().';
            GPFM.RED = (GPFM.A_KLT * GPFM.INITIAL_FACES_DATA).';
        end
        
        % ������� ������ ������� ����������� ��� GA.
        % ������������ ssim ������� ����������� ����������� � ����������
        % ����������, � ��� �� ������� ����� ����������.
        function fitness = computeFitness(GPFM, FACE_PROJECTION)
            % ������������ ��������� ��������� ��� ������ ������:
            % @INV_A_KLT - ��������������� ������� �������������� ��������-����� (KLT);
            % @ROW, COL - �������� ���������� �����������;
            % @ORIG_FACE - ��������� �����������;
            RECONSTRUCTED_DATA = GPFM.INV_A_KLT * FACE_PROJECTION.';
            RECONSTRUCTED_IMAGE = norma(reshape(RECONSTRUCTED_DATA,[GPFM.ROW,GPFM.COL]));
            % ssim_index ���������� 1 ��� 100% �������. ������� fitness ���
            % GA ��� ������ ������� ������� �������� ������ 0, ��� ���� 
            % �������� ������ ���������� � ��������� [0; +inf). ���������
            % ���� ���� ��� ���������� ����������.
            ssim = ssim_index(GPFM.ORIG_FACE, norma(RECONSTRUCTED_IMAGE + GPFM.MEAN_FACE));
            GPFM.pushSSIM(ssim);
            fitness = abs(ssim - 1);
        end
        
        % �������� �������� ssim ������� � �����.
        function GPFM = pushSSIM(GPFM, value)
            GPFM.SSIM_HISTORY(end + 1) = value;
        end
    end   
end
