import 'package:flutter/material.dart';
import 'package:flutter_application_1/global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Sepetim extends StatefulWidget {
  const Sepetim({super.key});

  @override
  State<Sepetim> createState() => _SepetimState();
}

class _SepetimState extends State<Sepetim> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void adetArttir(int index) {
    setState(() {
      urunler[index]["adet"]++;
    });
  }

  void adetAzalt(int index) {
    setState(() {
      if (urunler[index]["adet"] > 1) {
        urunler[index]["adet"]--;
      } else {
        urunler.removeAt(index);
      }
    });
  }

  double toplamFiyat() {
    return urunler.fold<double>(
        0.0,
        (toplam, urun) =>
            toplam + ((urun["fiyat"] ?? 0).toDouble() * ((urun["adet"] ?? 0) as int)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sepetim")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Icon(Icons.shopping_cart, size: 40),
            const Text(
              'Sepetim',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Container(
              width: 400,
              height: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.green[100],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.9),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ]),
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      "Toplam Ürün: ${urunler.fold<int>(0, (toplam, urun) => toplam + ((urun["adet"] ?? 0) as int))} ",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Toplam Fiyat: ${toplamFiyat().toStringAsFixed(2)} TL",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: urunler.isEmpty
                  ? const Center(child: Text("Sepetiniz boş"))
                  : ListView.builder(
                      itemCount: urunler.length,
                      itemBuilder: (context, index) {
                        final urun = urunler[index];
                        final isim = urun["isim"] ?? "Bilinmiyor";
                        final fiyat = urun["fiyat"] ?? 0.0;
                        final adet = urun["adet"] ?? 0;

                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.9),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "$isim  $fiyat TL   $adet Tane",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.remove_circle,
                                  color: Colors.red,
                                ),
                                onPressed: () => adetAzalt(index),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.add_circle,
                                  color: Colors.green,
                                ),
                                onPressed: () => adetArttir(index),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),

            // Sipariş butonu
            ElevatedButton.icon(
              onPressed: () async {
                if (urunler.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Sepetiniz boş, sipariş veremezsiniz."),
                    ),
                  );
                  return;
                }

                try {
                  final userDoc =
                      await _firestore.collection('users').doc(_auth.currentUser!.uid).get();
                  double userBalance = (userDoc['balance'] ?? 0).toDouble();
                  double totalPrice = toplamFiyat();

                  if (userBalance < totalPrice) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Yetersiz bakiye!")),
                    );
                    return;
                  }

                  // Siparişi Firestore'a ekle
                  for (var urun in urunler) {
                    await _firestore.collection('orders').add({
                      'userId': _auth.currentUser!.uid,
                      'productName': urun["isim"],
                      'price': urun["fiyat"],
                      'quantity': urun["adet"],
                      'timestamp': FieldValue.serverTimestamp(),
                    });
                  }

                  // Bakiyeyi düş
                  await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
                    'balance': userBalance - totalPrice,
                  });

                  // Sepeti temizle
                  setState(() {
                    urunler.clear();
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Siparişiniz alındı, bakiye güncellendi!")),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Sipariş hatası: $e")),
                  );
                }
              },
              icon: const Icon(
                Icons.shopping_cart,
                size: 24,
                color: Colors.black,
              ),
              label: const Text(
                'SİPARİŞ VER',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 41, 177, 33),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
