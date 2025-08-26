import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:flutter_application_1/views/giris.dart';
import 'package:flutter_application_1/views/anasayfa.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Cayapp());
}

class Cayapp extends StatelessWidget {
  const Cayapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cayapp',
      theme: ThemeData(
        primarySwatch: Colors.green, // Tema rengini yeşil yaptım
      ),
      home: const AuthWrapper(),
    );
  }
}

// AuthWrapper - Kullanıcı oturum durumunu kontrol eden widget
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Bağlantı bekleniyor
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green[800]!),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Yükleniyor...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 20, 119, 14),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        
        // Hata durumu
        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[400],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Bir hata oluştu!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Hata: ${snapshot.error}',
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        // Kullanıcı durumu kontrolü
        if (snapshot.hasData) {
          // Kullanıcı giriş yapmış - Ana sayfaya yönlendir
          return const Anasayfa();
        } else {
          // Kullanıcı giriş yapmamış - Giriş sayfasını göster
          return const Giris();
        }
      },
    );
  }
}