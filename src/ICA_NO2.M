%% Set 'readChannelID' to the channel ID of the channel to read from. 
% Also, assign the read field ID to 'fieldID1'. 
readChannelID = 1226416;
fieldNO2 = 3;

% Channel Read API Key
% If your channel is private, then enter the read API
% Key between the '' below:
readAPIKey = '';

%% Leer datos
data = thingSpeakRead(readChannelID,'Field',fieldNO2, ...
    'dateRange', [datetime('today') datetime('tomorrow')], ...
    'ReadKey',readAPIKey);
NO2Data = data(:,1);

% Calculo promedio de ppm a microgramos/m³
proNO2 = mean(NO2Data) * 28,01 * (1000 / 24.5);

% Calculo máximo de ppm a microgramos/m³
maxNO2 = max(NO2Data) * 28,01 * (1000 / 24.5);

%% Intervalos y máximos
colorNO2 = 'green';
if proNO2 > 100
    colorNO2 = 'yellow';
    if proNO2 > 200
        colorNO2 = 'red';
        if proNO2 > 300
            colorNO2 = 'black';
        end
    end
end
if maxNO2 > 200
    colorNO2 = 'black';
end

% Gráfica NO2
bar([proNO2 maxNO2], colorNO2);
text(1,proNO2,sprintf('%0.2fµg/m³', proNO2),...
    'HorizontalAlignment','center',...
    'VerticalAlignment','bottom');
text(2,maxNO2,sprintf('%0.2fµg/m³', maxNO2),...
    'HorizontalAlignment','center',...
    'VerticalAlignment','bottom');
title('Índice de calidad del aire (NO2)');
ylabel('Rango (µg/m³)');
ylim([0 400]);
yticks([0 100 200 300 400]);
yticklabels({'0', 'Buena(100)', 'Admisible(200)',...
    'Mala(300)', ' Muy mala(400)'});
ytickangle(45);
xticklabels({'Promedio', 'Máximo'});
grid on;