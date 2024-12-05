
import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
    int id;
    String modeletitle;
    String modalsubtitle;
    dynamic vehicleMakeId;

    Welcome({
        required this.id,
        required this.modeletitle,
        required this.modalsubtitle,
        required this.vehicleMakeId,
    });

    factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        id: json["ID"],
        modeletitle: json["modeletitle"],
        modalsubtitle: json["modalsubtitle"],
        vehicleMakeId: json["vehicleMakeId"],
    );

    Map<String, dynamic> toJson() => {
        "ID": id,
        "modeletitle": modeletitle,
        "modalsubtitle": modalsubtitle,
        "vehicleMakeId": vehicleMakeId,
    };
}
