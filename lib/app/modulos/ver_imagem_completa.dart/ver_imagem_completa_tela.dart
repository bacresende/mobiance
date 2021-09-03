import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobiance/utils/preferences.dart';

class VerImagemCompleta extends StatelessWidget {
  final String foto;
  VerImagemCompleta(this.foto);
  
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
        title: Text("Visualizar Imagem", style: TextStyle(color: Colors.white),),
      ),
      body: Container(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Image(
                        image: NetworkImage(foto),
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                      color: Colors.white,
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 5,
                      margin: EdgeInsets.all(5),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 10),
                      child: InkWell(
                        child: Container(
                          width: 320,
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: corRoxa,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          child: Text(
                            "Voltar",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        onTap: () {
                          Get.back();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}