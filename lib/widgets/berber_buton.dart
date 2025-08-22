import 'package:flutter/material.dart';

class BerberButon extends StatelessWidget {
  final String baslik;
  final String fiyat;
  final IconData fiyatIcon;
  final String saat;
  final IconData saatIcon;

  const BerberButon({
    super.key,
    required this.baslik,
    required this.fiyat,
    required this.fiyatIcon,
    required this.saat,
    required this.saatIcon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green[100],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              baslik,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(fiyatIcon, color: Colors.blueGrey, size: 20),
                const SizedBox(width: 8),
                Text(
                  fiyat,
                  style: const TextStyle(fontSize: 16, color: Colors.blueGrey),
                ),
              ],
            ),
            Row(
              children: [
                Icon(saatIcon, color: Colors.blueGrey, size: 20),
                const SizedBox(width: 8),
                Text(
                  saat,
                  style: const TextStyle(fontSize: 16, color: Colors.blueGrey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
