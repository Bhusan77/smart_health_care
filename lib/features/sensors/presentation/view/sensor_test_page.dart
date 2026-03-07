import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:sensors_plus/sensors_plus.dart';

class SensorTestPage extends StatefulWidget {
  const SensorTestPage({super.key});

  @override
  State<SensorTestPage> createState() => _SensorTestPageState();
}

class _SensorTestPageState extends State<SensorTestPage> {
  final LocalAuthentication auth = LocalAuthentication();

  StreamSubscription<GyroscopeEvent>? gyroSub;

  double x = 0.0;
  double y = 0.0;
  double z = 0.0;

  String fingerprintStatus = "Not verified";

  @override
  void initState() {
    super.initState();
    startGyroscope();
  }

  void startGyroscope() {
    gyroSub = gyroscopeEvents.listen((event) {
      setState(() {
        x = event.x;
        y = event.y;
        z = event.z;
      });

      detectShake(event);
    });
  }

  void detectShake(GyroscopeEvent event) {
    double movement = sqrt(
      (event.x * event.x) +
      (event.y * event.y) +
      (event.z * event.z),
    );

    if (movement > 8) {
      showEmergencyAlert();
    }
  }

  void showEmergencyAlert() {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Emergency Alert"),
        content: const Text("Strong phone movement detected."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  Future<void> verifyFingerprint() async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: "Verify fingerprint to continue",
        options: const AuthenticationOptions(
          biometricOnly: true,
        ),
      );

      setState(() {
        fingerprintStatus =
            authenticated ? "Fingerprint Verified" : "Verification Failed";
      });
    } catch (e) {
      setState(() {
        fingerprintStatus = "Error: $e";
      });
    }
  }

  @override
  void dispose() {
    gyroSub?.cancel();
    super.dispose();
  }

  Widget card(String title, Widget child) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          child
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sensors"),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xfff5f7fb),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            card(
              "Gyroscope Sensor",
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("X: ${x.toStringAsFixed(3)}"),
                  Text("Y: ${y.toStringAsFixed(3)}"),
                  Text("Z: ${z.toStringAsFixed(3)}"),
                ],
              ),
            ),

            card(
              "Fingerprint Sensor",
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: verifyFingerprint,
                    child: const Text("Verify Fingerprint"),
                  ),
                  const SizedBox(height: 10),
                  Text(fingerprintStatus),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}