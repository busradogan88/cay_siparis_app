import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    required this.imageName,
    required this.title,
    required this.variants,
  });
  final String imageName;
  final String title;
  final List<Widget> variants;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(imageName, width: 200, height: 200),
        Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),

          Wrap(
         spacing: 8,     
          runSpacing: 8,  
          alignment: WrapAlignment.center,
          children: variants,
          ),
        
      ],
    );
  }
}
