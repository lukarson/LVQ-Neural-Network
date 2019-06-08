clear;
format compact;
nntwarn off;
load wine_red;

ep = 100;
bestPerformance = 0;
i=1;
tic();
for S1=20:50:270
    for learningRate=0.01:0.002:0.025
        
        Tvec = ind2vec(Ts);          
        percentage=(histc(T,1:3)/length(T));           
        siec = newlvq(Pns,S1,percentage,learningRate);
        siec.trainParam.epochs = ep;
        siec = train(siec, Pns, Tvec);
        Y = sim(siec, Pn);
        Yc = vec2ind(Y);
        performance=(1-sum(abs(T-Yc)>0)/length(Pn))*100;
        
        if (performance > bestPerformance)
            bestPerformance = performance;
            bestYc = Yc;
        end
        
        tab_S1(1,i)=S1;
        tab_lr(1,i)=learningRate;
        tab_pf(1,i)=performance;
        i=i+1;
      
        sprintf('Hidden neurons: %d \nEpochs: %d\nLearning rate: %d\nPerformance: %d\n', S1, ep, learningRate, performance) 
        
    end
end
time = toc();
count = 1:length(tab_S1);
Result = [count; tab_S1; tab_lr; tab_pf];

fileID = fopen('results.txt','w');
fprintf(fileID, 'Learning results for %d epochs [S1, lr, perf.]:\n\n', ep);
fprintf(fileID, 'Training %d: %g, %g, %g%%\n', Result);
fprintf(fileID, '\nTotal time: %fs (%f h)\nBest performance: %g%%',time, time/3600, bestPerformance);
fclose(fileID);
%plot([1:length(T)], T, [1:length(bestYc)], bestYc, 'r*')


