#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>

// Variables globales
BLEServer* pServer = NULL;
BLECharacteristic* pCharacteristicEstado = NULL;
BLECharacteristic* pCharacteristicRegistrar = NULL;
BLECharacteristic* pCharacteristicLeer = NULL;

bool periodoActivo = false;

const int maxAsistentes = 100;
String asistentes[maxAsistentes];
int numAsistentes = 0;

// UUIDs para los servicios y características
#define SERVICE_UUID_CAMBIO_ESTADO "11111111-1111-1111-1111-111111111111"
#define CHARACTERISTIC_UUID_CAMBIO_ESTADO "11111111-1111-1111-1111-111111111112"

#define SERVICE_UUID_REGISTRAR "22222222-2222-2222-2222-222222222222"
#define CHARACTERISTIC_UUID_REGISTRAR "22222222-2222-2222-2222-222222222223"

#define SERVICE_UUID_LEER "33333333-3333-3333-3333-333333333333"
#define CHARACTERISTIC_UUID_LEER "33333333-3333-3333-3333-333333333334"

class MyServerCallbacks: public BLEServerCallbacks {
    void onConnect(BLEServer* pServer) {
      BLEDevice::startAdvertising();
    };

    void onDisconnect(BLEServer* pServer) {
    }
};

class EstadoCallbacks: public BLECharacteristicCallbacks {
    void onWrite(BLECharacteristic *pCharacteristic) {
      std::string value = pCharacteristic->getValue();
      if (value == "start") {
        periodoActivo = true;
        Serial.println("Periodo de asistencia iniciado.");
      } else if (value == "stop") {
        periodoActivo = false;
        Serial.println("Periodo de asistencia pausado.");
        // Vaciar el arreglo de asistencia
        numAsistentes = 0;
      }
    }
};

class RegistrarCallbacks: public BLECharacteristicCallbacks {
    void onWrite(BLECharacteristic *pCharacteristic) {
      if (periodoActivo && numAsistentes < maxAsistentes) {
        std::string value = pCharacteristic->getValue();
        asistentes[numAsistentes] = String(value.c_str()); // Conversion std::string a String
        numAsistentes++;
        Serial.println("Asistencia registrada: " + String(value.c_str()));
      }
    }
};

void setup() {
  Serial.begin(115200);

  // Crear el dispositivo BLE
  BLEDevice::init("ESP32");

  // Crear el servidor BLE
  pServer = BLEDevice::createServer();
  pServer->setCallbacks(new MyServerCallbacks());

  // Crear el servicio BLE para cambio de estado
  BLEService *pServiceEstado = pServer->createService(SERVICE_UUID_CAMBIO_ESTADO);

  // Crear una característica BLE para cambio de estado
  pCharacteristicEstado = pServiceEstado->createCharacteristic(
                      CHARACTERISTIC_UUID_CAMBIO_ESTADO,
                      BLECharacteristic::PROPERTY_WRITE
                    );
  pCharacteristicEstado->addDescriptor(new BLE2902());
  pCharacteristicEstado->setCallbacks(new EstadoCallbacks());

  // Iniciar el servicio de cambio de estado
  pServiceEstado->start();

  // Crear el servicio BLE para registrar asistencia
  BLEService *pServiceRegistrar = pServer->createService(SERVICE_UUID_REGISTRAR);

  // Crear una característica BLE para registrar asistencia
  pCharacteristicRegistrar = pServiceRegistrar->createCharacteristic(
                      CHARACTERISTIC_UUID_REGISTRAR,
                      BLECharacteristic::PROPERTY_WRITE
                    );
  pCharacteristicRegistrar->addDescriptor(new BLE2902());
  pCharacteristicRegistrar->setCallbacks(new RegistrarCallbacks());

  // Iniciar el servicio registrar asistencia
  pServiceRegistrar->start();

  // Crear el servicio BLE para leer asistentes
  BLEService *pServiceLeer = pServer->createService(SERVICE_UUID_LEER);

  // Crear una característica BLE para leer asistentes
  pCharacteristicLeer = pServiceLeer->createCharacteristic(
                      CHARACTERISTIC_UUID_LEER,
                      BLECharacteristic::PROPERTY_READ
                    );
  pCharacteristicLeer->addDescriptor(new BLE2902());

  // Iniciar el servicio leer asistentes
  pServiceLeer->start();

  // Iniciar la publicidad
  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID_CAMBIO_ESTADO);
  pAdvertising->addServiceUUID(SERVICE_UUID_REGISTRAR);
  pAdvertising->addServiceUUID(SERVICE_UUID_LEER);
  pAdvertising->setScanResponse(false);
  pAdvertising->setMinPreferred(0x0); 
  BLEDevice::startAdvertising();
  Serial.println("Esperando conexión de un cliente para cambiar estado, registrar o leer asistencia...");
}

void loop() {
    // Imprimir el arreglo de asistentes en el monitor serial
    Serial.println("Lista de Asistentes:");
    for (int i = 0; i < numAsistentes; i++) {
      Serial.println(asistentes[i]);
    }

    // Si hay un dispositivo conectado, enviar la lista de asistentes
    if (periodoActivo) {
        String asistentesStr = "";
        for (int i = 0; i < numAsistentes; i++) {
            asistentesStr += asistentes[i] + "\n";
        }
        pCharacteristicLeer->setValue(asistentesStr.c_str());
    }

    delay(10000); // Esperar 10 segundos antes de imprimir de nuevo
}
