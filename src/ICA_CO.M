%% Set 'readChannelID' to the channel ID of the channel to read from. 
% Also, assign the read field ID to 'fieldID1'. 
readChannelID = 1226416;
fieldCO = 2;

% Channel Read API Key
% If your channel is private, then enter the read API
% Key between the '' below:
readAPIKey = '';

%% Leer datos
data = thingSpeakRead(readChannelID,'Field',fieldCO, ...
    'dateRange', [datetime('today') datetime('tomorrow')], ...
    'ReadKey',readAPIKey);
COData = data(:,1);

% Calculo promedio de ppm a microgramos/m³
microCO = mean(COData) * 28,01 * (1000 / 24.5);

% Calculo máximo de ppm a microgramos/m³
maxCO = max(COData) * 28,01 * (1000 / 24.5);

%% Intervalos y máximos
colorCO = 'green';
if microCO > 5000
    colorCO = 'yellow';
    if microCO > 10000
        colorCO = 'red';
        if microCO > 15000
            colorCO = 'black';
        end
    end
end
if maxCO > 10000
    colorCO = 'black';
end

% Gráfica CO
bar([microCO maxCO], colorCO);
text(1,microCO,sprintf('%0.0fµg/m³', microCO),...
    'HorizontalAlignment','center',...
    'VerticalAlignment','bottom');
text(2,maxCO,sprintf('%0.0fµg/m³', maxCO),...
    'HorizontalAlignment','center',...
    'VerticalAlignment','bottom');
title('Índice de calidad del aire (CO)');
ylabel('Rango (µg/m³)');
ylim([0 20000]);
yticks([0 5000 10000 15000 20000]);
yticklabels({'0', 'Buena(5000)', 'Admisible(10000)',...
    'Mala(15000)', ' Muy mala(20000)'});
ytickangle(45);
xticklabels({'Promedio', 'Máximo'});
grid on;