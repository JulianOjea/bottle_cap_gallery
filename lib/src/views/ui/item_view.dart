import 'dart:typed_data';

import 'package:bottle_cap_gallery/src/views/ui/add_edit_item_view.dart';
import 'package:bottle_cap_gallery/src/views/utils/item.dart';
import 'package:bottle_cap_gallery/src/views/utils/item_collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//It provides a view of a concrete item of the collection
//Uses ListView to display a full list of the item fields
//Adds edit and delete functionalitty with a PopUpMenuButton
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
          automaticallyImplyLeading: false,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Color.fromARGB(255, 197, 230, 166)),
          title: Text(widget.item.brandName,
              style: TextStyle(
                  color: Color.fromARGB(255, 197, 230, 166), fontSize: 30)),
          backgroundColor: Color.fromARGB(255, 189, 139, 156),
          actionsIconTheme:
              IconThemeData(color: Color.fromARGB(255, 197, 230, 166)),
          actions: [
            _popUpMenuButton(),
          ],
        ),
        /*Container(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: SizedBox(
                    child: Text(widget.item.brandName,
                        style: TextStyle(
                            color: Color.fromARGB(255, 197, 230, 166),
                            fontSize: 30)),
                  ),
                ),
                _popUpMenuButton()
              ],
            ),
          ),
        ),*/
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            color: Colors.black,
            child: Image.memory(widget.item.image, fit: BoxFit.fill),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Bebida: " + widget.item.type),
              SizedBox(height: 10),
              Text("Descripción: " + widget.item.description),
              SizedBox(height: 10),
              Text("País: " + widget.item.country),
              SizedBox(height: 10),
              Text("Ciudad: " + widget.item.city),
              SizedBox(height: 10),
              Text("Año de emisión: " + widget.item.releaseDate.toString()),
              SizedBox(height: 10),
              Text("Fecha de creación: " + creationDateToString()),
            ],
          ),
        )
      ]),
    );
  }

  _popUpMenuButton() {
    return PopupMenuButton<int>(
      /*icon: IconButton(
        icon: Icon(
          Icons.more_vert,
          color: Color.fromARGB(255, 197, 230, 166),
        ),
        onPressed: () {},
      ),*/
      iconSize: 35,
      color: Color.fromARGB(255, 189, 139, 156),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
        const PopupMenuItem(
          textStyle: TextStyle(color: Color.fromARGB(255, 197, 230, 166)),
          value: 1,
          child: Text('Eliminar'),
        ),
        const PopupMenuItem(
          textStyle: TextStyle(color: Color.fromARGB(255, 197, 230, 166)),
          value: 2,
          child: Text('Editar'),
        ),
      ],
      onSelected: (value) {
        if (value == 1) {
          return _onDeleteItem();
        }
        if (value == 2) {
          _navigateAndEdit(context);
        }
      },
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
        backgroundColor: Color.fromARGB(255, 189, 139, 156),
        title: Text('¿Seguro que  quieres eliminar este objeto?',
            style: TextStyle(color: Color.fromARGB(255, 197, 230, 166))),
        content: Text('Esta acción es permanente',
            style: TextStyle(color: Color.fromARGB(255, 197, 230, 166))),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(
              context,
              'Cancelar',
            ),
            child: const Text('Cancelar',
                style: TextStyle(color: Color.fromARGB(255, 197, 230, 166))),
          ),
          TextButton(
            onPressed: () {
              provider.remove(widget.item);
              Navigator.popUntil(context, ModalRoute.withName('/'));
            },
            child: const Text('Lo entiendo y acepto las consecuencias',
                style: TextStyle(color: Color.fromARGB(255, 147, 22, 33))),
          ),
        ],
      ),
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

  void _navigateAndEdit(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AddEditItem(onButtonTapped, widget.item, "e", context),
      ),
    );
  }

  void onButtonTapped(int index, BuildContext context) {
    Navigator.pop(context);
    setState(() {});
  }
}
