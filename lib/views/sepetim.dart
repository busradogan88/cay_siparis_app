import 'package:flutter/material.dart';

List<Map<String, dynamic>> urunler = [];

class Sepetim extends StatefulWidget {
  const Sepetim({super.key});

  @override
  State<Sepetim> createState() => _SepetimState();
}

class _SepetimState extends State<Sepetim> {
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
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sepetim")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(Icons.shopping_cart, size: 40),
            Text(
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
                 ]
              ),
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Text(
                      "Toplam Ürün: ${urunler.fold<int>(0, (toplam, urun) => toplam + ((urun["adet"] ?? 0) as int))} ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Toplam Fiyat: ${urunler.fold<double>(0.0, (toplam, urun) => toplam + ((urun["fiyat"] ?? 0).toDouble() * ((urun["adet"] ?? 0) as int)))} TL",
                      style: TextStyle(
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
                  ? Center(child: Text("Sepetiniz boş"))
                  : ListView.builder(
                      itemCount: urunler.length,
                      itemBuilder: (context, index) {
                        final urun = urunler[index];
                        final isim = urun["isim"] ?? "Bilinmiyor";
                        final fiyat = urun["fiyat"] ?? 0.0;
                        final adet = urun["adet"] ?? 0;

                        return Container(
                          margin: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 4,
                          ),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(15),
                             boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.9),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),]
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "$isim  $fiyat TL   $adet Tane",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
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
              onPressed: () {
                if (urunler.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Sepetiniz boş, sipariş veremezsiniz."),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Siparişiniz alındı!")),
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
