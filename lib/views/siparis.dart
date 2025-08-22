import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/bakiye.dart';
import 'package:flutter_application_1/views/berber.dart';
import 'package:flutter_application_1/views/islemgecmisi.dart';
import 'package:flutter_application_1/views/sepetim.dart';
import 'package:flutter_application_1/widgets/order_card.dart';

class Siparis extends StatefulWidget {
  const Siparis({super.key});
  _SiparisDurumu createState() => _SiparisDurumu();
}

class _SiparisDurumu extends State<Siparis> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'MERAM BELEDİYESİ ÇAY SIPARIŞ SİSTEMİ',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        centerTitle: true,
        backgroundColor: Colors.green[100],
        elevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.green[100]),
              child: const Text(
                'Meram Çay Sipariş Sistemi',
                style: TextStyle(color: Colors.black, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Ana Sayfa'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Siparis()),
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
          ],
        ),
      ),
      body: ListView(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  decoration: BoxDecoration(
                    color:const Color.fromARGB(255, 41, 177, 33),
                    borderRadius: BorderRadius.circular(30),
                     boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.9),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                     ]
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sipariş Ver',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          width: 250,
                          child: Text(
                            'AŞAĞIDAN SİPARİŞ VERİN.',
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 16,
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
              Container(
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
                   ]
                   
                ),
                padding: EdgeInsets.all(18),
                child: Column(
                  children: [
                    Text("Bakiye:",style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
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
            label: const Text(
              'SEPETE GİT',
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

          // Sipariş kartı custom widgetleri
          OrderCard(
            imageName: 'assets/images/cay.jpeg',
            title: 'Çay',
            variants: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    int index = urunler.indexWhere(
                      (urun) => urun["isim"] == "Demli Çay",
                    );
                    if (index != -1) {
                      urunler[index]["adet"] += 1;
                    } else {
                      urunler.add({
                        "isim": "Demli Çay",
                        "fiyat": 2.5,
                        "adet": 1,
                      });
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[100],
                ),
                child: const Text(
                  "Demli Çay:2.5 TL",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),

              ElevatedButton(
                onPressed: () {
                  setState(() {
                    int index = urunler.indexWhere(
                      (urun) => urun["isim"] == "Açık Çay",
                    );
                    if (index != -1) {
                      urunler[index]["adet"] += 1;
                    } else {
                      urunler.add({
                        "isim": "Açık Çay",
                        "fiyat": 2.5,
                        "adet": 1,
                      });
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[100],
                ),
                child: const Text(
                  "Açık Çay:2.5 TL",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),

          OrderCard(
            imageName: 'assets/images/bitkicayi.jpeg',
            title: 'BİTKİ ÇAYI',
            variants: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    int index = urunler.indexWhere(
                      (urun) => urun["isim"] == "Ada Çayı",
                    );
                    if (index != -1) {
                      urunler[index]["adet"] += 1;
                    } else {
                      urunler.add({"isim": "Ada Çayı", "fiyat": 3, "adet": 1});
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[100],
                ),
                child: const Text(
                  "Ada Çayı:3 TL",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),

              ElevatedButton(
                onPressed: () {
                  setState(() {
                    int index = urunler.indexWhere(
                      (urun) => urun["isim"] == "Ihlamur",
                    );
                    if (index != -1) {
                      urunler[index]["adet"] += 1;
                    } else {
                      urunler.add({"isim": "Ihlamur", "fiyat": 3, "adet": 1});
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[100],
                ),
                child: const Text(
                  "  Ihlamur :3 TL",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    int index = urunler.indexWhere(
                      (urun) => urun["isim"] == "Kekik",
                    );
                    if (index != -1) {
                      urunler[index]["adet"] += 1;
                    } else {
                      urunler.add({"isim": "Kekik", "fiyat": 3, "adet": 1});
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[100],
                ),
                child: const Text(
                  "  Kekik :3 TL",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          OrderCard(
            imageName: 'assets/images/tozicecek.jpeg',
            title: 'TOZ İÇECEKLER',
            variants: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    int index = urunler.indexWhere(
                      (urun) => urun["isim"] == "Kivi",
                    );
                    if (index != -1) {
                      urunler[index]["adet"] += 1;
                    } else {
                      urunler.add({"isim": "Kivi", "fiyat": 4, "adet": 1});
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[100],
                ),
                child: const Text(
                  "Kivi:4 TL",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),

              ElevatedButton(
                onPressed: () {
                  setState(() {
                    int index = urunler.indexWhere(
                      (urun) => urun["isim"] == "Portakal",
                    );
                    if (index != -1) {
                      urunler[index]["adet"] += 1;
                    } else {
                      urunler.add({"isim": "Portakal", "fiyat": 4, "adet": 1});
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[100],
                ),
                child: const Text(
                  "Portakal:4 TL",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    int index = urunler.indexWhere(
                      (urun) => urun["isim"] == "Nane-Limon",
                    );
                    if (index != -1) {
                      urunler[index]["adet"] += 1;
                    } else {
                      urunler.add({
                        "isim": "Nane-Limon",
                        "fiyat": 4,
                        "adet": 1,
                      });
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[100],
                ),
                child: const Text(
                  "Nane-Limon:4 TL",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),

              ElevatedButton(
                onPressed: () {
                  setState(() {
                    int index = urunler.indexWhere(
                      (urun) => urun["isim"] == "Tarçın",
                    );
                    if (index != -1) {
                      urunler[index]["adet"] += 1;
                    } else {
                      urunler.add({"isim": "Tarçın", "fiyat": 4, "adet": 1});
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[100],
                ),
                child: const Text(
                  "Tarçın:4 TL",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          OrderCard(
            imageName: 'assets/images/pexels-caffeine-33482823.jpg',
            title: 'TÜRK KAHVESİ',
            variants: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    int index = urunler.indexWhere(
                      (urun) => urun["isim"] == "TÜRK KAHVESİ(SADE)",
                    );
                    if (index != -1) {
                      urunler[index]["adet"] += 1;
                    } else {
                      urunler.add({
                        "isim": "TÜRK KAHVESİ(SADE)",
                        "fiyat": 15,
                        "adet": 1,
                      });
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[100],
                ),
                child: const Text(
                  "Sade:15 TL",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),

              ElevatedButton(
                onPressed: () {
                  setState(() {
                    int index = urunler.indexWhere(
                      (urun) => urun["isim"] == "TÜRK KAHVESİ(ORTA)",
                    );
                    if (index != -1) {
                      urunler[index]["adet"] += 1;
                    } else {
                      urunler.add({
                        "isim": "TÜRK KAHVESİ(ORTA)",
                        "fiyat": 15,
                        "adet": 1,
                      });
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[100],
                ),
                child: const Text(
                  " Orta :15 TL",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    int index = urunler.indexWhere(
                      (urun) => urun["isim"] == "TÜRK KAHVESİ(ŞEKERLİ)",
                    );
                    if (index != -1) {
                      urunler[index]["adet"] += 1;
                    } else {
                      urunler.add({
                        "isim": "TÜRK KAHVESİ(ŞEKERLİ)",
                        "fiyat": 15,
                        "adet": 1,
                      });
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[100],
                ),
                child: const Text(
                  "  Şekerli:15 TL",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          OrderCard(
            imageName: 'assets/images/pexels-caffeine-33482823.jpg',
            title: 'MENENGİÇ KAHVESİ',
            variants: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    int index = urunler.indexWhere(
                      (urun) => urun["isim"] == "Menengiç KAHVESİ(SADE)",
                    );
                    if (index != -1) {
                      urunler[index]["adet"] += 1;
                    } else {
                      urunler.add({
                        "isim": "Menengiç KAHVESİ(SADE)",
                        "fiyat": 15,
                        "adet": 1,
                      });
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[100],
                ),
                child: const Text(
                  "Sade:15 TL",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),

              ElevatedButton(
                onPressed: () {
                  setState(() {
                    int index = urunler.indexWhere(
                      (urun) => urun["isim"] == "Menengiç Kahvesi(ORTA)",
                    );
                    if (index != -1) {
                      urunler[index]["adet"] += 1;
                    } else {
                      urunler.add({
                        "isim": "Menengiç Kahvesi(ORTA)",
                        "fiyat": 15,
                        "adet": 1,
                      });
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[100],
                ),
                child: const Text(
                  " Orta :15 TL",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),

              ElevatedButton(
                onPressed: () {
                  setState(() {
                    int index = urunler.indexWhere(
                      (urun) => urun["isim"] == "Menengiç Kahvesi(ŞEKERLİ)",
                    );
                    if (index != -1) {
                      urunler[index]["adet"] += 1;
                    } else {
                      urunler.add({
                        "isim": "Menengiç Kahvesi(ŞEKERLİ)",
                        "fiyat": 15,
                        "adet": 1,
                      });
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[100],
                ),
                child: const Text(
                  "  Şekerli:15 TL",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          OrderCard(
            imageName: 'assets/images/kahve.jpeg',
            title: 'HAZIR KAHVE',
            variants: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    int index = urunler.indexWhere(
                      (urun) => urun["isim"] == "Hazır Kahve",
                    );
                    if (index != -1) {
                      urunler[index]["adet"] += 1;
                    } else {
                      urunler.add({
                        "isim": "Hazır Kahve",
                        "fiyat": 10.5,
                        "adet": 1,
                      });
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[100],
                ),
                child: const Text(
                  "10.5 TL",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),

          OrderCard(
            imageName: 'assets/images/soda.jpeg',
            title: 'SODA',
            variants: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    int index = urunler.indexWhere(
                      (urun) => urun["isim"] == "Sade Soda",
                    );
                    if (index != -1) {
                      urunler[index]["adet"] += 1;
                    } else {
                      urunler.add({
                        "isim": "Sade Soda",
                        "fiyat": 7.5,
                        "adet": 1,
                      });
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[100],
                ),
                child: const Text(
                  "Sade:7.5 TL",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),

              ElevatedButton(
                onPressed: () {
                  setState(() {
                    int index = urunler.indexWhere(
                      (urun) => urun["isim"] == "Limonlu Soda",
                    );
                    if (index != -1) {
                      urunler[index]["adet"] += 1;
                    } else {
                      urunler.add({
                        "isim": "Limonlu Soda",
                        "fiyat": 9.5,
                        "adet": 1,
                      });
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[100],
                ),
                child: const Text(
                  " Limon :9.5 TL",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  
                    color: Colors.black,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    int index = urunler.indexWhere(
                      (urun) => urun["isim"] == "Karpuz-Çilek Soda",
                    );
                    if (index != -1) {
                      urunler[index]["adet"] += 1;
                    } else {
                      urunler.add({
                        "isim": "Karpuz-Çilek Soda",
                        "fiyat": 4,
                        "adet": 1,
                      });
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[100],
                ),
                child: const Text(
                  " Karpuz-Çilek:9.5 TL",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),

          OrderCard(
            imageName: 'assets/images/gazoz.jpeg',
            title: 'GAZOZ',
            variants: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    int index = urunler.indexWhere(
                      (urun) => urun["isim"] == "Gazoz",
                    );
                    if (index != -1) {
                      urunler[index]["adet"] += 1;
                    } else {
                      urunler.add({"isim": "Gazoz", "fiyat": 12.5, "adet": 1});
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[100],
                ),
                child: const Text(
                  "12.5 TL",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),

          OrderCard(
            imageName: 'assets/images/bardaksu.jpeg',
            title: 'BARDAK SU',
            variants: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    int index = urunler.indexWhere(
                      (urun) => urun["isim"] == "Bardak Su (KÜÇÜK)",
                    );
                    if (index != -1) {
                      urunler[index]["adet"] += 1;
                    } else {
                      urunler.add({
                        "isim": "Bardak Su (KÜÇÜK)",
                        "fiyat": 1.5,
                        "adet": 1,
                      });
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[100],
                ),
                child: const Text(
                  "Küçük:1.5 TL",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),

              ElevatedButton(
                onPressed: () {
                  setState(() {
                    int index = urunler.indexWhere(
                      (urun) => urun["isim"] == "Bardak Su(BÜYÜK)",
                    );
                    if (index != -1) {
                      urunler[index]["adet"] += 1;
                    } else {
                      urunler.add({
                        "isim": "Bardak Su(BÜYÜK)",
                        "fiyat": 2.5,
                        "adet": 1,
                      });
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[100],
                ),
                child: const Text(
                  " Büyük :2.5 TL",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          OrderCard(
            imageName: 'assets/images/sıcaksu.jpeg',
            title: 'SICAK SU',
            variants: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    int index = urunler.indexWhere(
                      (urun) => urun["isim"] == "Sıcak Su(BÜYÜK)",
                    );
                    if (index != -1) {
                      urunler[index]["adet"] += 1;
                    } else {
                      urunler.add({
                        "isim": "Sıcak Su(BÜYÜK)",
                        "fiyat": 3.5,
                        "adet": 1,
                      });
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[100],
                ),
                child: const Text(
                  "Büyük:3.5 TL",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),

              ElevatedButton(
                onPressed: () {
                  setState(() {
                    int index = urunler.indexWhere(
                      (urun) => urun["isim"] == "Sıcak Su(KÜÇÜK)",
                    );
                    if (index != -1) {
                      urunler[index]["adet"] += 1;
                    } else {
                      urunler.add({
                        "isim": "Sıcak Su(KÜÇÜK)",
                        "fiyat": 2.5,
                        "adet": 1,
                      });
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[100],
                ),
                child: const Text(
                  " Küçük :2.5 TL",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
