import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Islemgecmisi extends StatefulWidget {
  const Islemgecmisi({super.key});

  @override
  State<Islemgecmisi> createState() => _IslemgecmisiState();
}

class _IslemgecmisiState extends State<Islemgecmisi> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('İşlem Geçmişi')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
  stream: FirebaseFirestore.instance
      .collection('orders')
      .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
      .orderBy('timestamp', descending: true)
      .snapshots(),
  builder: (context, snapshot) {
    if (snapshot.hasError) {
      return Center(child: Text('Hata: ${snapshot.error}'));
    }
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }
    final docs = snapshot.data?.docs ?? [];
    if (docs.isEmpty) {
      return const Center(child: Text('Hiç işlem bulunamadı.'));
    }

    return ListView.builder(
      itemCount: docs.length,
      itemBuilder: (context, i) {
        final data = docs[i].data();
        final name = data['productName'] ?? '-';
        final qty  = (data['quantity'] ?? 0) as num;
        final price = (data['price'] ?? 0) as num;
        final ts = data['timestamp'] as Timestamp?;
        final date = ts?.toDate();

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: Text('$name x$qty'),
            subtitle: date == null
              ? const Text('Tarih yok')
              : Text('Tarih: ${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2,'0')}'),
            trailing: Text('$price TL'),
          ),
        );
      },
    );
  },
)


    );
  }
}
