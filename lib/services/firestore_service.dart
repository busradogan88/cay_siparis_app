import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addSampleProductsToFirestore() async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Örnek çay ürünleri
  List<Map<String, dynamic>> sampleProducts = [
    {
      'name': 'Türk Çayı',
      'price': 5.0,
      'category': 'Çaylar',
      'imageName': 'herbal-tea.png',
      'description': 'Geleneksel Türk çayı',
      'available': true,
    },
    {
      'name': 'Earl Grey Çay',
      'price': 7.0,
      'category': 'Çaylar',
      'imageName': 'herbal-tea.png',
      'description': 'Bergamot aromalı çay',
      'available': true,
    },
    {
      'name': 'Yeşil Çay',
      'price': 6.0,
      'category': 'Çaylar',
      'imageName': 'herbal-tea.png',
      'description': 'Antioksidan açısından zengin yeşil çay',
      'available': true,
    },
    {
      'name': 'Papatya Çayı',
      'price': 8.0,
      'category': 'Bitki Çayları',
      'imageName': 'herbal-tea.png',
      'description': 'Rahatlatıcı papatya çayı',
      'available': true,
    },
    {
      'name': 'Adaçayı',
      'price': 7.5,
      'category': 'Bitki Çayları',
      'imageName': 'herbal-tea.png',
      'description': 'Şifalı adaçayı',
      'available': true,
    },
    {
      'name': 'Türk Kahvesi',
      'price': 8.0,
      'category': 'Kahveler',
      'imageName': 'herbal-tea.png',
      'description': 'Geleneksel Türk kahvesi',
      'available': true,
    },
    {
      'name': 'Americano',
      'price': 10.0,
      'category': 'Kahveler',
      'imageName': 'herbal-tea.png',
      'description': 'Sade Americano kahve',
      'available': true,
    },
    {
      'name': 'Cappuccino',
      'price': 12.0,
      'category': 'Kahveler',
      'imageName': 'herbal-tea.png',
      'description': 'Sütlü cappuccino',
      'available': true,
    },
    {
      'name': 'Su',
      'price': 2.0,
      'category': 'İçecekler',
      'imageName': 'herbal-tea.png',
      'description': 'İçme suyu',
      'available': true,
    },
    {
      'name': 'Ayran',
      'price': 4.0,
      'category': 'İçecekler',
      'imageName': 'herbal-tea.png',
      'description': 'Geleneksel ayran',
      'available': true,
    },
    {
      'name': 'Limonata',
      'price': 6.0,
      'category': 'İçecekler',
      'imageName': 'herbal-tea.png',
      'description': 'Taze sıkılmış limonata',
      'available': true,
    },
  ];

  try {
    // Her ürünü Firestore'a ekle
    for (var product in sampleProducts) {
      await firestore.collection('products').add(product);
    }
    
    print('Örnek ürünler başarıyla eklendi!');
  } catch (e) {
    print('Ürün ekleme hatası: $e');
    throw e;
  }
}

// Ürünleri temizleme fonksiyonu (test için)
Future<void> clearAllProducts() async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  
  try {
    QuerySnapshot querySnapshot = await firestore.collection('products').get();
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
    print('Tüm ürünler temizlendi!');
  } catch (e) {
    print('Ürün temizleme hatası: $e');
  }
}

Future<void> addOrder(String uid, List<Map<String, dynamic>> cartItems) async {
  final userDoc = FirebaseFirestore.instance.collection('users').doc(uid);

  // Her ürün için ayrı doküman ekleyebilirsin
  for (var item in cartItems) {
    await userDoc.collection('orders').add({
      "productId": item["id"] ?? "",
      "productName": item["isim"],
      "quantity": item["adet"],
      "price": item["fiyat"],
      "timestamp": FieldValue.serverTimestamp(),
    });
  }

  // Sepet temizlenebilir veya bakiye düşme mantığı buraya eklenir
}


