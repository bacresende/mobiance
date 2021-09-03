import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobiance/app/data/modelo/balanco_total_mensal.dart';
import 'package:mobiance/app/data/modelo/lancamento.dart';
import 'package:mobiance/app/modulos/balanco_futuro/balanco_futuro_controller.dart';
import 'package:mobiance/app/modulos/home/home_controller.dart';
import 'package:mobiance/utils/moeda_util.dart';
import 'package:mobiance/utils/preferences.dart';

class BalancoFuturo extends StatelessWidget {
  final BalancoFuturoController controller = new BalancoFuturoController();
  @override
  Widget build(BuildContext context) {
    controller.pegarMeses();
    return Scaffold(
      appBar: AppBar(
        title: Text('Balanço Futuro'),
      ),
      body: ListView.separated(
          separatorBuilder: (_, __) => Divider(),
          itemCount: controller.balancos.length,
          itemBuilder: (_, index) {
            BalancoTotalMensal balanco = controller.balancos[index];
            return ListTile(
              title: Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Text(
                  balanco.data,
                  style: flatButtonRoxoStyle,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Receita: R\$ ${MoedaUtil.formatarValor(balanco.receita.toString())}',
                    style: TextStyle(
                        fontSize: 18,
                        color: corVerde,
                        fontFamily: 'Regular',
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Despesa: R\$ ${MoedaUtil.formatarValor(balanco.despesa.toString())}',
                    style: TextStyle(
                        fontSize: 18,
                        color: corVermelha,
                        fontFamily: 'Regular',
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Total',
                    style: flatButtonRoxoStyle,
                  ),
                  Text(
                    'R\$ ${MoedaUtil.formatarValor(balanco.total.toString())}',
                    style: TextStyle(
                        fontSize: 18,
                        color: balanco.total >= 0 ? corVerde : corVermelha,
                        fontFamily: 'Regular',
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
            );
          }),
    );
  }
}
