import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/berber_buton.dart';
import 'package:flutter_application_1/widgets/my_dropdown.dart';

class Berber extends StatefulWidget {
  const Berber({super.key});

  @override
  State<Berber> createState() => _BerberState();
}

class _BerberState extends State<Berber> {
  List<String> hizmetler = [
    'Ense Düzeltme',
    'Saç Traşı',
    'Sakal Traşı',
    'Saç-Sakal Traşı',
    'Yüz Ağda',
  ];

  List<String> saatler = [
    '09.00',
    '10:00',
    '11:00',
    '13:00',
    '14:00',
    '15:00',
    '16.00',
  ];

  List<String> personeller = ['Ali Kaya', 'Mehmet Kara'];

  // Dropdown’dan seçilen değerler
  String secilenHizmet = 'Saç Traşı';
  String secilenSaat = '09.00';
  String secilenPersonel = 'Ali Kaya';

  // Kaydedilen sıralar
  List<Map<String, String>> siralar = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Başlık
              Row(
                children: const [
                  Icon(Icons.cut, color: Colors.green),
                  SizedBox(width: 5),
                  Text(
                    'Berber Sırası',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'Berber randevunuzu alın ve sıranızı takip edin!',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Butonlar
              Row(
                children: [
                  // Yenile Butonu
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 100,
                      width: 150,
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.refresh,
                          size: 40,
                          color: Colors.white,
                        ),
                        label: const Text(
                          "YENİLE",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            41,
                            177,
                            33,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Sıra Al Butonu
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 100,
                      width: 150,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          showModalBottomSheet<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                padding: const EdgeInsets.all(20),
                                color: Colors.green[100],
                                height: 500,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'Berber Sırası Al',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 20),

                                    // Hizmet Dropdown
                                    DropdownButtonExample(
                                      items: hizmetler,
                                      initialValue: secilenHizmet,
                                      onChanged: (value) {
                                        setState(() {
                                          secilenHizmet = value!;
                                        });
                                      },
                                    ),
                                    const SizedBox(height: 20),

                                    // Personel Dropdown
                                    DropdownButtonExample(
                                      items: personeller,
                                      initialValue: secilenPersonel,
                                      onChanged: (value) {
                                        setState(() {
                                          secilenPersonel = value!;
                                        });
                                      },
                                    ),
                                    const SizedBox(height: 20),

                                    // Saat Dropdown
                                    DropdownButtonExample(
                                      items: saatler,
                                      initialValue: secilenSaat,
                                      onChanged: (value) {
                                        setState(() {
                                          secilenSaat = value!;
                                        });
                                      },
                                    ),

                                    const SizedBox(height: 20),

                                    // Butonlar
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                          ),
                                          child: const Text(
                                            'İptal',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              // Seçilen değerleri kaydet
                                              siralar.add({
                                                "hizmet": secilenHizmet,
                                                "personel": secilenPersonel,
                                                "saat": secilenSaat,
                                              });
                                            });
                                            Navigator.pop(context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                          ),
                                          child: const Text(
                                            'Sıra Al',
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
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.add,
                          size: 40,
                          color: Colors.white,
                        ),
                        label: const Text(
                          "SIRA AL",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            41,
                            177,
                            33,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Sıralarım Container
              Row(
                children: const [
                  Icon(Icons.people, color: Colors.black),
                  SizedBox(width: 5),
                  Text(
                    'Sıralarım',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(10),
                child: siralar.isEmpty
                    ? const Center(
                        child: Text(
                          "Henüz sıra yok",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: siralar.length,
                        itemBuilder: (context, index) {
                          final sira = siralar[index];
                          return Center(
                            child: ListTile(
                              title: Text(
                                sira["hizmet"]!,
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                "${sira["saat"]} - ${sira["personel"]}",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),

              const SizedBox(height: 20),
              const Text(
                'Mevcut Hizmetler',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              BerberButon(
                baslik: 'Ense Düzeltme',
                fiyat: '70 TL',
                fiyatIcon: Icons.currency_lira,
                saat: '20 Dakika',
                saatIcon: Icons.access_time,
              ),
              const SizedBox(height: 20),
              BerberButon(
                baslik: 'Sakal Traşı',
                fiyat: '100 TL',
                fiyatIcon: Icons.currency_lira,
                saat: '30 Dakika',
                saatIcon: Icons.access_time,
              ),
              const SizedBox(height: 20),
              BerberButon(
                baslik: 'Saç Traşı',
                fiyat: '150 TL',
                fiyatIcon: Icons.currency_lira,
                saat: '45 Dakika',
                saatIcon: Icons.access_time,
              ),
              const SizedBox(height: 20),
              BerberButon(
                baslik: 'Saç-Sakal Traşı',
                fiyat: '250 TL',
                fiyatIcon: Icons.currency_lira,
                saat: '60 Dakika',
                saatIcon: Icons.access_time,
              ),
              const SizedBox(height: 20),
              BerberButon(
                baslik: 'Yüz Ağda',
                fiyat: '75 TL',
                fiyatIcon: Icons.currency_lira,
                saat: '30 Dakika',
                saatIcon: Icons.access_time,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
