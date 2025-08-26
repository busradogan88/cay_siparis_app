import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/anasayfa.dart'; // Ana sayfa import edildi
import 'package:flutter_application_1/views/bakiye.dart';
import 'package:flutter_application_1/views/berber.dart';
import 'package:flutter_application_1/views/islemgecmisi.dart';
import 'package:flutter_application_1/views/sepetim.dart';
import 'package:flutter_application_1/widgets/order_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/services/firestore_service.dart';
import 'package:flutter_application_1/global.dart';

// Global ürünler listesi



class Siparis extends StatefulWidget {
  const Siparis({super.key});

  @override
  _SiparisDurumu createState() => _SiparisDurumu();
}

class _SiparisDurumu extends State<Siparis> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'ÇAY SİPARİŞ SİSTEMİ',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        centerTitle: true,
        backgroundColor: Colors.green[100],
        elevation: 0,
        // Ana sayfaya dönüş butonu eklendi
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Anasayfa()),
            );
          },
          tooltip: 'Ana Sayfa',
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.green[100]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Meram Çay Sipariş Sistemi',
                    style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _auth.currentUser?.email ?? 'Misafir',
                    style: const TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Ana Sayfa'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Anasayfa()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text('Sepetim'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Sepetim()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet),
              title: const Text('Bakiye Yükle'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Bakiye()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('İşlem Geçmişi'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Islemgecmisi()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.cut),
              title: const Text('Berber Sırası'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Berber()),
                );
              },
            ),
            const Divider(),
            // Ürün ekleme butonu (Test için)
            ListTile(
              leading: const Icon(Icons.add_shopping_cart, color: Colors.blue),
              title: const Text('Örnek Ürünleri Ekle', style: TextStyle(color: Colors.blue)),
              onTap: () async {
                Navigator.pop(context);
                try {
                  await addSampleProductsToFirestore();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Örnek ürünler başarıyla eklendi!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Ürün ekleme hatası: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
            // Ürünleri temizleme butonu (Test için)
            ListTile(
              leading: const Icon(Icons.clear, color: Colors.orange),
              title: const Text('Ürünleri Temizle', style: TextStyle(color: Colors.orange)),
              onTap: () async {
                Navigator.pop(context);
                try {
                  await clearAllProducts();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Tüm ürünler temizlendi!'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Temizleme hatası: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Çıkış Yap', style: TextStyle(color: Colors.red)),
              onTap: () async {
                Navigator.pop(context);
                await _auth.signOut();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Başarıyla çıkış yapıldı.')),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Üst banner kısmı
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 41, 177, 33),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.9),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sipariş Ver',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          width: 200,
                          child: Text(
                            'Aşağıdan sipariş verin.',
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color.fromARGB(255, 41, 177, 33),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.9),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(18),
                 child: Column(
  children: [
    StreamBuilder<DocumentSnapshot>(
      stream: _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Text("Bakiye: Yükleniyor...");
        }

        double balance = (snapshot.data!['balance'] ?? 0).toDouble();

        return Text(
          "Bakiye: ${balance.toStringAsFixed(2)} TL",
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    ),
  ],
),

                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Sepete git butonu
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Sepetim()),
              );
            },
            icon: const Icon(
              Icons.shopping_cart,
              size: 24,
              color: Colors.black,
            ),
            label: Text(
              'SEPETE GİT (${urunler.length})',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 41, 177, 33),
            ),
          ),
          const SizedBox(height: 20),

          // Ürünler listesi
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('products').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text('Veri çekme hatası: ${snapshot.error}'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {}); // Yeniden yükle
                          },
                          child: const Text('Tekrar Dene'),
                        ),
                      ],
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Ürünler yükleniyor...'),
                      ],
                    ),
                  );
                }

                // Veri yok kontrolü
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        const Text(
                          'Henüz ürün eklenmemiş.',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        const Text('Drawer menüsünden "Örnek Ürünleri Ekle" seçeneğini kullanın.'),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () async {
                            try {
                              await addSampleProductsToFirestore();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Örnek ürünler eklendi!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Hata: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Örnek Ürünleri Ekle'),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green[100]),
                        ),
                      ],
                    ),
                  );
                }
                                      
                // Ürünleri kategorilere göre grupla
                final List<Map<String, dynamic>> products = snapshot.data!.docs.map((doc) {
                  Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                  data['id'] = doc.id; // Document ID'yi ekle
                  return data;
                }).toList();

                Map<String, List<Map<String, dynamic>>> groupedProducts = {};
                for (var product in products) {
                  String category = product['category'] ?? 'Diğer';
                  if (!groupedProducts.containsKey(category)) {
                    groupedProducts[category] = [];
                  }
                  groupedProducts[category]!.add(product);
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: groupedProducts.keys.length,
                  itemBuilder: (context, index) {
                    String category = groupedProducts.keys.elementAt(index);
                    List<Map<String, dynamic>> categoryProducts = groupedProducts[category]!;

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ExpansionTile(
                        title: Text(
                          category,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 20, 119, 14),
                          ),
                        ),
                        children: categoryProducts.map((product) {
                          return ListTile(
                            leading: const Icon(
                              Icons.local_cafe,
                              color: Color.fromARGB(255, 20, 119, 14),
                            ),
                            title: Text(product['name'] ?? 'İsimsiz Ürün'),
                            subtitle: Text(product['description'] ?? ''),
                           trailing: SizedBox(
  width: 70, // Column ve button için sabit genişlik
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        '${product['price']} TL',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        overflow: TextOverflow.ellipsis, // Taşmayı önler
      ),
      const SizedBox(height: 4),
      SizedBox(
        width: double.infinity, // Column genişliğine uyumlu
        height: 30,
        child: ElevatedButton(
          onPressed: product['available'] == true
              ? () async {
                  try {
                    // Kullanıcı bakiyesini çek
                    final userDoc = await _firestore
                        .collection('users')
                        .doc(_auth.currentUser!.uid)
                        .get();
                    double userBalance = (userDoc['balance'] ?? 0).toDouble();
                    double productPrice = product['price'].toDouble();

                    // Bakiye kontrol
                    if (userBalance < productPrice) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Yetersiz bakiye!')),
                      );
                      return;
                    }

                    // Firestore'a order ekle
                    await _firestore.collection('orders').add({
                      'userId': _auth.currentUser!.uid,
                      'productName': product['name'],
                      'price': productPrice,
                      'quantity': 1,
                      'timestamp': FieldValue.serverTimestamp(),
                    });

                    // Lokal listeyi güncelle ve UI'yi yenile
                    setState(() {
                      int itemIndex = urunler.indexWhere(
                          (urun) => urun["isim"] == product["name"]);
                      if (itemIndex != -1) {
                        urunler[itemIndex]["adet"] += 1;
                      } else {
                        urunler.add({
                          "isim": product["name"],
                          "fiyat": productPrice,
                          "adet": 1,
                        });
                      }
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text('${product["name"]} sepete eklendi')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Sipariş hatası: $e')),
                    );
                  }
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[100],
            minimumSize: const Size(60, 30),
          ),
          child: const Text(
            'Ekle',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
    ],
  ),
),

                          );
                        }).toList(),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}