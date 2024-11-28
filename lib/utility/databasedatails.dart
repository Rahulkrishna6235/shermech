import 'package:sher_mech/views/vehiclemake.dart';

String ipAdress = "192.168.0.147";
String port="1433";
String databasename ="shermeck";
String username = "sa";
String password ="997755";


Future<bool> connect() async {
    return await sqlConnection.connect(
      ip: ipAdress,
      port: port,
      databaseName: databasename,
      username: username,
      password: password,
    );
  }