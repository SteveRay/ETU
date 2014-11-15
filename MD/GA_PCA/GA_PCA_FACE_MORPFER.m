% Райцин С.Б.,  2014г. 

classdef GA_PCA_FACE_MORPFER < handle
    % Класс выполняет роль хранилища данных, которые необходимы в
    % ходе выполнения генетического алгоритма, а так же для хранения всех 
    % промежуточных результатов на каждой итерации. 
    % Основные функции:
    % - В конструкторе класса происходит вычисление главных компонент 
    % начальной базы лиц (PCA).
    % - Функция computeFitness() используется ga для вычисления оценочного 
    % коэффициента.
    % Используются следующие внешние функции: norma(), PCA_KL(), ssim_index().
    
    % Переменные класса
    properties (SetAccess = public)
        ROW;
        COL;
        K;
        L;
        p;
        A_KLT;
        INV_A_KLT;
        RED;
        ORIG_FACE;
        INITIAL_FACES_DATA;
        MEAN_FACE;
        SSIM_HISTORY;
    end
    
    methods
        % Метод - конструктор, возвращает проинициализированный экземпляр
        % класса GA_PCA_FACE_MORPFER, входные параметры:
        % @PATH - путь к базе лиц для начальной популяции.
        % Требования к содержимому базы: 
        %   классы вынесены в папки с именем в формате 'dd', начиная с '01'
        %   изображения в классах формата .jpg, имена в формате 'd',
        %                                      начиная с '1'.
        % @K - количество классов для обработки.
        % @L - количество образов в каждом классе.
        % @p - количество наибольших собственных чисел:
        %                "p" должно быть меньше [FACE](ROW * COL).
        % @ORIG_FACE_PATH - полный путь к файлу - эталону.
        function GPFM = GA_PCA_FACE_MORPFER(PATH, K, L, p, ORIG_FACE_PATH)
            GPFM.K = K;
            GPFM.L = L;
            GPFM.p = p; 
            image = double(imread(ORIG_FACE_PATH));
            [GPFM.ROW, GPFM.COL] = size(image);
           % GPFM.ORIG_FACE = norma(image);
            GPFM.ORIG_FACE = image;
            GPFM.INITIAL_FACES_DATA = [];
            % Заполнение базы лиц для создания начальной популяции    
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
                   % image = norma(image); 
                    DATA = DATA + image;
                    GPFM.INITIAL_FACES_DATA = [GPFM.INITIAL_FACES_DATA image(:)];
                end;
                DATA = DATA / L;
                GPFM.MEAN_FACE = GPFM.MEAN_FACE + DATA;
            end;
            GPFM.MEAN_FACE = GPFM.MEAN_FACE / K;
            % Нормируем базу лиц, вычитанием среднего лица
            for k = 1 : K
                for l = 1 : L                  
                GPFM.INITIAL_FACES_DATA(:, k*l) = GPFM.INITIAL_FACES_DATA(:, k*l) - GPFM.MEAN_FACE(:);                
%                 GPFM.INITIAL_FACES_DATA(:, k*l) = GPFM.INITIAL_FACES_DATA(:, k*l) / norm(GPFM.INITIAL_FACES_DATA(:, k*l));
                end
            end
            % Вычисление матрицы проекции данных в новое пространство.
            % Результат транспонируется, для прямой передачи данных в ga.
            % Правила для передачи начальной популяции в ga функцию:
            %   row - population size (количество различных лиц)
            %   col - number of params (количество независимых параметров 
            %                           у каждого лица).
            [GPFM.A_KLT, ~, ~] = PCA_KL(GPFM.INITIAL_FACES_DATA, p);
            GPFM.INV_A_KLT =  GPFM.A_KLT().';       
            GPFM.RED = (GPFM.A_KLT * GPFM.INITIAL_FACES_DATA).';
        end
        
        % Функция оценки подобия изображения для GA.
        % Сравнивается ssim подобие полученного изображения с предыдущей
        % популяцией, а так же разница между оригиналом.
        function fitness = computeFitness(GPFM, FACE_PROJECTION)
            % Используемые начальные параметры для вызова метода:
            % @INV_A_KLT - инвертированная матрица преобразования Карунена-Лоэва (KLT);
            % @ROW, COL - исходное разрешение изображения;
            % @ORIG_FACE - эталонное изображение;
            RECONSTRUCTED_DATA = GPFM.INV_A_KLT * FACE_PROJECTION.';
            RECONSTRUCTED_IMAGE = reshape(RECONSTRUCTED_DATA,[GPFM.ROW,GPFM.COL]);
            % ssim_index возвращает 1 при 100% подобии. Функция fitness для
            % GA при полном подобии требует значение равное 0, при этом 
            % значение должно находиться в интервале [0; +inf). Учитываем
            % этот факт при вычислении результата.
%               figure(11); clf;
%               imshow(norma(RECONSTRUCTED_IMAGE+GPFM.MEAN_FACE)/255);
%               disp(RECONSTRUCTED_IMAGE);
%               pause;
%              imshow(RECONSTRUCTED_IMAGE + GPFM.MEAN_FACE);
%              pause;
            ssim = ssim_index(GPFM.ORIG_FACE, (RECONSTRUCTED_IMAGE + GPFM.MEAN_FACE));
            GPFM.pushSSIM(ssim);
            fitness = abs(ssim - 1);
        end
        
        % Внесение значения ssim индекса в буфер.
        function GPFM = pushSSIM(GPFM, value)
            GPFM.SSIM_HISTORY(end + 1) = value;
        end
    end   
end

