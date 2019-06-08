%%Siec LVQ rozpoznajaca jakosc wina

clear;
format compact;
nntwarn off;
load wine_red;

S1 = 170;  %domyslne wartosci parametrow
ep = 150;
learningRate = 0.02;
reinit = 1;
 
while(1)
    %% Podanie liczby neuronow w ukrytej warstwie

    temp = input(['Input S1 [',int2str(S1),']: ']);
    if ~isempty(temp) 
        S1 = temp;
        clear network;
    end 

    %% Podanie liczby epok

    temp = input(['Input epochs [',int2str(ep),']: ']);
    if ~isempty(temp) 
        ep = temp;
        clear network;
    end 

    %% Podanie maksymalnej wartosci bledu

    temp = input(['Input lr: [',num2str(learningRate),']: ']);
    if ~isempty(temp) 
        learningRate = temp;
        clear network;
    end 

    %% Czy reinicjalizowac siec

    if(exist('network','var'))
        retry = input('Reinitialize? (T/N): ', 's'); 
        if  (isempty(retry) || 't' == lower(retry))
            reinit = 1;
        else
            reinit = 0;   
        end
    else
        reinit = 1;
    end 

    %% Postac wektorowa, obliczenie skladu procentowego klas

    Tvec = ind2vec(Ts);                         
    percentage = (histc(Ts, 1:6) / length(Ts)); 

    %% Inicjalizacja sieci

    if(reinit)
        network = newlvq(Pn, S1, percentage, learningRate);
        reinit = 0;
        sprintf('Network reinitialized...')
    end

    %% Ustawienie liczby epok i uczenie sieci

    network.trainParam.epochs = ep;
    network = train(network, Pns, Tvec);

    %% Symulacja i konwersja wyników do formatu pelnej macierzy

    Y = sim(network, Pn);
    Yc = vec2ind(Y);

    %% Porownanie klas. Policzenie blednych klasyfikacji

    results = [T' Yc' (T - Yc)' (abs(T - Yc) > 0.5)'];

    %% Wyswietlenie finalnej sprawnosci sieci 

    performance = (1 - sum(abs(T - Yc) > 0.5) / length(Pn))*100;
    sprintf('Hidden neurons: %d \nEpochs: %d\nLearning rate: %d\nPerformance: %d\n', S1, ep, learningRate, performance) 

    %% Interakcja - pytanie o kolejne uruchomienie

        retry = input('Again? (T/N): ', 's'); 
    if ~(isempty(retry) || 't' == lower(retry))
        clear temp retry reinit Tvec percentage;
        save WineNetworkData;
        break;
    end

end
