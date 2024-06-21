
import 'package:flutter/material.dart';


class TablaScrolleable extends StatefulWidget {
  const TablaScrolleable({super.key});

  @override
  State<TablaScrolleable> createState() => _TablaScrolleableState();
}

class _TablaScrolleableState extends State<TablaScrolleable> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: buildTable(),
      ),
    );
  }

  Widget buildTable() {
    return Table(
      border: TableBorder.all(),
      children: List.generate(3, (rowIndex) {
        return TableRow(
          children: List.generate(3, (colIndex) {
            return Container(
              padding: const EdgeInsets.all(8),
              child: Text('Fila $rowIndex, Columna $colIndex'),
            );
          }),
        );
      }),
    );
  }
}