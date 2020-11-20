% Channel ID to read data from
readChannelID = 1226417;
% Temperatura Field ID
TemperaturaFieldID = 1;
% Humedad Field ID
HumedadFieldID = 2;

% Channel Read API Key
% If your channel is private, then enter the read API
% Key between the '' below:
readAPIKey = '';

% Leer de la API
datos = thingSpeakRead(readChannelID,'Fields',[TemperaturaFieldID HumedadFieldID], ...
    'NumPoints',150, ...
    'ReadKey',readAPIKey);

% Leer datos
temperaturaData = datos(:,1);
humedadData = datos(:,2);

% Visualize the data
p = scatter(temperaturaData, humedadData);
xlabel('Temperatura (ºC)');
ylabel('Humedad (%)');
title('Correlación entre temperatura y humedad.');
ylim([0 100]);
grid on;

% Estilo
p.LineWidth = 1;
p.Marker = '*';