import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth'u import et
// import 'package:flutter_application_1/views/siparis.dart'; // Giriş başarılıysa gidilecek sayfa
import '../services/firestore_user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/views/anasayfa.dart';


// Giris widget'ını StatelessWidget yerine StatefulWidget yapıyoruz
class Giris extends StatefulWidget {
  const Giris({super.key});

  @override
  State<Giris> createState() => _GirisState();
}

class _GirisState extends State<Giris> {
  // Kullanıcı adı (e-posta) ve şifre için Controller'lar tanımlıyoruz
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Firebase Authentication örneğini alıyoruz
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Şu anki mod: true = Giriş Yap, false = Kayıt Ol (varsayılan giriş yap)
  bool _isLoginMode = true; 

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // --- Firebase Authentication Metodları ---

  // Kullanıcı Giriş Yapma Metodu
  Future<void> _signInUser() async {
  // Alanların boş olup olmadığını kontrol et
  if (_emailController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Lütfen e-posta ve şifre alanlarını doldurun.'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  try {
    await _auth.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
    
    // Giriş başarılı olursa - Ana sayfaya yönlendir
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Giriş başarılı!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ),
      );
      
      // Ana sayfaya yönlendir ve giriş sayfasını temizle
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Anasayfa()),
        (route) => false, // Tüm önceki sayfaları temizle
      );
    }
    
  } on FirebaseAuthException catch (e) {
    // Firebase'den gelen hataları yakala
    String errorMessage;
    
    switch (e.code) {
      case 'user-not-found':
        errorMessage = 'Bu e-posta adresiyle kayıtlı kullanıcı bulunamadı.';
        break;
      case 'wrong-password':
        errorMessage = 'Yanlış şifre girdiniz. Lütfen tekrar deneyin.';
        break;
      case 'invalid-email':
        errorMessage = 'Geçersiz e-posta formatı girdiniz.';
        break;
      case 'user-disabled':
        errorMessage = 'Bu hesap devre dışı bırakılmış.';
        break;
      case 'too-many-requests':
        errorMessage = 'Çok fazla başarısız giriş denemesi. Lütfen daha sonra tekrar deneyin.';
        break;
      case 'network-request-failed':
        errorMessage = 'İnternet bağlantısı hatası. Bağlantınızı kontrol edin.';
        break;
      case 'invalid-credential':
        errorMessage = 'E-posta veya şifre hatalı. Lütfen tekrar kontrol edin.';
        break;
      case 'channel-error':
        errorMessage = 'Lütfen tüm alanları doldurun.';
        break;
      case 'operation-not-allowed':
        errorMessage = 'E-posta/şifre girişi etkinleştirilmemiş.';
        break;
      default:
        errorMessage = 'Giriş sırasında bir hata oluştu. Lütfen tekrar deneyin.';
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
      ),
    );
    
  } catch (e) {
    // Diğer genel hatalar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Beklenmedik bir hata oluştu. Lütfen tekrar deneyin.'),
        backgroundColor: Colors.red,
      ),
    );
  }
}


