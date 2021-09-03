import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:mobiance/app/modulos/grupo_detalhe/widgets/body_grupo.dart';
import 'package:mobiance/utils/preferences.dart';

class Lancamentos extends StatelessWidget {
  GlobalKey<FlipCardState> flipKey2 = GlobalKey<FlipCardState>();
  @override
  Widget build(BuildContext context) {
    return Container(
        color: corRoxa,
        child: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool scroll) =>
                <Widget>[
                  SliverOverlapAbsorber(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context),
                    sliver: SliverAppBar(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(30))),
                      expandedHeight: 125,
                      floating: false,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                          centerTitle: true,
                          title: Text(
                            'R\$ 15.502,00',
                            style: TextStyle(fontSize: 24, color: Colors.white),
                          ),
                          background: Padding(
                            padding: const EdgeInsets.only(bottom: 50),
                            child: Center(
                              child: Card(
                                color: corVermelha,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '- R\$ 7,00',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          )),
                    ),
                  ),
                ],
            body: Builder(builder: (BuildContext context) {
              return CustomScrollView(slivers: [
                SliverOverlapInjector(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context)),
                BodyGrupo(
                  flipKey2: flipKey2,
                )
              ]);
            })),
      );
  }
}