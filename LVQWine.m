%%Sie� LVQ rozpoznaj�ca jako�� wina

clear;
format compact;
nntwarn off;
load wine_red;

S1 = 170;  %domy�lne warto�ci parametr�w
ep = 150;
learningRate = 0.02;
reinit = 1;
 
while(1)
    %% Podanie liczby neuron�w w ukrytej warstwie

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

    %% Podanie maksymalnej wartosci b��du

    temp = input(['Input lr: [',num2str(learningRate),']: ']);
    if ~isempty(temp) 
        learningRate = temp;
        clear network;
    end 

    %% Czy reinicjalizowa� sie�

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

    %% Posta� wektorowa, obliczenie sk�adu procentowego klas

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

    %% Symulacja i konwersja wynik�w do formatu pe�nej macierzy

    Y = sim(network, Pn);
    Yc = vec2ind(Y);

    %% Por�wnanie klas. Policzenie b��dnych klasyfikacji

    results = [T' Yc' (T - Yc)' (abs(T - Yc) > 0.5)'];

    %% Wy�wietlenie finalnej sprawno�ci sieci 

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