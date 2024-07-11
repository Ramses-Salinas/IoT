import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:kunan_v01/pantallas/Alumnos/alum_pantalla_principal.dart';
import '../../Controladores/save_preferences.dart';
import '../../widgets/custom_navigationbar.dart';

class AlumTomarAsistencia extends StatefulWidget {
  const AlumTomarAsistencia({super.key});

  @override
  _AlumTomarAsistenciaState createState() => _AlumTomarAsistenciaState();
}

class _AlumTomarAsistenciaState extends State<AlumTomarAsistencia> {
  bool asistenciaMarcada = false;
  String asistenciaTime = '';
  List<ScanResult> devices = [];
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  late StreamSubscription<BluetoothAdapterState> _adapterStateSubscription;
  BluetoothDevice? selectedDevice;
  List<BluetoothService> services = [];
  bool isConnecting = false;
  String asistenciaCodigo = "";

  static const String SERVICE_UUID_REGISTRAR =
      "68cce3a1-a94d-4b2f-ac00-747066e80f05";
  static const String CHARACTERISTIC_UUID_REGISTRAR =
      "22222222-2222-2222-2222-222222222223";

  @override
  void initState() {
    super.initState();
    _initBluetooth();
    _initializeData();
  }

  Future<void> _initializeData() async {
    String? codigo = await SharedPrefUtils.getString('codigo');
    setState(() {
      asistenciaCodigo = codigo ?? "";
    });
    // Add any other initialization logic here
  }

  String getServiceName(BluetoothService service) {
    switch (service.uuid.toString()) {
      case '68cce3a1-a94d-4b2f-ac00-747066e80f05':
        return 'Servicio de registro de asistencia';
      case '2da27884-06ee-4a0d-9102-9eadb3e6629c':
        return 'Servicio de inicio de asistencia';
      case 'c4997186-5979-40ae-81ec-013a0a4313e2':
        return 'Servicio de lectura de asistencia';
      default:
        return 'Servicio predefinido: ${service.uuid.toString().toUpperCase()}';
    }
  }

