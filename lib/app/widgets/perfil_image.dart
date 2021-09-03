import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:mobiance/app/data/modelo/usuario.dart';
import 'package:mobiance/utils/preferences.dart';

class PerfilIcon extends StatelessWidget {
  final String imagemPerfil;
  final double radius;
  final bool edit;
  static const RADIUS_PADRAO = 30.0;
  final void Function() onPressed;
  const PerfilIcon({
    Key key,
    @required this.imagemPerfil,
    this.radius,
    this.edit = false,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var icon = Icon(Icons.account_circle,
        size: Size.fromRadius(radius ?? RADIUS_PADRAO).longestSide,
        color: Colors.white);
    return imagemPerfil != null
        ? Opacity(
            opacity: edit ? 0.65 : 1,
            child: CircleAvatar(
              child: edit
                  ? Stack(
                      children: [
                        Image.asset(imagemPerfil),
                        Positioned(
                            left: 45,
                            top: 45,
                            child: Icon(
                              Icons.edit,
                              color: corBranca,
                              size: 80,
                            ))
                      ],
                    )
                  : Image.asset(imagemPerfil),
              backgroundColor: Colors.black,
              radius: radius ?? RADIUS_PADRAO,
            ),
          )
        : icon;
  }
}
