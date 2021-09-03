import 'package:flutter/material.dart';

//Cores customizadas
const Color corBranca = Colors.white;
const Color corRoxaEscura = Color(0xFF420A65);
const Color corRoxa = Color(0xFF4e0080);
const Color corVermelha = Color(0xffAB2E46);
const Color corLaranja = Color(0xffFFC65A);
const Color azulEscuro = Color(0xFF2D3447);
const Color corVerde = Color(0xff49B675);
const Color corAzulClaro = Color(0xff0e4bef);
const Color corAzulPiscina = Color(0xff49b2f3);
const Color corVinho = Color(0xff7c2146);
const Color corAmarela = Color(0xffFCE903);
const Color corVioleta = Color(0xff9d60d4);

//Textos customizados
TextStyle botaoPadraoStyle = TextStyle(
    color: corBranca,
    fontSize: 22,
    fontWeight: FontWeight.bold,
    fontFamily: 'Pero');
TextStyle botaoBoasVindasStyle = TextStyle(
    color: corRoxa,
    fontSize: 22,
    fontWeight: FontWeight.bold,
    fontFamily: 'Pero');
TextStyle tituloStyle =
    TextStyle(fontSize: 25, color: corRoxa, fontFamily: 'Pero');
TextStyle flatButtonRoxoStyle = TextStyle(
    color: corRoxa,
    fontSize: 22,
    fontFamily: 'Regular',
    fontWeight: FontWeight.bold);
TextStyle dialogFlatButtonRoxoStyle =
    TextStyle(color: corRoxa, fontSize: 22, fontFamily: 'Pero');
TextStyle dialogFlatButtonVerdeStyle =
    TextStyle(color: corVerde, fontSize: 22, fontFamily: 'Pero');
TextStyle dialogFlatButtonVermelhoStyle =
    TextStyle(color: corVermelha, fontSize: 22, fontFamily: 'Pero');
TextStyle flatButtonVermelhoStyle = TextStyle(color: corVermelha);
TextStyle flatButtonBrancoStyle =
    TextStyle(color: corBranca, fontSize: 18, fontWeight: FontWeight.bold);

//gradientes
List<Color> empresteiGradiente = [corRoxaEscura, Colors.purple[600]];
List<Color> pegueiEmprestadoGradiente = [corVinho, Colors.pink];
