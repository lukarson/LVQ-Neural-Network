%%Sieæ LVQ rozpoznaj¹ca jakoœæ wina

clear;
format compact;
nntwarn off;
load wine_red;

S1 = 170;  %domyœlne wartoœci parametrów
ep = 150;
learningRate = 0.02;
reinit = 1;
 
while(1)
    %% Podanie liczby neuronów w ukrytej warstwie

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

    %% Podanie maksymalnej wartosci b³êdu

    temp = input(['Input lr: [',num2str(learningRate),']: ']);
    if ~isempty(temp) 
        learningRate = temp;
        clear network;
    end 

    %% Czy reinicjalizowaæ sieæ

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

    %% Postaæ wektorowa, obliczenie sk³adu procentowego klas

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

    %% Symulacja i konwersja wyników do formatu pe³nej macierzy

    Y = sim(network, Pn);
    Yc = vec2ind(Y);

    %% Porównanie klas. Policzenie b³êdnych klasyfikacji

    results = [T' Yc' (T - Yc)' (abs(T - Yc) > 0.5)'];

    %% Wyœwietlenie finalnej sprawnoœci sieci 

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