  void _initBluetooth() async {
    if (await FlutterBluePlus.isSupported == false) {
      print("Bluetooth no es compatible con este dispositivo");
      return;
    }

    _adapterStateSubscription =
        FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
      setState(() {
        _adapterState = state;
      });
      if (state == BluetoothAdapterState.on) {
        _startScan();
      } else {
        _showBluetoothOffDialog();
      }
    });

    if (Platform.isAndroid) {
      try {
        await FlutterBluePlus.turnOn();
      } catch (e) {
        print("No se pudo activar el Bluetooth: $e");
      }
    }
  }

  void _showBluetoothOffDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Bluetooth desactivado'),
          content: const Text(
              'Por favor, active el Bluetooth para usar esta función.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _startScan() async {
    if (_adapterState != BluetoothAdapterState.on) return;

    setState(() {
      devices.clear();
    });

    try {
      await FlutterBluePlus.startScan(timeout: Duration(seconds: 4));
      FlutterBluePlus.scanResults.listen((results) {
        setState(() {
          devices = results;
        });
      });
    } catch (e) {
      print('Error al escanear dispositivos BLE: $e');
    }
  }

  Future<void> _connectToDevice() async {
    if (selectedDevice == null) return;

    setState(() {
      isConnecting = true;
    });

    try {
      await selectedDevice!.connect();
      services = await selectedDevice!.discoverServices();
      setState(() {});
    } catch (e) {
      print('Error al conectar con el dispositivo: $e');
    } finally {
      setState(() {
        isConnecting = false;
      });
    }
  }

  Future<void> _registrarAsistencia() async {
    if (selectedDevice == null) {
      print('No hay dispositivo seleccionado');
      return;
    }

    try {
      BluetoothService? targetService;
      for (var service in services) {
        print(service);
        if (service.uuid.toString() == SERVICE_UUID_REGISTRAR) {
          targetService = service;
          break;
        }
      }

      if (targetService == null) {
        print('Servicio no encontrado');
        return;
      }

      BluetoothCharacteristic? targetCharacteristic;
      for (var characteristic in targetService.characteristics) {
        if (characteristic.uuid.toString() == CHARACTERISTIC_UUID_REGISTRAR) {
          targetCharacteristic = characteristic;
          break;
        }
      }

      if (targetCharacteristic == null) {
        print('Característica no encontrada');
        return;
      }

      await targetCharacteristic.write(utf8.encode(asistenciaCodigo));
      print('Se envió el código de asistencia a la característica');
      // Capture the current time
      DateTime now = DateTime.now();
      String formattedTime =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

      // Update the state
      setState(() {
        asistenciaMarcada = true;
        asistenciaTime = formattedTime;
      });
      /* // Disconnect from the BLE server
      await selectedDevice!.disconnect();
      print('Desconectado del servidor BLE');

      // Optionally, you can set selectedDevice to null after disconnecting
      setState(() {
        selectedDevice = null;
      });*/
    } catch (e) {
      print('Error al registrar asistencia: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        color: const Color.fromRGBO(1, 6, 24, 1),
        padding: EdgeInsets.only(
            top: size.height * 0.03,
            left: size.width * 0.09,
            right: size.width * 0.09),
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Botón de Volver
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EstMainMenuScreen(
                            idUsuario: 'OuVmuk1gaojmulu9AnhQ')),
                  );
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_left_outlined,
                      size: size.width * 0.05,
                      color: Colors.white,
                    ),
                    const Text(
                      'Volver',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.02),
              // Título
              Container(
                margin: EdgeInsets.only(right: size.width * 0.06),
                child: Text(
                  'Marcar Asistencia',
                  style: TextStyle(
                    fontSize: size.width * 0.08,
                    color: const Color.fromRGBO(178, 219, 144, 1),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.03),

              DropdownButton<BluetoothDevice>(
                value: selectedDevice,
                hint: const Text('Seleccionar dispositivo',
                    style: TextStyle(color: Colors.white)),
                dropdownColor: const Color.fromRGBO(1, 6, 24, 1),
                items: devices.map((result) {
                  return DropdownMenuItem(
                    value: result.device,
                    child: Text(
                      result.device.platformName ?? 'Dispositivo desconocido',
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
                onChanged: (BluetoothDevice? value) {
                  setState(() {
                    selectedDevice = value;
                  });
                },
              ),
              SizedBox(height: size.height * 0.02),
              ElevatedButton(
                onPressed: isConnecting ? null : _connectToDevice,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(128, 179, 255, 1),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                    isConnecting ? 'Conectando...' : 'Conectar al dispositivo'),
              ),
              SizedBox(height: size.height * 0.02),
              Container(
                margin: EdgeInsets.only(left: size.width * 0.01),
                width: size.width * 0.8,
                height: size.height * 0.2,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: services.isEmpty
                        ? const Text(
                      'No hay servicios disponibles',
                      style: TextStyle(color: Colors.white),
                    )
                        : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: services.map((service) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              Icon(Icons.circle, size: 10, color: Colors.green),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  getServiceName(service),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.02),

              // Clase activa
              Text(
                'Clase:',
                style: TextStyle(
                  fontSize: size.width * 0.06,
                  color: const Color.fromRGBO(178, 219, 144, 1),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: size.height * 0.02),
              Text(
                'Taller de Software Móvil',
                style: TextStyle(
                  fontSize: size.width * 0.055,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: size.height * 0.03),

              Container(
                width: size.width * 0.85,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: size.width * 0.005,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),

                //Asistencia
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: size.height * 0.02),
                    // Número de asistencia
                    Container(
                      margin: EdgeInsets.only(left: size.width * 0.05),
                      child: const Text(
                        'Código de Alumno',
                        style: TextStyle(
                          fontSize: 25,
                          color: Color.fromRGBO(178, 219, 144, 1),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    Container(
                      margin: EdgeInsets.only(left: size.width * 0.05),
                      child: Text(
                        asistenciaCodigo,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(size.width * 0.022),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                await _registrarAsistencia();
                                setState(() {
                                  asistenciaMarcada = true;
                                  SharedPrefUtils.saveBool(
                                      "asistenciaMarcada", asistenciaMarcada);
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromRGBO(128, 179, 255, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.domain_verification,
                                    color: Colors.black,
                                    size: size.width * 0.063,
                                  ),
                                  SizedBox(width: size.width * 0.02),
                                  Text(
                                    'Marcar Asistencia',
                                    style: TextStyle(
                                      fontSize: size.width * 0.041,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.06),
              if (asistenciaMarcada)
                SizedBox(
                  width: size.width * 0.9,
                  child: Column(
                    children: [
                      Text(
                        'Asistencia registrada correctamente a las $asistenciaTime',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: size.width * 0.065,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(
                        thickness: 1.5,
                        color: Colors.white,
                      ),
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(
        initialIndex: 0,
        usuario: 'Alumno',
      ),
    );
  }
}
