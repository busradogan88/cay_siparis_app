import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/views/siparis.dart';
import 'package:flutter_application_1/views/bakiye.dart';
import '../services/firestore_user_service.dart';
import 'package:flutter_application_1/views/giris.dart';
import 'package:flutter_application_1/views/sepetim.dart';
import 'package:flutter_application_1/views/islemgecmisi.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({super.key});

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> with SingleTickerProviderStateMixin {
  double _balance = 0.0;
  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    _loadBalance();
  }

  Future<void> _loadBalance() async {
    final userData = await FirestoreUserService.getUserData();
    if (!mounted) return;
    if (userData != null) {
      setState(() {
        _balance = (userData['balance'] ?? 0).toDouble();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primary = const Color.fromARGB(255, 20, 119, 14);

    return Scaffold(
      // Hafif gradyan hissi
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text('Meram Çay Sipariş Sistemi'),
        // Gradyanlı AppBar
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green.shade200, Colors.green.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Bakiyeyi yenile',
            onPressed: _loadBalance,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),

      // Modernize edilmiş Drawer
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
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Colors.green.shade300, size: 32),
                  ),
                  title: Text(
                    user?.email ?? "Kullanıcı",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: Text(
                    'Bakiye: ${_balance.toStringAsFixed(2)} TL',
                    style: TextStyle(color: Colors.white.withOpacity(0.9)),
                  ),
                  trailing: IconButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const Bakiye()),
                      );
                      _loadBalance();
                    },
                    icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                    tooltip: 'Bakiye Yükle',
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
                    text: 'Anasayfa',
                    onTap: () => Navigator.pop(context),
                  ),
                  _drawerTile(
                    icon: Icons.account_balance_wallet,
                    text: 'Bakiye',
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const Bakiye()),
                      );
                      _loadBalance();
                    },
                  ),
                  _drawerTile(
                    icon: Icons.shopping_cart,
                    text: 'Sepetim',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const Sepetim()),
                      );
                    },
                  ),
                  _drawerTile(
                    icon: Icons.list_alt,
                    text: 'Sipariş Ver',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const Siparis()),
                      );
                    },
                  ),
                  _drawerTile(
                    icon: Icons.history,
                    text: 'İşlem Geçmişi',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const Islemgecmisi()),
                      );
                    },
                  ),
                  const Divider(height: 24),
                  _drawerTile(
                    icon: Icons.logout,
                    text: 'Çıkış Yap',
                    color: Colors.redAccent,
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      if (!context.mounted) return;
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const Giris()),
                        (route) => false,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Çıkış yapıldı!')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Gövde: yumuşak arka plan, animasyonlu bakiye, ikonlu butonlar
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: RefreshIndicator(
          onRefresh: _loadBalance,
          color: primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Hero görseli
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.08),
                          blurRadius: 24,
                          offset: const Offset(0, 12),
                        )
                      ],
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/herbal-tea.png',
                          width: 80,
                          height: 80,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hoş Geldiniz!',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  color: primary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Oturum Açıldı ${user?.email ?? 'Kullanıcı'}',
                                style: TextStyle(
                                  fontSize: 15.5,
                                  color: primary.withOpacity(0.9),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Bakiye kartı (cam efekti hissiyatı + animasyon)
                  _BalanceCard(
                    balance: _balance,
                    onTopUp: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const Bakiye()),
                      );
                      _loadBalance();
                    },
                  ),

                  const SizedBox(height: 20),

                  // Aksiyon butonları
                  _primaryActionButton(
                    label: 'Bakiye Yükle',
                    icon: Icons.account_balance_wallet_outlined,
                    background: Colors.green.shade200,
                    textColor: Colors.black,
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const Bakiye()),
                      );
                      _loadBalance();
                    },
                  ),

                  const SizedBox(height: 12),

                  _primaryActionButton(
                    label: 'Sipariş Ver',
                    icon: Icons.local_cafe_outlined,
                    background: Colors.green.shade100,
                    textColor: Colors.black,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const Siparis()),
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  _outlinedActionButton(
                    label: 'Çıkış Yap',
                    icon: Icons.logout,
                    borderColor: Colors.green.shade800,
                    textColor: Colors.green.shade800,
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      if (!context.mounted) return;
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const Giris()),
                        (route) => false,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Çıkış yapıldı!')),
                      );
                    },
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ————— Drawer Tile helper —————
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
          fontWeight: FontWeight.w600,
          color: color ?? Colors.black87,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: (color ?? Colors.black54)),
      onTap: onTap,
    );
  }

  // ————— Primary filled button —————
  Widget _primaryActionButton({
    required String label,
    required IconData icon,
    required Color background,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon, color: textColor),
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text(
            label,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: background,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  // ————— Outlined button —————
  Widget _outlinedActionButton({
    required String label,
    required IconData icon,
    required Color borderColor,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        icon: Icon(icon, color: textColor),
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text(
            label,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: borderColor, width: 1.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}

// ————— Bakiye Kartı Bileşeni —————
class _BalanceCard extends StatelessWidget {
  final double balance;
  final VoidCallback onTopUp;

  const _BalanceCard({
    required this.balance,
    required this.onTopUp,
  });

  @override
  Widget build(BuildContext context) {
    final Color primary = const Color.fromARGB(255, 20, 119, 14);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.green.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.green.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.06),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(12),
            child: const Icon(Icons.account_balance_wallet_outlined, size: 28),

          ),
          const SizedBox(width: 16),
          Expanded(
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 500),
              tween: Tween<double>(begin: 0, end: balance),
              builder: (context, value, _) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bakiye',
                      style: TextStyle(
                        color: primary.withOpacity(0.85),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${value.toStringAsFixed(2)} TL',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: primary,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          TextButton.icon(
            onPressed: onTopUp,
            icon: const Icon(Icons.add),
            label: const Text('Yükle'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.black87,
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.green.shade200),
              ),
              backgroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