Future<void> _signUpUser() async {
  // Alanların boş olup olmadığını kontrol et
  if (_emailController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Lütfen e-posta ve şifre alanlarını doldurun.'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  // Şifre uzunluk kontrolü
  if (_passwordController.text.trim().length < 6) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Şifre en az 6 karakter olmalıdır.'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  try {
    // 1. Firebase Auth ile kullanıcı oluştur
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    // 2. Firestore'da users collection'a ekle
    final user = userCredential.user;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'email': user.email,
        'balance': 0.0,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Kayıt başarılı! Şimdi giriş yapabilirsiniz.'),
        backgroundColor: Colors.green,
      ),
    );

    setState(() {
      _isLoginMode = true;
      // Alanları temizle
      _emailController.clear();
      _passwordController.clear();
    });
    
  } on FirebaseAuthException catch (e) {
    String errorMessage;
    
    switch (e.code) {
      case 'weak-password':
        errorMessage = 'Şifre çok zayıf. Lütfen daha güçlü bir şifre seçin.';
        break;
      case 'email-already-in-use':
        errorMessage = 'Bu e-posta adresi zaten kullanımda. Giriş yapmayı deneyin.';
        break;
      case 'invalid-email':
        errorMessage = 'Geçersiz e-posta formatı girdiniz.';
        break;
      case 'operation-not-allowed':
        errorMessage = 'E-posta/şifre kaydı etkinleştirilmemiş.';
        break;
      case 'network-request-failed':
        errorMessage = 'İnternet bağlantısı hatası. Bağlantınızı kontrol edin.';
        break;
      default:
        errorMessage = 'Kayıt sırasında bir hata oluştu. Lütfen tekrar deneyin.';
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
      ),
    );
    
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Beklenmedik bir hata oluştu. Lütfen tekrar deneyin.'),
        backgroundColor: Colors.red,
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Meram Çay Sipariş Sistemi'),
        centerTitle: true,
        backgroundColor: Colors.green[100],
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/herbal-tea.png', // Resim yolunu kontrol edin
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 5),
            Text(
              _isLoginMode ? 'Hoş geldiniz!' : 'Kaydolun!', // Mod'a göre başlık değişir
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 20, 119, 14),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _isLoginMode
                  ? 'Çay ve içecek siparişi vermek için giriş yapın'
                  : 'Yeni bir hesap oluşturun', // Mod'a göre açıklama değişir
              style: const TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 20, 119, 14),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
         Container(
  padding: const EdgeInsets.symmetric(horizontal: 16.0),
  margin: const EdgeInsets.symmetric(horizontal: 24.0),
  decoration: BoxDecoration(
    color: Colors.green[100],
    borderRadius: BorderRadius.circular(30),
  ),
  child: TextField(
    controller: _emailController,
    keyboardType: TextInputType.text, // Normal klavye
    textInputAction: TextInputAction.next,
    autocorrect: false,
    enableSuggestions: false,
    decoration: const InputDecoration(
      labelText: 'E-posta',
      hintText: 'ornek@email.com',
      border: InputBorder.none,
      suffixIcon: Icon(Icons.email),
    ),
  ),
),
            const SizedBox(height: 20),
            Container(
  padding: const EdgeInsets.symmetric(horizontal: 16.0),
  margin: const EdgeInsets.symmetric(horizontal: 24.0),
  decoration: BoxDecoration(
    color: Colors.green[100],
    borderRadius: BorderRadius.circular(30),
  ),
  child: TextField(
    controller: _passwordController,
    obscureText: true,
    textInputAction: TextInputAction.done, // Klavyeyi kapat
    decoration: const InputDecoration(
      labelText: 'Şifre',
      hintText: 'Şifrenizi girin',
      border: InputBorder.none,
      suffixIcon: Icon(Icons.lock),
    ),
  ),
),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoginMode ? _signInUser : _signUpUser, // Moda göre fonksiyon çağır
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[100],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 16,
                ),
              ),
              child: Text(
                _isLoginMode ? 'Giriş Yap' : 'Kayıt Ol', // Moda göre buton metni
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10), // Kayıt Ol/Giriş Yap metni için boşluk
            TextButton(
              onPressed: () {
                setState(() {
                  _isLoginMode = !_isLoginMode; // Modu değiştir
                });
              },
              child: Text(
                _isLoginMode
                    ? 'Hesabınız yok mu? Şimdi Kayıt Olun'
                    : 'Zaten hesabınız var mı? Giriş Yapın',
                style: TextStyle(
                  color: Colors.green[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // TODO: Şifremi unuttum butonu eklenebilir
            // if (_isLoginMode)
            //   TextButton(
            //     onPressed: () async {
            //       try {
            //         await _auth.sendPasswordResetEmail(email: _emailController.text.trim());
            //         ScaffoldMessenger.of(context).showSnackBar(
            //           const SnackBar(content: Text('Şifre sıfırlama linki e-postanıza gönderildi.')),
            //         );
            //       } on FirebaseAuthException catch (e) {
            //         ScaffoldMessenger.of(context).showSnackBar(
            //           SnackBar(content: Text('Hata: ${e.message}')),
            //         );
            //       }
            //     },
            //     child: const Text('Şifremi Unuttum?', style: TextStyle(color: Colors.green[800])),
            //   ),
          ],
        ),
      ),
    );
  }
}
