import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controlgastos/Mes_widget.dart';
// import 'package:controlgastos/grafico.dart';
// import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'Control de Gastos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

// PAGINA PRINCIPAL
    class HomePage extends StatefulWidget{
  @override
      _HomePageState createState() => _HomePageState();
    }
    class _HomePageState extends State <HomePage> {



      PageController _controller;      // Page controller para controlar la posición del selector de meses
      int currentPage = 9; //Define la página actual (debería ser el mes en curso)
      Stream<QuerySnapshot> _query;      // Define una variable de tipo Stream


      @override
      void initState() {              // Acá se definen los estados iniciales
        super.initState();

        Firestore.instance
            .collection('Gastos')
            .where("Mes", isEqualTo: currentPage+1)
            .snapshots()
            .listen((data) =>
            data.documents.forEach((doc) => print(doc["Categoria"])));

        _controller = PageController(
          initialPage: currentPage,   // Página inicial
          viewportFraction: 0.33,     // Ancho de cada página, para que entre el mes anterior, el actual y el siguiente
                                      // es decir 3 páginas (33%) del 100% del ancho de la pantalla
        );
      }


      // BLOQUE DE LA BARRA DE MENÚ INFERIOR

      Widget _bottomAction(IconData icon) {
        // Widget auxiliar que asigna los iconos con efecto inkwell
        return InkWell( // Efecto de onda al presionar
            child: Padding( //Separación ente íconos
                padding: const EdgeInsets.all(8.0),
                child: Icon(icon)
            )
        );
      }


      @override // Override define que se esta modificando una superclase
      Widget build(BuildContext context) {
        // TODO: implement build
        return Scaffold(
          bottomNavigationBar: BottomAppBar(
              notchMargin: 8.0, // Margen del notch para el boton +
              shape: CircularNotchedRectangle(), //Forma del Notch
              // Barra inferior con 4 íconos
              child: Row( // Como solo adminte un hijo se pone una fila con 4 hijos
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    // Para los hijos se define otro widget que le asigna los íconos definida mas arriba
                    _bottomAction(FontAwesomeIcons.history),
                    _bottomAction(FontAwesomeIcons.chartPie),
                    SizedBox(width: 48.0,),
                    _bottomAction(FontAwesomeIcons.wallet),
                    _bottomAction(Icons.settings),

                  ]
              )
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation
              .centerDocked,
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {},
          ),


          // BLOQUE DE LA BARRA DE MESES SUPERIOR

          body: _body(),
        );
      }


// BLOQUE QUE GENERA LAS DISTINTAS PARTES DE LA PANTALLA
      Widget _body() {
        return SafeArea(
          child: Column(
            children: <Widget>[
              _selector(),        // El Selector de meses
              StreamBuilder<QuerySnapshot>(           // Consulta a la base de datos
                stream: _query,
                builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> data) {
                  if (data.hasData) {
                    return MesWidget(
                        documents: data.data.documents,         // Pasa los datos del StreamBuilder a la función Mes Widget
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
          ],
        ),
        );
      }


      Widget _pageitem(String name, int position) {
        var _alignment;
        final selected = TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey,
        );

        final unselected = TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.normal,
          color: Colors.blueGrey.withOpacity(0.4),
        );


        if (position == currentPage) {
          _alignment = Alignment.center;
        } else if (position > currentPage) {
          _alignment = Alignment.centerRight;
        } else {
          _alignment = Alignment.centerLeft;
        }
        return Align(
          alignment: _alignment,
          child: Text(name,
            style: position == currentPage ? selected : unselected,
          ),
        );
      }

      Widget _selector() {
        return SizedBox.fromSize(
          size: Size.fromHeight(70.0),
          child: PageView(
            onPageChanged: (newPage) {
              setState(() {
                currentPage = newPage;
                // BLOQUE PARA LA BASE DE DATOS, al cambiar la pagina de mes vuelve a consultar la Base de Datos
                // Query
//
             //   _query = Firestore.instance
             //       .collection('Gastos')
             //       .where("Mes", isEqualTo: currentPage+1)
             //       .snapshots();


              });
            },
            controller: _controller,
            // Para control un widget se usa un controler, para lo cual se genera un widget auxiliar linea 28
            children: <Widget>[
              _pageitem("Enero", 0),
              _pageitem("Febrero", 1),
              _pageitem("Marzo", 2),
              _pageitem("Abril", 3),
              _pageitem("Mayo", 4),
              _pageitem("Junio", 5),
              _pageitem("Julio", 6),
              _pageitem("Agosto", 7),
              _pageitem("Setiembre", 8),
              _pageitem("Octubre", 9),
              _pageitem("Noviembre", 10),
              _pageitem("Diciembre", 11),
            ],
          ),
        );
      }

    }