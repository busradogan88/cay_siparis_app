import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/siparis.dart';

class Giris extends StatelessWidget {
  const Giris({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text('Meram Çay Sipariş Sistemi'),
        centerTitle: true,
        backgroundColor: Colors.green[100],
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/herbal-tea.png',
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 5),
            const Text(
              'Hoş geldiniz!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 20, 119, 14),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Çay ve içecek siparişi vermek için giriş yapın',
              style: TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 20, 119, 14),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: ' Telefon Numarası',
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Doğrulama Kodu',
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Siparis()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[100],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 16,
                ),
              ),
              child: const Text(
                'Giriş Yap',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
