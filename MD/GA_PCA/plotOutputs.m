function [state, options,optchanged] = plotOutputs(options,state,flag)
    global gpfm
    
%   STATE: A structure containing the following information about the state 
%   of the optimization:
%             Population: Population in the current generation
%                  Score: Scores of the current population
%             Generation: Current generation number
%              StartTime: Time when GA started 
%               StopFlag: String containing the reason for stopping
%              Selection: Indices of individuals selected for elite,
%                         crossover and mutation
%            Expectation: Expectation for selection of individuals
%                   Best: Vector containing the best score in each generation
%        LastImprovement: Generation at which the last improvement in
%                         fitness value occurred
%    LastImprovementTime: Time at which last improvement occurred
%
%   FLAG: Current state in which OutputFcn is called. Possible values are:
%         init: initialization state 
%         iter: iteration state
%    interrupt: intermediate state
%         done: final state

    optchanged = false;

     switch flag
         case 'init'
             disp('Starting the algorithm');
         case {'iter','interrupt'}
            disp('Iterating ...')
         case 'done'
            disp('Performing final task');
        otherwise;
     end
    if ~strcmp(flag, 'done')
        figure(1); clf;  
        for i = 1 : (gpfm.L)
          RECONSTRUCTED_DATA = gpfm.INV_A_KLT * state.Population(i, :).';
          RECONSTRUCTED_IMAGE = norma(reshape(RECONSTRUCTED_DATA,[gpfm.ROW, gpfm.COL]));
          subplot(4,5,i); imshow(norma(RECONSTRUCTED_IMAGE + gpfm.MEAN_FACE)/256); 
          title(num2str(gpfm.SSIM_HISTORY(i*(state.Generation+1))));
        end
        axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
        text(0.5, 1, ['FACES GENERATION ¹', num2str(state.Generation)],'HorizontalAlignment','center','VerticalAlignment', 'top');
        pause;
    end
    if strcmp(flag, 'done')
        figure(2); clf; 
        x = 1:1:((state.Generation+1)*gpfm.L);
        plot(x, gpfm.SSIM_HISTORY);
        title(['BEST SSIM = ', num2str(max(gpfm.SSIM_HISTORY)), '; MAX BASE SSIM = ', num2str(max(gpfm.SSIM_HISTORY(1:20)))]);
        disp(max(gpfm.SSIM_HISTORY));
    end
end
