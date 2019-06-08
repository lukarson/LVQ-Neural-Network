
clear;
format compact;
nntwarn off;
load winequality-red.data; % Domyslnie ladowany zbior jakosci wina

P = winequality_red(:,1:11)'; % P i T dopasowane do danych WineQuality
T = winequality_red(:,12)';   % Rozmiary dla innego zbioru beda sie roznic

% [ [1:11]; min(P'); max(P') ]';

Pn = mapminmax(P);
% plot(T);
% plot(sort(T));

[Ts, ind_Ts] = sort(T);
Pns = zeros(size(Pn));

for i = 1:length(ind_Ts)
    Pns(:,i) = Pn(:, ind_Ts(i));
end

    
    
