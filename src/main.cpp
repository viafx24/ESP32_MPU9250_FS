#include <Arduino.h>
#include <WiFi.h>
#include "MPU9250.h"

// Wifi

const char *ssid = "freebox_OOKMJG";
const char *password = "38100Alexandre!";

// to set the static IP address to 192, 168, 1, 184
IPAddress local_IP(192, 168, 0, 20);
IPAddress gateway(192, 168, 0, 254);
IPAddress subnet(255, 255, 255, 0);

WiFiServer server(80);

MPU9250 mpu;

void setup()
{

  Serial.begin(9600);
  Wire.begin();
  delay(2000);

  if (!mpu.setup(0x68))
  { // change to your own address
    while (1)
    {
      Serial.println("MPU connection failed. Please check your connection with `connection_check` example.");
      delay(5000);
    }
  }

  if (!WiFi.config(local_IP, gateway, subnet))
  {
    Serial.println("IP adress could not be set to 192.168.0.20");
  }

  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED)
  {
    delay(500);
    // Serial.print(".");
  }

  server.begin();
}

void loop()
{

  WiFiClient client = server.available(); // listen for incoming clients

  if (client)
  { // if you get a client,
    // Serial.println("New Client."); // print a message out the serial port
    String currentLine = "";

    while (client.connected())
    { // loop while the client's connected

      if (mpu.update())
      {

        currentLine = String(millis()) + "," + String(mpu.getAccX()) + "," + String(mpu.getAccY()) + "," + String(mpu.getAccZ()) +
                      "," + String(mpu.getGyroX()) + "," + String(mpu.getGyroY()) + "," + String(mpu.getGyroZ()) +
                      "," + String(mpu.getMagX()) + "," + String(mpu.getMagY()) + "," + String(mpu.getMagZ());

        client.println(currentLine);
        delay(10);
      }

      client.stop();
      Serial.println("Client Disconnected.");
    }
  }

  // #include "MPU9250.h"

  // MPU9250 mpu;

  // void setup() {
  //     Serial.begin(115200);
  //     Wire.begin();
  //     delay(2000);

  //     if (!mpu.setup(0x68)) {  // change to your own address
  //         while (1) {
  //             Serial.println("MPU connection failed. Please check your connection with `connection_check` example.");
  //             delay(5000);
  //         }
  //     }
  // }

  // void loop() {
  //     if (mpu.update()) {
  //         static uint32_t prev_ms = millis();
  //         if (millis() > prev_ms + 25) {
  //             print_roll_pitch_yaw();
  //             prev_ms = millis();
  //         }
  //     }
  // }

  // void print_roll_pitch_yaw() {
  //     Serial.print("Yaw, Pitch, Roll: ");
  //     Serial.print(mpu.getYaw(), 2);
  //     Serial.print(", ");
  //     Serial.print(mpu.getPitch(), 2);
  //     Serial.print(", ");
  //     Serial.println(mpu.getRoll(), 2);
  // }
