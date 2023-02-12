import 'package:flutter/material.dart';

import 'dishgroup_cat.dart';

class DishList extends StatefulWidget {
  final List<DishGroupCat> dishGroups;

  const DishList({super.key, required this.dishGroups});

  @override
  _DishListState createState() => _DishListState();
}

class _DishListState extends State<DishList> {
  List<ExpansionPanel> _expansionPanels = [];
  List<bool> _isExpanded = [];

  @override
  void initState() {
    super.initState();
    _expansionPanels = List.generate(widget.dishGroups.length, (index) {
      return ExpansionPanel(
        headerBuilder: (BuildContext context, bool isExpanded) {
          return ListTile(
            title: Text(widget.dishGroups[index].kategorie),
          );
        },
        body: Column(
          children: widget.dishGroups[index].gerichteingruppe.map((dish) {
            return ListTile(
              title: Text(dish.name),
              subtitle: Text(dish.price),
            );
          }).toList(),
        ),
      );
    });

    _isExpanded = List.filled(widget.dishGroups.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _isExpanded[index] = !_isExpanded[index];
        });
      },
      children: _expansionPanels,
    );
  }
}
