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
      if ((urunler[index]["adet"] ?? 0) > 1) {
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
          toplam + ((urun["fiyat"] ?? 0).toDouble() * ((urun["adet"] ?? 0) as int)),
    );
  }

  int toplamAdet() {
    return urunler.fold<int>(0, (t, u) => t + ((u["adet"] ?? 0) as int));
  }

  Color get primary => const Color.fromARGB(255, 20, 119, 14);

  @override
  Widget build(BuildContext context) {
    final totalPrice = toplamFiyat();
    final totalCount = toplamAdet();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Sepetim",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green.shade200, Colors.green.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            // ——— Özet kart
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.green.shade100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.07),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.shopping_cart, size: 26, color: Colors.black87),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Toplam Ürün',
                              style: TextStyle(
                                  color: primary.withOpacity(0.9),
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(height: 2),
                          Text(
                            '$totalCount adet',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _pricePill(totalPrice),
                  ],
                ),
              ),
            ),

            // ——— Liste
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: urunler.isEmpty
                    ? _emptyState()
                    : ListView.builder(
                        itemCount: urunler.length,
                        padding: const EdgeInsets.only(bottom: 12),
                        itemBuilder: (context, index) {
                          final urun = urunler[index];
                          final String isim = (urun["isim"] ?? "Bilinmiyor").toString();
                          final double fiyat = (urun["fiyat"] ?? 0.0).toDouble();
                          final int adet = (urun["adet"] ?? 0) as int;

                          return Card(
                            color: Colors.white,
                            elevation: 0,
                            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(color: Colors.green.shade100),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              child: Row(
                                children: [
                                  // Sol ikon/placeholder
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade50,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(Icons.local_cafe, color: Colors.black87),
                                  ),
                                  const SizedBox(width: 12),

                                  // İsim + fiyat dikey
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          isim,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            _miniPricePill(fiyat),
                                            const SizedBox(width: 8),
                                            Text(
                                              'adet: $adet',
                                              style: const TextStyle(
                                                color: Colors.black54,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Miktar kontrol
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove_circle_outline,
                                            color: Colors.red),
                                        onPressed: () => adetAzalt(index),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade50,
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(color: Colors.green.shade200),
                                        ),
                                        child: Text(
                                          '$adet',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold, fontSize: 14),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add_circle_outline,
                                            color: Colors.green),
                                        onPressed: () => adetArttir(index),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),

            // ——— Alt sabit sipariş çubuğu
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  )
                ],
              ),
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Ödenecek Tutar',
                            style: TextStyle(
                                fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 2),
                        Text(
                          '${toplamFiyat().toStringAsFixed(2)} TL',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        if (urunler.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Sepetiniz boş, sipariş veremezsiniz.")),
                          );
                          return;
                        }

                        try {
                          final userDoc = await _firestore
                              .collection('users')
                              .doc(_auth.currentUser!.uid)
                              .get();
                          final double userBalance = (userDoc['balance'] ?? 0).toDouble();
                          final double totalPrice = toplamFiyat();

                          if (userBalance < totalPrice) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Yetersiz bakiye!")),
                            );
                            return;
                          }

                          // Firestore'a order kaydı (mevcut mantık)
                          for (var urun in urunler) {
                            await _firestore.collection('orders').add({
                              'userId': _auth.currentUser!.uid,
                              'productName': urun["isim"],
                              'price': urun["fiyat"],
                              'quantity': urun["adet"],
                              'timestamp': FieldValue.serverTimestamp(),
                            });
                          }

                          // Bakiye düş
                          await _firestore
                              .collection('users')
                              .doc(_auth.currentUser!.uid)
                              .update({'balance': userBalance - totalPrice});

                          // Sepeti temizle
                          setState(() {
                            urunler.clear();
                          });

                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Siparişiniz alındı, bakiye güncellendi!")),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Sipariş hatası: $e")),
                          );
                        }
                      },
                      icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black),
                      label: const Text(
                        'SİPARİŞ VER',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 41, 177, 33),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.green.shade100),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 26),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.shopping_cart_outlined, size: 56, color: Colors.grey),
              SizedBox(height: 12),
              Text(
                "Sepetiniz boş",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 6),
              Text(
                "Ürünleri sipariş sayfasından ekleyebilirsiniz.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pricePill(double price) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Text(
        '${price.toStringAsFixed(2)} TL',
        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
      ),
    );
  }

  Widget _miniPricePill(double price) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Text(
        '${price.toStringAsFixed(2)} TL',
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
      ),
    );
  }
}
