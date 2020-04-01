import 'dart:math';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart';

class GraphWidget extends StatefulWidget{
  @override
  _GraphWidgetState createState() => _GraphWidgetState();

}
class _GraphWidgetState extends State<GraphWidget> {
  var data;

  @override
  void initState() {
    super.initState();

    var r = Random();
    data = List<double>.generate(30, (i) => r.nextDouble() *1500); // Genera 30 valores random entre 0 y 1500 para rellenar el gráfico
  }

  _onSelectionChaged(SelectionModel model) {
    final selectedDatum = model.selectedDatum;

    var time;
    final measures = <String, double>{};

    //Obtenemos el modelo que se actualiza con una lista de [SeriesDatum] que es simplemente un par de
    // series y datos.
    //Recorre la selección actualizando el mapa de medidas, almacenando las ventas y el nombre de la serie
    // para cada punto de selección.

    if (selectedDatum.isNotEmpty) {
      time = selectedDatum.first.datum;
      selectedDatum.forEach((SeriesDatum datumPair) {
        measures[datumPair.series.displayName] = datumPair.datum;
      });
    }

    print(time);
    print(measures);
  }

  @override

  // GENERA UNA SERIE DE DATOS ALEATORIOS ENTRE 0 Y 1500 (Que representa los gastos de cada día)
  Widget build(BuildContext context) {
    List<Series<double, num>> series = [
      Series<double, int>(
        id: 'Gastos',
        colorFn: (_, __) => MaterialPalette.blue.shadeDefault,   //Color
        domainFn: (value, index) => index,                       // Datos eje X
        measureFn: (value, _) => value,                          // Datos eje Y
        data: data,                                              // Lista de 30 valores
        strokeWidthPxFn: (_, __) => 4,                           // Ancho de la linea
      )
    ];                                                           // Y llama a la funcion LineChart

    return LineChart(series,         // Llama a la funcion line chart que es un widget
      animate: false,
      selectionModels: [             // Setea que se puede clickear para seleccionar los puntos
        SelectionModelConfig(
          type: SelectionModelType.info,
          changedListener: _onSelectionChaged,    //Cuando se clickea llama a un CallBack
        )
      ],

      // GENERA EL EJE DE DOMINIO QUE ES EL DE LAS X. Con puntos prefijados para que entren los 30 dias
      domainAxis: NumericAxisSpec(
          tickProviderSpec: StaticNumericTickProviderSpec(
              [
                TickSpec(0, label: '01'),
                TickSpec(4, label: '05'),
                TickSpec(9, label: '10'),
                TickSpec(14, label: '15'),
                TickSpec(19, label: '20'),
                TickSpec(24, label: '25'),
                TickSpec(29, label: '30'),
              ]
          )
      ),

      //EN EL EJE PRIMARIO (EJE Y) QUE LO DIVIDA EN 4 PUNTOS PARA PONER LAS ETIQUETAS
      primaryMeasureAxis: NumericAxisSpec(
          tickProviderSpec: BasicNumericTickProviderSpec(
            desiredTickCount: 4,
          )
      ),
    );
  }
}