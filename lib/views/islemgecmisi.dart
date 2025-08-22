import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/my_dropdown.dart';

class Islemgecmisi extends StatelessWidget {
  const Islemgecmisi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'İŞLEM GEÇMİŞİ',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Bakiye yükleme ve harcamalarınızı görüntüleyin',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.refresh,
                      size: 24,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "Yenile",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 41, 177, 33),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Container(
                height: 100,
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(20),
                   boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.9),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),]
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/lira.png',
                      width: 50,
                      height: 50,
                    ),
                    const SizedBox(width: 20),
                    const Text(
                      "Mevcut Bakiye",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),
              
              Container(
                height: 100,
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(20),
                   boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.9),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),]
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/increase.png',
                      width: 50,
                      height: 50,
                    ),
                    const SizedBox(width: 20),
                    const Text(
                      "Toplam Gelir",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),
              Container(
                height: 100,
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(20),
                   boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.9),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),]
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/decrease.png',
                      width: 50,
                      height: 50,
                    ),
                    const SizedBox(width: 20),
                    const Text(
                      "Toplam Gider",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),
              Container(
                height: 100,
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(20),
                   boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.9),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),]
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/view.png',
                      width: 50,
                      height: 50,
                    ),
                    const SizedBox(width: 20),
                    const Text(
                      "İşlem Sayısı",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              Container(
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(20),
                   boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.9),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),]
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0), 
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.filter_alt, size: 30, color: Colors.grey),
                          const Text(
                            'FİLTRELER',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'İŞLEM TÜRÜ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          DropdownButtonExample(
                            items: ['Tümü', 'Gelir', 'Gider'],
                            initialValue: 'Tümü',
                            onChanged: null,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'TARİH ARALIĞI',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          DropdownButtonExample(
                            items: ['Bugün', 'Son 7 Gün', 'Son 30 Gün'],
                            initialValue: 'Bugün',
                            onChanged: null,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'KATEGORİ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          DropdownButtonExample(
                            items: ['İçecek', 'Berber'],
                            initialValue: 'İçecek',
                            onChanged: null,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Column(
                children: [
                  Text(
                    'İŞLEMLER',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 200,
                    width: 350,
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(20),
                       boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.9),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),]
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
