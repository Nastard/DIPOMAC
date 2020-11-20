%% Set 'readChannelID' to the channel ID of the channel to read from. 
% Also, assign the read field ID to 'fieldID1'. 
readChannelID = 1226417;
field = 1;

% Channel Read API Key
% If your channel is private, then enter the read API
% Key between the '' below:
readAPIKey = '';

%% Leer datos
data = thingSpeakRead(readChannelID,'Field',field, ...
    'dateRange', [datetime('today') datetime('tomorrow')], ...
    'ReadKey',readAPIKey);
Data = data(:,1);

% Calculo promedio
pro = mean(Data);

% Calculo máximo
max = max(Data);
min = min(Data);

% Gráfica CO
bar([pro max min], 'yellow');
text(1,pro,sprintf('%0.2fºC', pro),...
    'HorizontalAlignment','center',...
    'VerticalAlignment','bottom');
text(2,max,sprintf('%0.2fºC', max),...
    'HorizontalAlignment','center',...
    'VerticalAlignment','bottom');
text(3,min,sprintf('%0.2fºC', min),...
    'HorizontalAlignment','center',...
    'VerticalAlignment','bottom');
title('Media y máxima temperatura');
ylabel('Rango (ºC)');
ylim([-10 50]);
xticklabels({'Promedio', 'Máximo', 'Mínimo'});
grid on;