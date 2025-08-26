import 'package:flutter/material.dart';
import '../services/firestore_user_service.dart';

class Bakiye extends StatefulWidget {
  const Bakiye({super.key});

  @override
  State<Bakiye> createState() => _BakiyeState();
}

class _BakiyeState extends State<Bakiye> {
  double _balance = 0.0;
  TextEditingController _customAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();
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

  Future<void> _addBalance(double amount) async {
    await FirestoreUserService.updateBalance(amount);
    await _loadBalance();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$amount TL hesabınıza eklendi!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Bakiye Yükle'),
        centerTitle: true,
        backgroundColor: Colors.green[100],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Image.asset(
                'assets/images/credit-card.png',
                width: 100,
                height: 100,
              ),
              const SizedBox(height: 20),
              Container(
                width: 300,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  'Mevcut Bakiyeniz: $_balance TL',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Yükleme miktarı seçin",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        alignment: WrapAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () => _addBalance(100),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(100, 80),
                              backgroundColor: Colors.white,
                            ),
                            child: const Text(
                              "100 TL",
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => _addBalance(250),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(100, 80),
                              backgroundColor: Colors.white,
                            ),
                            child: const Text(
                              "250 TL",
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => _addBalance(500),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(100, 80),
                              backgroundColor: Colors.white,
                            ),
                            child: const Text(
                              "500 TL",
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => _addBalance(1000),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(100, 80),
                              backgroundColor: Colors.white,
                            ),
                            child: const Text(
                              "1000 TL",
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Özel Tutar",
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _customAmountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Tutarı girin',
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Minimum 100 TL, Maksimum 1000 TL",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          double? amount =
                              double.tryParse(_customAmountController.text);
                          if (amount != null && amount >= 100 && amount <= 1000) {
                            _addBalance(amount);
                            _customAmountController.clear();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      "Geçerli bir tutar girin (100-1000 TL)")),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(150, 60),
                          backgroundColor: Colors.white,
                        ),
                        child: const Text(
                          'Yükleme Yap',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
