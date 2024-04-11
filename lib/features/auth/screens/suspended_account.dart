import 'package:flutter/material.dart';

class SuspendedAccountScreen extends StatelessWidget {
  const SuspendedAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hesap Askıya Alındı'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Hesabınız askıya alınmıştır.',
              style: TextStyle(fontSize: 20),
            ),
            ElevatedButton(
              onPressed: () {
                // Add functionality to reach us for help
              },
              child: Text('Yardım İçin Bize Ulaşın'),
            ),
          ],
        ),
      ),
    );
  }
}
