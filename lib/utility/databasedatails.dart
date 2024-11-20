import 'package:sher_mech/views/vehiclemake.dart';

String ipAdress = "192.168.0.167";
String port="1433";
String databasename ="shermecK";
String username = "sa";
String password ="sheracc@7008";


Future<bool> connect() async {
    return await sqlConnection.connect(
      ip: ipAdress,
      port: port,
      databaseName: databasename,
      username: username,
      password: password,
    );
  }