import 'components/body.dart';
import 'package:flutter/material.dart';

class HomeDirect extends StatelessWidget{final String nombre;
  final String instituto;

  const HomeDirect({super.key, required this.nombre, required this.instituto});
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Body(nombre:nombre, instituto: instituto,),
    );
  }


}