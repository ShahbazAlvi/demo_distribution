import 'package:flutter/material.dart';

class AnimationCard extends StatefulWidget {
  final IconData icon;
  final  String title;
  const AnimationCard({super.key, required this.icon, required this.title,});

  @override
  State<AnimationCard> createState() => _AnimatedDashboardCardState();
}

class _AnimatedDashboardCardState extends State<AnimationCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      
      children: [
        Icon(widget.icon,size: 32,color: Colors.black,),
        const SizedBox(height: 10),
        Text(widget.title,style: TextStyle(color: Colors.black),),

      ],
    );
  }
}