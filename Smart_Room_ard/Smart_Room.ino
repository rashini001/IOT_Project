#include <ESP8266WiFi.h>
#include <FirebaseArduino.h>
#include <DHT.h>

#define FIREBASE_HOST "led-1-70768-default-rtdb.firebaseio.com" // Firebase host  
#define FIREBASE_AUTH "U2IRfh5mIVNLm5kNtZBG0PECjFfeshRhLlY520te" // Firebase Auth code
#define WIFI_SSID "realme C11 2021"
#define WIFI_PASSWORD "12345678"

#define DHTPIN D4 // Pin connected to the DHT11 sensor
#define DHTTYPE DHT11 // DHT11 sensor type

DHT dht(DHTPIN, DHTTYPE);

const int FAN_PIN = D2; // Pin connected to the fan
const int BULB_PIN = D1; // Pin connected to the bulb
const int DOOR_PIN = D3; // Pin connected to the door lock
const int HIGH_TEMP_THRESHOLD = 20; // Temperature threshold to turn the fan on
const int LOW_TEMP_THRESHOLD = 15; // Temperature threshold to turn the fan off

int fanStatus = 0; // 0: OFF, 1: ON
int bulbStatus = 0; // 0: OFF, 1: ON
int doorStatus = 0; // 0: LOCKED, 1: UNLOCKED
float temperature = 0;

int bulbOnCount = 0;
int bulbOffCount = 0;
int fanOnCount = 0;
int fanOffCount = 0;
int doorLockCount = 0;
int doorUnlockCount = 0;

void setup() {
  Serial.begin(9600);

  pinMode(FAN_PIN, OUTPUT); // Fan
  pinMode(BULB_PIN, OUTPUT); // Bulb
  pinMode(DOOR_PIN, OUTPUT); // Door Lock

  dht.begin();

  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(500);
  }
  Serial.println();
  Serial.println("Connected.");
  Serial.println(WiFi.localIP());
  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
}

void loop() {
 
  // // Read temperature from DHT11 sensor
  temperature = dht.readTemperature();
   if (isnan(temperature)) {
    Serial.println("Failed to read from DHT sensor!");
     return;
 }

  // // Update Firebase with the current temperature
   Firebase.setFloat("fan_TEMP", temperature);

  // // Automatically control the fan based on temperature
   if (temperature >= HIGH_TEMP_THRESHOLD && fanStatus == 0) {
     Serial.println("High temperature detected, turning fan ON");
     digitalWrite(FAN_PIN, HIGH);
     fanStatus = 1;
     fanOnCount++;
   } else if (temperature <= LOW_TEMP_THRESHOLD && fanStatus == 1) {
     Serial.println("Low temperature detected, turning fan OFF");
     digitalWrite(FAN_PIN, LOW);
   fanStatus = 0;
     fanOffCount++;
 }
  

  // Control Bulb
  bulbStatus = Firebase.getInt("bulb_STATUS");
  if (bulbStatus == 1) {
    Serial.println("Bulb Turned ON");
    digitalWrite(BULB_PIN, HIGH);
    bulbOnCount++;
  } else if (bulbStatus == 0) {
    Serial.println("Bulb Turned OFF");
    digitalWrite(BULB_PIN, LOW);
    bulbOffCount++;
  }

  // Control Door
  doorStatus = Firebase.getInt("door_STATUS");
  if (doorStatus == 1) {
    Serial.println("Door Unlocked");
    digitalWrite(DOOR_PIN, HIGH);
    doorUnlockCount++;
  } else if (doorStatus == 0) {
    Serial.println("Door Locked");
    digitalWrite(DOOR_PIN, LOW);
    doorLockCount++;
  }

  // Generate Daily Report
  String date = "YYYY-MM-DD"; 
  Firebase.setInt("reports/" + date + "/bulb/on_count", bulbOnCount);
  Firebase.setInt("reports/" + date + "/bulb/off_count", bulbOffCount);
  Firebase.setInt("reports/" + date + "/fan/on_count", fanOnCount);
  Firebase.setInt("reports/" + date + "/fan/off_count", fanOffCount);
  Firebase.setInt("reports/" + date + "/door/unlock_count", doorUnlockCount);
  Firebase.setInt("reports/" + date + "/door/lock_count", doorLockCount);

  delay(50); 
}
