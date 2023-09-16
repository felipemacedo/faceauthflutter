//https://youtu.be/WdrjUWf52II?t=610   -
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool deviceSupported = false;

  Future<List<BiometricType>> _initBiometrics() async {
    deviceSupported = await _localAuth.isDeviceSupported();
    List<BiometricType> _availableBiometrics = <BiometricType>[];

    if (deviceSupported) {
      try {
        if (await _localAuth.canCheckBiometrics) {
          _availableBiometrics = await _localAuth.getAvailableBiometrics();
          return _availableBiometrics;
        }
      } catch (e) {
        deviceSupported = false;
      }
    }
    return [];
  }

  Future<bool> _auth() async {
    bool authentication = false;
    try {
      biometricOnly:
      true;
      authentication = await _localAuth.authenticate(
        localizedReason: "Desbloqueie para acessar a tela secreta",
      );

      return authentication;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffff4081),
      body: FutureBuilder<List<BiometricType>>(
        future: _initBiometrics(),
        builder: (BuildContext context,
            AsyncSnapshot<List<BiometricType>> snapshot) {
          if (snapshot.hasData) {
            if (!deviceSupported) {
              return const Text("Dispositivo não suporta essa tecnologia");
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: Column(
                  children: [
                    const Expanded(child: SizedBox()),
                    SizedBox(
                      height: 125.0,
                      width: 125.0,
                      //child: Image.asset('assets/no-icon.png'),
                    ),
                    const Expanded(child: SizedBox()),
                    MaterialButton(
                      child:
                          Text('Entrar', style: TextStyle(color: Colors.black)),
                      color: Colors.white,
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(30.0))),
                      onPressed: () async {
                        bool _res = await _auth();
                        if (_res) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SecretScreen()));
                        }
                      },
                      height: 50.0,
                      minWidth: double.maxFinite,
                    ),
                    const SizedBox(
                      height: 20.0,
                    )
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: SizedBox(
                width: 60.0,
                height: 60.0,
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}
