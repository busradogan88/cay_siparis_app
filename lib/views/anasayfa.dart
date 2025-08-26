import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/views/siparis.dart';
import 'package:flutter_application_1/views/bakiye.dart'; // Bakiye ekranı
import '../services/firestore_user_service.dart'; // Firestore servisi
import 'package:flutter_application_1/views/giris.dart';
import 'package:flutter_application_1/views/sepetim.dart';
import 'package:flutter_application_1/views/islemgecmisi.dart';


class Anasayfa extends StatefulWidget {
  const Anasayfa({super.key});

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  double _balance = 0.0;
  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    _loadBalance();
  }

  Future<void> _loadBalance() async {
    var userData = await FirestoreUserService.getUserData();
    if (userData != null) {
      setState(() {
        _balance = (userData['balance'] ?? 0).toDouble();
      });
    }
  }

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
    // Drawer ekliyoruz
   drawer: Drawer(
  child: ListView(
    padding: EdgeInsets.zero,
    children: [
      UserAccountsDrawerHeader(
        decoration: BoxDecoration(
          color: Colors.green[200],
        ),
        accountName: Text(user?.email ?? "Kullanıcı"),
        accountEmail: Text('Bakiye: $_balance TL'),
        currentAccountPicture: CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(
            Icons.person,
            size: 40,
            color: Colors.green[200],
          ),
        ),
      ),
      ListTile(
        leading: const Icon(Icons.home),
        title: const Text('Anasayfa'),
        onTap: () {
          Navigator.pop(context); // Drawer kapanır
        },
      ),
      ListTile(
        leading: const Icon(Icons.account_balance_wallet),
        title: const Text('Bakiye'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Bakiye()),
          );
        },
      ),
      ListTile(
        leading: const Icon(Icons.shopping_cart),
        title: const Text('Sepetim'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Sepetim()),
          );
        },
      ),
      ListTile(
        leading: const Icon(Icons.list_alt),
        title: const Text('Sipariş Ver'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Siparis()),
          );
        },
      ),
     
      ListTile(
        leading: const Icon(Icons.history),
        title: const Text('İşlem Geçmişi'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Islemgecmisi()),
          );
        },
      ),
      const Divider(),
      ListTile(
        leading: const Icon(Icons.logout),
        title: const Text('Çıkış Yap'),
        onTap: () async {
          await FirebaseAuth.instance.signOut();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Giris()),
            (route) => false,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Çıkış yapıldı!')),
          );
        },
      ),
    ],
  ),
),

    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/herbal-tea.png',
            width: 120,
            height: 120,
          ),
          const SizedBox(height: 20),
          const Text(
            'Hoş Geldiniz!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 20, 119, 14),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Oturum Açıldı ${user?.email ?? 'Kullanıcı'}',
            style: const TextStyle(
              fontSize: 18,
              color: Color.fromARGB(255, 20, 119, 14),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Bakiye: $_balance TL',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Bakiye()),
              );
              _loadBalance();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[200],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
            ),
            child: const Text(
              'Bakiye Yükle',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
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
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
            ),
            child: const Text(
              'Sipariş Ver',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 20),
          OutlinedButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const Giris()),
                (route) => false,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Çıkış yapıldı!')),
              );
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.green[800]!),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
            ),
            child: Text(
              'Çıkış Yap',
              style: TextStyle(
                color: Colors.green[800],
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}
