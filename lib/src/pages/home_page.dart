import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_reader_app/src/bloc/scan_block.dart';
import 'package:qr_reader_app/src/models/scan_model.dart';
import 'package:qr_reader_app/src/pages/directions_page.dart';
import 'package:qr_reader_app/src/pages/maps_page.dart';
import 'package:qr_reader_app/src/utils/utils.dart' as utils;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scansBloc = new ScansBloc();

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: scansBloc.deleteAllScans,
          )
        ],
      ),
      body: _callPage(currentIndex),
      bottomNavigationBar: _createBottomNavidationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => _scanQR(context),
      ),
    );
  }

  _scanQR(BuildContext context) async {
    // https://fernando-herrera.com
    // geo:40.73255860802501,-74.89333143671877

    // dynamic futureString = '';
    String futureString = 'https://fernando-herrera.com';

    // try {
    //   futureString = await BarcodeScanner.scan();
    // } catch (e) {
    //   futureString = e.toString();
    // }

    if (futureString != null) {
      final scan = ScanModel(valor: futureString);
      scansBloc.addScan(scan);
      final scan2 =
          ScanModel(valor: 'geo:40.724233047051705,-74.00731459101564');
      scansBloc.addScan(scan2);

      if (Platform.isIOS) {
        Future.delayed(Duration(milliseconds: 750), () {
          utils.openScan(context, scan);
        });
      } else {
        utils.openScan(context, scan);
      }
    }
  }

  Widget _createBottomNavidationBar() {
    return BottomNavigationBar(
      currentIndex: currentIndex, // Which element is active
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text('Maps'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.directions),
          title: Text('Directions'),
        ),
      ],
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
    );
  }

  Widget _callPage(int actualPage) {
    switch (actualPage) {
      case 0:
        return MapsPage();
      case 1:
        return DirectionsPage();
      default:
        return MapsPage();
    }
  }
}
