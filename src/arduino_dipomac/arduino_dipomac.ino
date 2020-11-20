#include <RH_RF95.h>
#include "Seeed_BME280.h"
#include <Wire.h> //Para I2C
#include <SoftwareSerial.h>
#include <Arduino.h>
#include "MutichannelGasSensor.h"

SoftwareSerial SSerial(5, 6); //RX, TX
RH_RF95<SoftwareSerial> rf95(SSerial);

BME280 bme280;

const String node_id_ambiente = "<5496>"; //El formato de things Network requiere que sea asi, numero aleatorio
const String node_id_gases = "<5495>";

void setup() {
  Serial.begin(9600);
  if (!rf95.init()) {
    Serial.println(F("Error LoRa"));
    while (1);
  }
  // Defaults after init are 434.0MHz, 13dBm, Bw = 125 kHz, Cr = 4/5, Sf = 128chips/symbol, CRC on
  rf95.setFrequency(868.1);
  ////////////////////////////////////////////////////////////////////////////////////////////////////
  if (!bme280.init()) {
    Serial.println(F("Error BME280"));
    while (1);
  }
  ////////////////////////////////////////////////////////////////////////////////////////////////////
  gas.begin(0x04);//the default I2C address of the slave is 0x04
  gas.powerOn();
}

void loop() {
  String cadena_gases = node_id_gases;
  String cadena_ambiente = node_id_ambiente;
  
  // BME280
  cadena_ambiente += "field1=";
  cadena_ambiente += bme280.getTemperature();
  cadena_ambiente += "&field2=";
  cadena_ambiente += bme280.getHumidity();
  cadena_ambiente += "&field3=";
  cadena_ambiente += bme280.getPressure();
  
  // Multigas
  float c;
  c = gas.measure_NH3();
  if(c>=0){
    cadena_gases += "field1=";
    cadena_gases += c;
  }
  c = gas.measure_CO();
  if(c>=0){
    cadena_gases += "&field2=";
    cadena_gases += c;
  }
  c = gas.measure_NO2();
  if(c>=0){
    cadena_gases += "&field3=";
    cadena_gases += c;
  }
  c = gas.measure_C3H8();
  if(c>=0){
    cadena_gases += "&field4=";
    cadena_gases += c;
  }
  c = gas.measure_C4H10();
  if(c>=0){
    cadena_gases += "&field5=";
    cadena_gases += c;
  }
  c = gas.measure_CH4();
  if(c>=0){
    cadena_gases += "&field6=";
    cadena_gases += c;
  }
  c = gas.measure_H2();
  if(c>=0){
    cadena_gases += "&field7=";
    cadena_gases += c;
  }
  c = gas.measure_C2H5OH();
  if(c>=0){
    cadena_gases += "&field8=";
    cadena_gases += c;
  }

  // LoRa
  unsigned int tamanio_ambiente = cadena_ambiente.length()+1;
  unsigned char data_ambiente[tamanio_ambiente] = "";  // 1B es, perfecto para lo que queremos
  cadena_ambiente.toCharArray(data_ambiente, tamanio_ambiente);
  unsigned int tamanio_gas = cadena_gases.length()+1;
  unsigned char data_gas[tamanio_gas] = "";  // 1B es, perfecto para lo que queremos
  cadena_gases.toCharArray(data_gas, tamanio_gas);
  
  Serial.println(F("Enviando el paquete ambiente..."));
  rf95.send(data_ambiente, sizeof(data_ambiente));
  rf95.waitPacketSent();
  delay(30000); // 15s es el mínimo por canal de thingspeak, lo dejamos en 30s
  
  Serial.println(F("Enviando el paquete gas..."));
  rf95.send(data_gas, sizeof(data_gas));
  rf95.waitPacketSent();
  
  Serial.println(cadena_gases);
  Serial.println(tamanio_gas);
  Serial.println(cadena_ambiente);
  Serial.println(tamanio_ambiente);
  
  Serial.println(F("Esperando 10 minutos."));
  delay(600000); // Esperamos 10 minutos para poder reenviarlo todo
}
