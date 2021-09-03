import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:mobiance/app/modulos/home/home_controller.dart';
import 'package:mobiance/utils/preferences.dart';

class AlternarLancamento extends StatelessWidget {
  final HomeController homeController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            !homeController.isFirst
                ? IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: corBranca,
                    ),
                    onPressed: homeController.retrocederLancamento,
                  )
                : Container(),
            Material(
              color: corRoxa,
              child: InkWell(
                onTap: homeController.abrirDialogAno,
                child: Text(homeController.mostrarMesAtual,
                    style: TextStyle(
                      fontSize: 24,
                      color: corBranca,
                      fontFamily: 'Regular',
                      fontWeight: FontWeight.w600,
                    )),
              ),
            ),
            Row(
              children: [
                !homeController.isLast
                    ? IconButton(
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          color: corBranca,
                        ),
                        onPressed: homeController.avancarLancamento,
                      )
                    : Container(),
                homeController.isLancamentoAtual
                    ? Tooltip(
                        message: 'Ir para a data atual',
                        child: IconButton(
                            icon: Icon(Icons.calendar_today, color: corBranca),
                            onPressed: homeController.irParaDataAtual))
                    : Container()
              ],
            )
          ],
        )));
  }
}
