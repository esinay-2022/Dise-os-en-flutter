import 'package:flutter/material.dart';

class BasicDesignScreen extends StatelessWidget {
   
  const BasicDesignScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [

          //Imagen central
        Image(image:AssetImage('assets/landscape.jpg')),
        
        // titulo
        Title(),

        // Seleccionar boton
        ButtonSection(),

        // Descripcion
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Text('Et excepteur dolor veniam fugiat nisi non quis irure labore laboris est. Amet adipisicing pariatur pariatur laboris laborum magna culpa Lorem consequat laborum. Amet magna tempor consequat anim consequat exercitation quis. Voluptate duis est deserunt labore tempor elit mollit. Esse Lorem in velit do fugiat proident. Occaecat cupidatat anim irure enim est. Non excepteur minim sunt veniam sunt aute nostrud esse.')),
      ],
      ),
    );
  }
}

class Title extends StatelessWidget {

  const Title({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal:30, vertical: 10 ),
      child: Row(
        
        children: [

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
            Text('Oschinen Lake Campground', style: TextStyle(fontWeight: FontWeight.bold),),
            Text('Kandersteg, Switzelarand', style: TextStyle(color: Colors.black45),),
          ],
          ),
          Expanded(child: Container(),),
          
          Icon(Icons.star, color: Colors.red),
          Text('41')
      ],),
    );
  }
}

class ButtonSection extends StatelessWidget {
  const ButtonSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,

          children: const[

            CustomButton(icon: Icons.call, text: 'CALL'),
            CustomButton(icon: Icons.send, text: 'ROUTE'),
            CustomButton(icon: Icons.share, text: 'SHARE'),
        ],), 
    );
  }
}

class CustomButton extends StatelessWidget {

  final IconData icon;
  final String text;

  const CustomButton({
    Key? key,
     required this.icon,
     required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(            

      children: [
        Icon(this.icon, color: Colors.blue, size: 30,),
        Text(this.text, style: TextStyle(color: Colors.blue)),
      ],
    );
  }
}
