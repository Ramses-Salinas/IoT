import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:kunan_v01/pantallas/Profesores/prof_reporte_asistencia.dart';
import 'package:kunan_v01/widgets/estudiantes_widget.dart';
import 'package:http/http.dart' as http;
import '../../widgets/custom_navigationbar.dart';

class ProfTomarAsistencia extends StatefulWidget {
  const ProfTomarAsistencia({super.key});

  @override
  State<ProfTomarAsistencia> createState() => _ProfTomarAsistenciaState();
}

class _ProfTomarAsistenciaState extends State<ProfTomarAsistencia> {

  List<ScanResult> devices = [];
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  late StreamSubscription<BluetoothAdapterState> _adapterStateSubscription;
  BluetoothDevice? selectedDevice;
  List<BluetoothService> services = [];
  bool isConnecting = false;
  String id_curso = "tkLzkJRX5ysI3P4iLMQy";
  bool _isLoading = true;
  List<Map<String, dynamic>> alumnosMatriculados = [];
  List<Map<String, dynamic>> attendanceList_w = [];

  static const String SERVICE_UUID_CAMBIO_ESTADO =
      "2da27884-06ee-4a0d-9102-9eadb3e6629c";
  static const String CHARACTERISTIC_UUID_CAMBIO_ESTADO =
      "11111111-1111-1111-1111-111111111112";
  static const String SERVICE_UUID_LEER =
      "c4997186-5979-40ae-81ec-013a0a4313e2";
  static const String CHARACTERISTIC_UUID_LEER =
      "33333333-3333-3333-3333-333333333334";

