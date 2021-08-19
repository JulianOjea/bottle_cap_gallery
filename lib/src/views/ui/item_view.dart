import 'package:bottle_cap_gallery/src/views/utils/item.dart';
import 'package:flutter/material.dart';

enum WhyFarther { harder, smarter, selfStarter, tradingCharter }

class ViewItem extends StatelessWidget {
  final Item item;
  ViewItem(this.item);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListView(children: [
        AppBar(
          title: Text(item.brandName),
          actions: [
            _popUpMenuButton(),
          ],
        ),
        Container(
          color: Colors.black,
          child: Image.memory(item.image, fit: BoxFit.fill),
        ),
        Text("Bebida: " + item.type),
        Text("Descripción: " + item.description),
        Text("País: " + item.country),
        Text("Ciudad: " + item.city),
        Text("Año de emisión: " + item.releaseDate.toString()),
        Text("Fecha de creación: " + creationDateToString()),
      ]),
    );
  }

  _popUpMenuButton() {
    return PopupMenuButton<WhyFarther>(
      itemBuilder: (BuildContext context) => <PopupMenuEntry<WhyFarther>>[
        const PopupMenuItem<WhyFarther>(
          value: WhyFarther.harder,
          child: Text('Working a lot harder'),
        ),
        const PopupMenuItem<WhyFarther>(
          value: WhyFarther.smarter,
          child: Text('Being a lot smarter'),
        ),
        const PopupMenuItem<WhyFarther>(
          value: WhyFarther.selfStarter,
          child: Text('Being a self-starter'),
        ),
        const PopupMenuItem<WhyFarther>(
          value: WhyFarther.tradingCharter,
          child: Text('Placed in charge of trading charter'),
        ),
      ],
    );
  }

  String creationDateToString() {
    String date = item.creationDate.day.toString() +
        "-" +
        item.creationDate.month.toString() +
        "-" +
        item.creationDate.year.toString() +
        " " +
        item.creationDate.hour.toString() +
        ":" +
        item.creationDate.minute.toString();
    return date;
  }
}
