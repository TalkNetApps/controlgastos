import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controlgastos/grafico.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';



class MesWidget extends StatefulWidget {
  final List<DocumentSnapshot> documents;
 // final double total;     //Define variable fija para el total del mes
 // final List<double> perDay;
  //final Map<String, double> categories;


  MesWidget({Key key,this.documents})
      :
     //   total = documents.map((doc)=> doc['value'])
     //   .fold(0.0,(a, b)=>a + b),

        super(key:key);

  @override
  _MesWidgetState createState() => _MesWidgetState();
}

class _MesWidgetState extends State<MesWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
          children: <Widget>[
            _gastos(), // El Texto con el total de Gastos del mes seleccionado
            _grafico(), // El Gráfico
            Container( // Separador celeste entre el gáfico y la lista
              color: Colors.blueAccent.withOpacity(0.15),
              height: 24.0,
            ),
            _lista(), // Y la Lista de Gastos
          ]
      ),
    );
  }


  Widget _gastos() {
    return Column(
      children: <Widget>[
        Text("\$1500",
           style: TextStyle(
           fontWeight: FontWeight.bold,
           fontSize: 40.0,
        ),
        ),
        Text("Total de Gastos",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
      ],
    );
  }

  Widget _grafico() {
    return Container(
      height: 250.0,
      child: GraphWidget(),
    );
  }


// Este Widget asigna una vista ListTile al item, que es como una vista Deck

Widget _item(IconData icon,String name, int percent, double value){
  return ListTile(
    leading: Icon(icon,size:30.0),                     // leading es lo que va al principio, a la izq.
    title: Text(name,                                  // El Titulo del Deck
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0
      ),
    ),
    subtitle: Text("$percent% del total de gastos",  // El subtítulo del Deck
      style: TextStyle(
        fontSize: 16.0,
        color: Colors.blueGrey,
      ),
    ),
    trailing:Container(
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.2),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),

        child: Text("\$$value",                        // Y el campo de la derecha, o cola
          style: TextStyle(
            color: Colors.blueAccent,
            fontWeight: FontWeight.w500,
            fontSize: 16.0,
          ),
        ),
      ),
    ),
  );
}

// Este Widget genera la vista de lista
Widget _lista() {
  return Expanded(              //Expand determina el área a utilizar por la lista, expandiendose a toda el área disponible.
    child: ListView.separated(
      itemCount: 15,
      itemBuilder: (BuildContext context, int index)=>_item(FontAwesomeIcons.shoppingCart,"Shopping",14,145.12),    //Aca se pasan los datos de cada item
      separatorBuilder: (BuildContext context, int index){
        return Container(
          color: Colors.blueAccent.withOpacity(0.15),
          height: 8.0,
        );
      },
    ),
  );
  }
}