  @override
  void initState() {
    super.initState();
    _initBluetooth();
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
          content:
          const Text('Por favor, active el Bluetooth para usar esta función.'),
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

  Future<void> _iniciarAsistencia() async {
    if (selectedDevice == null) {
      print('No hay dispositivo seleccionado');
      return;
    }

    try {
      BluetoothService? targetService;
      for (var service in services) {
        print(service);
        if (service.uuid.toString() == SERVICE_UUID_CAMBIO_ESTADO) {
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
        if (characteristic.uuid.toString() == CHARACTERISTIC_UUID_CAMBIO_ESTADO) {
          targetCharacteristic = characteristic;
          break;
        }
      }

      if (targetCharacteristic == null) {
        print('Característica no encontrada');
        return;
      }

      await targetCharacteristic.write(utf8.encode('start'));
      print('Se envió "start" a la característica');
    } catch (e) {
      print('Error al iniciar asistencia: $e');
    }
  }

  Future<void> _cerrarAsistencia() async {
    if (selectedDevice == null) {
      print('No hay dispositivo seleccionado');
      return;
    }

    try {
      // Primero, enviamos 'stop' al servicio de cambio de estado
      BluetoothService? targetService;
      for (var service in services) {
        print(service);
        if (service.uuid.toString() == SERVICE_UUID_CAMBIO_ESTADO) {
          targetService = service;
          break;
        }
      }

      if (targetService == null) {
        print('Servicio de cambio de estado no encontrado');
        return;
      }

      BluetoothCharacteristic? targetCharacteristic;
      for (var characteristic in targetService.characteristics) {
        if (characteristic.uuid.toString() ==
            CHARACTERISTIC_UUID_CAMBIO_ESTADO) {
          targetCharacteristic = characteristic;
          break;
        }
      }

      if (targetCharacteristic == null) {
        print('Característica de cambio de estado no encontrada');
        return;
      }

      await targetCharacteristic.write(utf8.encode('stop'));
      print('Se envió "stop" a la característica de cambio de estado');

      // Ahora, leemos la lista de asistentes del servicio de lectura
      BluetoothService? leerService;
      for (var service in services) {
        print(service);
        if (service.uuid.toString() == SERVICE_UUID_LEER) {
          leerService = service;
          break;
        }
      }

      if (leerService == null) {
        print('Servicio de lectura no encontrado');
        return;
      }

      BluetoothCharacteristic? leerCharacteristic;
      for (var characteristic in leerService.characteristics) {
        if (characteristic.uuid.toString() ==
            CHARACTERISTIC_UUID_LEER) {
          leerCharacteristic = characteristic;
          break;
        }
      }

      if (leerCharacteristic == null) {
        print('Característica de lectura no encontrada');
        return;
      }
      //convetimos en una lista los codigos que nos devuelve
      List<int> value = await leerCharacteristic.read();
      String asistentes = utf8.decode(value);
      print('Lista de asistentes:');
      print(asistentes.runtimeType);
      print(asistentes);
      await _fetchEnrolledStudents();
      List<Map<String, dynamic>> attendanceList = [];
      for (var student in alumnosMatriculados) {
        attendanceList.add({
          'nombre': '${student['nombres']} ${student['apellidos']}',
          'codigo': student['codigo'],
          'asistencia': asistentes.contains(student['codigo'])
        });
      }
      setState(() {
        attendanceList_w = attendanceList ;
      });
      print('Lista de asistencia:');
      print(attendanceList);
      // logica para crear la lista de asistentes
    } catch (e) {
      print('Error al cerrar asistencia: $e');
    }
  }

  Future<void> _fetchEnrolledStudents() async {
    try {
      final response = await http.post(
        Uri.parse('https://kunan.onrender.com/curso/alumnosMatriculados'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "id_curso": "tkLzkJRX5ysI3P4iLMQy"
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        alumnosMatriculados = List<Map<String, dynamic>>.from(data['alumnos_matriculados']);
      } else {
        throw Exception('Error al obtener datos de alumnos matriculados');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al obtener datos de alumnos matriculados')),
      );
    }
  }

  @override
  void dispose() {
    _adapterStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        color: const Color.fromRGBO(1, 6, 24, 1),
        padding: EdgeInsets.only(top: size.height * 0.03, left: size.width * 0.09, right: size.width * 0.09),
        width: double.infinity,
        height: double.infinity,

        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // LOGO
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_left_outlined,
                          size: size.width * 0.07,
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
                ],
              ),
              SizedBox(height: size.height * 0.02),
              Container(
                margin: EdgeInsets.only(right: size.width * 0.1),
                child: Text(
                  'Iniciar Asistencia',
                  style: TextStyle(
                    fontSize: size.width * 0.09,
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
              Text(
                'Clase:',
                style: TextStyle(
                  fontSize: size.width * 0.05,
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

              Text(
                'Control de asistencia:',
                style: TextStyle(
                  fontSize: size.width * 0.05,
                  color: const Color.fromRGBO(178, 219, 144, 1),
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(height: size.height * 0.02),

              Container(
                width: size.width * 0.9,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  margin: EdgeInsets.all(size.width * 0.021),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _iniciarAsistencia,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromRGBO(128, 179, 255, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.login, color: Colors.white),
                              SizedBox(width: size.width * 0.011),
                              Text(
                                'Iniciar',
                                style: TextStyle(
                                  fontSize:  size.width * 0.05,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: size.width * 0.01),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _cerrarAsistencia,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromRGBO(128, 179, 255, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.logout, color: Colors.white),
                              SizedBox(width:  size.width * 0.0011),
                              Text(
                                'Finalizar',
                                style: TextStyle(
                                  fontSize:  size.width * 0.05,
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
              ),
              SizedBox(height: size.height * 0.04),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfReporteAsistencia()),
                  );
                },
                child: const Text(
                  'Reporte de asistencias',
                  style: TextStyle(
                    fontSize: 30,
                    color: Color.fromRGBO(178, 219, 144, 1),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Text(
                'Estudiantes inasistentes:',
                style: TextStyle(
                  fontSize: size.width * 0.05,
                  color: const Color.fromRGBO(178, 219, 144, 1),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: size.height * 0.04),
              Column(
                children: attendanceList_w.map((student) {
                  var randomImage = Random().nextInt(2) + 1;
                  return EstudianteWidget(
                    imagen: randomImage.toString(),
                    nombre: '${student['nombre']}',
                    estado: student['asistencia'] ? 'Presente' : 'Ausente',
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(
        initialIndex: 0,
        usuario: 'Profesor',
      ),
    );
  }
}
