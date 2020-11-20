%% Set 'readChannelID' to the channel ID of the channel to read from. 
% Also, assign the read field ID to 'fieldID1'. 
readChannelID = 1226417;
field = 3;

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

% Gráfica CO
bar([pro max], 'red');
text(1,pro,sprintf('%0.2fPa', pro),...
    'HorizontalAlignment','center',...
    'VerticalAlignment','bottom');
text(2,max,sprintf('%0.2fPa', max),...
    'HorizontalAlignment','center',...
    'VerticalAlignment','bottom');
title('Media y máxima presión atmosférica');
ylabel('Rango (Pa)');
ylim([85000 110000]);
xticklabels({'Promedio', 'Máximo'});
grid on;