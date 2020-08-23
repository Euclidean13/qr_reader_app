import 'dart:async';

import 'package:qr_reader_app/src/bloc/validator.dart';
import 'package:qr_reader_app/src/providers/db_provider.dart';

class ScansBloc with Validators {
  static final ScansBloc _singleton = new ScansBloc._internal();
  factory ScansBloc() {
    return _singleton;
  }

  ScansBloc._internal() {
    // Get Scans from the database
    getScans();
  }

  // Stream
  final _scansController = StreamController<List<ScanModel>>.broadcast();

  // for geo locations
  Stream<List<ScanModel>> get scansStream =>
      _scansController.stream.transform(validateGeo);
  // for http urls
  Stream<List<ScanModel>> get scansStreamHttp =>
      _scansController.stream.transform(validateHttp);

  dispose() {
    _scansController?.close();
  }

  getScans() async {
    _scansController.sink.add(await DBProvider.db.getAllScans());
  }

  addScan(ScanModel scan) async {
    await DBProvider.db.newScan(scan);
    getScans();
  }

  deleteScan(int id) async {
    await DBProvider.db.deleteScan(id);
    getScans();
  }

  deleteAllScans() async {
    DBProvider.db.deleteAll();
    _scansController.sink.add([]);
  }
}
