import 'package:bottle_cap_gallery/src/views/utils/item.dart';
import 'package:bottle_cap_gallery/src/views/utils/item_collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum WhyFarther { harder, smarter, selfStarter, tradingCharter }

class ViewItem extends StatefulWidget {
  final Item item;
  ViewItem(this.item);

  @override
  _ViewItemState createState() => _ViewItemState();
}

class _ViewItemState extends State<ViewItem> {
  late Collection provider;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<Collection>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListView(children: [
        AppBar(
          title: Text(widget.item.brandName),
          actions: [
            _popUpMenuButton(),
          ],
        ),
        Container(
          color: Colors.black,
          child: Image.memory(widget.item.image, fit: BoxFit.fill),
        ),
        Text("Bebida: " + widget.item.type),
        Text("Descripción: " + widget.item.description),
        Text("País: " + widget.item.country),
        Text("Ciudad: " + widget.item.city),
        Text("Año de emisión: " + widget.item.releaseDate.toString()),
        Text("Fecha de creación: " + creationDateToString()),
      ]),
    );
  }

  _onDeleteItem() {
    /* return AlertDialog(
      title: Text('¿Seguro que  quieres eliminar este objeto?'),
      content: Text('Esta acción es permanente'),
    ); */
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('¿Seguro que  quieres eliminar este objeto?'),
        content: Text('Esta acción es permanente'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancelar'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              provider.remove(widget.item);
              Navigator.popUntil(context, ModalRoute.withName('/'));
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  _popUpMenuButton() {
    return PopupMenuButton<int>(
      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
        const PopupMenuItem(
          value: 1,
          child: Text('Eliminar'),
        ),
      ],
      onSelected: (value) {
        if (value == 1) {
          return _onDeleteItem();
        }
      },
    );
  }

  String creationDateToString() {
    String date = widget.item.creationDate.day.toString() +
        "-" +
        widget.item.creationDate.month.toString() +
        "-" +
        widget.item.creationDate.year.toString() +
        " " +
        widget.item.creationDate.hour.toString() +
        ":" +
        widget.item.creationDate.minute.toString();
    return date;
  }
}
