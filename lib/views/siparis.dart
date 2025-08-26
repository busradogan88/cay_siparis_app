import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/anasayfa.dart';
import 'package:flutter_application_1/views/bakiye.dart';
import 'package:flutter_application_1/views/islemgecmisi.dart';
import 'package:flutter_application_1/views/sepetim.dart';
import 'package:flutter_application_1/widgets/order_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/services/firestore_service.dart';
import 'package:flutter_application_1/global.dart';

class Siparis extends StatefulWidget {
  const Siparis({super.key});

  @override
  _SiparisDurumu createState() => _SiparisDurumu();
}

class _SiparisDurumu extends State<Siparis> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Color get _primary => const Color.fromARGB(255, 20, 119, 14);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ——— AppBar: yumuşak gradyan + home butonu
      appBar: AppBar(
        title: const Text(
          'ÇAY SİPARİŞ SİSTEMİ',
          style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green.shade200, Colors.green.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.black87),
          tooltip: 'Ana Sayfa',
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Anasayfa()),
            );
          },
        ),
      ),

      // ——— Drawer (modernize)
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.shade300, Colors.green.shade200],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Colors.green.shade300, size: 32),
                  ),
                  title: const Text(
                    'Meram Çay Sipariş Sistemi',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                  ),
                  subtitle: Text(
                    _auth.currentUser?.email ?? 'Misafir',
                    style: TextStyle(color: Colors.white.withOpacity(0.9)),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _drawerTile(
                    icon: Icons.home,
                    text: 'Ana Sayfa',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const Anasayfa()),
                      );
                    },
                  ),
                  _drawerTile(
                    icon: Icons.shopping_cart,
                    text: 'Sepetim',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const Sepetim()));
                    },
                  ),
                  _drawerTile(
                    icon: Icons.account_balance_wallet,
                    text: 'Bakiye Yükle',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const Bakiye()));
                    },
                  ),
                  _drawerTile(
                    icon: Icons.history,
                    text: 'İşlem Geçmişi',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const Islemgecmisi()));
                    },
                  ),
                  const Divider(height: 24),

                  // Test butonları
                  _drawerTile(
                    icon: Icons.add_shopping_cart,
                    text: 'Örnek Ürünleri Ekle',
                    color: Colors.blue,
                    onTap: () async {
                      Navigator.pop(context);
                      try {
                        await addSampleProductsToFirestore();
                        _snack(context, 'Örnek ürünler başarıyla eklendi!', Colors.green);
                      } catch (e) {
                        _snack(context, 'Ürün ekleme hatası: $e', Colors.red);
                      }
                    },
                  ),
                  _drawerTile(
                    icon: Icons.clear,
                    text: 'Ürünleri Temizle',
                    color: Colors.orange,
                    onTap: () async {
                      Navigator.pop(context);
                      try {
                        await clearAllProducts();
                        _snack(context, 'Tüm ürünler temizlendi!', Colors.orange);
                      } catch (e) {
                        _snack(context, 'Temizleme hatası: $e', Colors.red);
                      }
                    },
                  ),
                  const Divider(height: 24),
                  _drawerTile(
                    icon: Icons.logout,
                    text: 'Çıkış Yap',
                    color: Colors.red,
                    onTap: () async {
                      Navigator.pop(context);
                      await _auth.signOut();
                      _snack(context, 'Başarıyla çıkış yapıldı.', Colors.black87);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // ——— Üst banner + canlı bakiye
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Row(
                children: [
                  // Sol: Başlık kartı
                  Expanded(
                    flex: 6,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.green.shade100),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.08),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.local_cafe, size: 28),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Sipariş Ver',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  'Aşağıdan sipariş verin.',
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Sağ: Bakiye kutusu (canlı)
                  Expanded(
                    flex: 4,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.green.shade100),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.08),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
      textAlign: TextAlign.center, // Ortala
      overflow: TextOverflow.ellipsis, // Taşmayı engelle
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
            ),

            const SizedBox(height: 16),

            // ——— Sepete git butonu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                   Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const Sepetim()),
).then((_) => setState(() {})); // geri dönünce rebuild
                  },
                  icon: const Icon(Icons.shopping_cart, size: 22, color: Colors.black),
                  label: Text(
                    'SEPETE GİT (${urunler.length})',
                    style: const TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 41, 177, 33),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // ——— Ürünler listesi
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore.collection('products').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return _stateCard(
                        icon: Icons.error_outline,
                        title: 'Veri çekme hatası',
                        subtitle: '${snapshot.error}',
                        actionLabel: 'Tekrar Dene',
                        onAction: () => setState(() {}),
                        color: Colors.red,
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return _stateCard(
                        icon: Icons.hourglass_top,
                        title: 'Ürünler yükleniyor...',
                        subtitle: 'Lütfen bekleyin',
                        showSpinner: true,
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return _stateCard(
                        icon: Icons.shopping_cart_outlined,
                        title: 'Henüz ürün eklenmemiş.',
                        subtitle:
                            'Drawer menüsünden "Örnek Ürünleri Ekle" seçeneğini kullanın.',
                        actionLabel: 'Örnek Ürünleri Ekle',
                        onAction: () async {
                          try {
                            await addSampleProductsToFirestore();
                            _snack(context, 'Örnek ürünler eklendi!', Colors.green);
                          } catch (e) {
                            _snack(context, 'Hata: $e', Colors.red);
                          }
                        },
                      );
                    }

                    // ——— Ürünleri kategorilere göre grupla
                    final List<Map<String, dynamic>> products =
                        snapshot.data!.docs.map((doc) {
                      final Map<String, dynamic> data =
                          doc.data() as Map<String, dynamic>;
                      data['id'] = doc.id;
                      return data;
                    }).toList();

                    final Map<String, List<Map<String, dynamic>>> grouped = {};
                    for (final p in products) {
                      final String category = p['category'] ?? 'Diğer';
                      grouped.putIfAbsent(category, () => []);
                      grouped[category]!.add(p);
                    }

                    final categories = grouped.keys.toList();

                    return Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.transparent,
                        splashColor: Colors.green.shade50,
                        highlightColor: Colors.green.shade50,
                        expansionTileTheme: ExpansionTileThemeData(
                          tilePadding: const EdgeInsets.symmetric(horizontal: 12),
                          childrenPadding: const EdgeInsets.only(
                              left: 8, right: 8, bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          collapsedShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          backgroundColor: Colors.white,
                          collapsedBackgroundColor: Colors.white,
                          textColor: _primary,
                          iconColor: _primary,
                          collapsedTextColor: _primary,
                          collapsedIconColor: _primary,
                        ),
                      ),
                      child: ListView.builder(
                        padding: const EdgeInsets.only(bottom: 16),
                        itemCount: categories.length,
                        itemBuilder: (context, idx) {
                          final category = categories[idx];
                          final items = grouped[category]!;

                          return Card(
                            color: Colors.white,
                            elevation: 0,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(color: Colors.green.shade100),
                            ),
                            child: Column(
                              children: [
                                ExpansionTile(
                                  title: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade100,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: const Icon(Icons.category, size: 20),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        category,
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
                                  children: items
                                      .map(
                                        (product) => _productTile(
                                          context: context,
                                          product: product,
                                          onAdd: product['available'] == true
                                              ? () async {
                                                  try {
                                                    // Kullanıcı bakiyesi
                                                    final userDoc = await _firestore
                                                        .collection('users')
                                                        .doc(_auth.currentUser!.uid)
                                                        .get();
                                                    final double userBalance =
                                                        (userDoc['balance'] ?? 0)
                                                            .toDouble();
                                                    final double productPrice =
                                                        product['price'].toDouble();

                                                    if (userBalance < productPrice) {
                                                      _snack(context, 'Yetersiz bakiye!', Colors.red);
                                                      return;
                                                    }

                                                    // Order kaydı
                                                    await _firestore
                                                        .collection('orders')
                                                        .add({
                                                      'userId': _auth.currentUser!.uid,
                                                      'productName': product['name'],
                                                      'price': productPrice,
                                                      'quantity': 1,
                                                      'timestamp': FieldValue.serverTimestamp(),
                                                    });

                                                    // Lokal sepet
                                                    setState(() {
                                                      final idx = urunler.indexWhere(
                                                        (u) => u["isim"] == product["name"],
                                                      );
                                                      if (idx != -1) {
                                                        urunler[idx]["adet"] += 1;
                                                      } else {
                                                        urunler.add({
                                                          "isim": product["name"],
                                                          "fiyat": productPrice,
                                                          "adet": 1,
                                                        });
                                                      }
                                                    });

                                                    _snack(context,
                                                        '${product["name"]} sepete eklendi',
                                                        Colors.green);
                                                  } catch (e) {
                                                    _snack(context, 'Sipariş hatası: $e', Colors.red);
                                                  }
                                                }
                                              : null,
                                        ),
                                      )
                                      .toList(),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ——— Drawer helper
  Widget _drawerTile({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.black87),
      title: Text(
        text,
        style: TextStyle(
          color: color ?? Colors.black87,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: color ?? Colors.black54),
      onTap: onTap,
    );
  }

  // ——— Liste durum kartları (yükleniyor, boş, hata)
  Widget _stateCard({
    required IconData icon,
    required String title,
    String? subtitle,
    String? actionLabel,
    VoidCallback? onAction,
    Color? color,
    bool showSpinner = false,
  }) {
    return Center(
      child: Card(
        color: Colors.white,
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.green.shade100),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 52, color: color ?? Colors.grey),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
              if (showSpinner) ...[
                const SizedBox(height: 16),
                const CircularProgressIndicator(),
              ],
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: onAction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade100,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    actionLabel,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ——— Ürün satırı (ListTile yerine zenginleştirilmiş)
  Widget _productTile({
    required BuildContext context,
    required Map<String, dynamic> product,
    required VoidCallback? onAdd,
  }) {
    final String name = product['name'] ?? 'İsimsiz Ürün';
    final String description = product['description'] ?? '';
    final bool available = product['available'] == true;
    final double price = (product['price'] ?? 0).toDouble();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.green.shade100),
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.local_cafe, color: Colors.black87),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
            _pricePill(price),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.black87),
                ),
              ),
              const SizedBox(width: 8),
              _availabilityChip(available),
            ],
          ),
        ),
        trailing: SizedBox(
          width: 84,
          child: ElevatedButton(
            onPressed: onAdd,
            style: ElevatedButton.styleFrom(
              backgroundColor: available ? Colors.green.shade100 : Colors.grey.shade300,
              elevation: 0,
              minimumSize: const Size(60, 36),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
      ),
    );
  }

  // ——— Fiyat pili
  Widget _pricePill(double price) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Text(
        '${price.toStringAsFixed(2)} TL',
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5),
      ),
    );
  }

  // ——— Uygunluk işareti
  Widget _availabilityChip(bool available) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: available ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: available ? Colors.green.shade200 : Colors.red.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            available ? Icons.check_circle_outline : Icons.cancel_outlined,
            size: 16,
            color: available ? Colors.green.shade800 : Colors.red.shade800,
          ),
          const SizedBox(width: 6),
          Text(
            available ? 'Stokta' : 'Kapalı',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: available ? Colors.green.shade800 : Colors.red.shade800,
            ),
          ),
        ],
      ),
    );
  }

  void _snack(BuildContext context, String msg, Color bg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: bg),
    );
  }
}
