import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobiance/utils/preferences.dart';

class Categorias {
  static Icon getIconByCategoria({@required String categoria}) {
    print(categoria);
    switch (categoria) {
      case 'Luz/Água/Telefone':
        return Icon(
          Icons.lightbulb,
          color: corLaranja,
        );
      case 'Alimentação':
        return Icon(
          Icons.restaurant,
          color: corVinho,
        );
      case 'Mercado':
        return Icon(
          Icons.shopping_cart,
          color: corAmarela,
        );
      case 'Educação':
        return Icon(
          Icons.book,
          color: corAzulClaro,
        );
      case 'Lazer':
        return Icon(
          Icons.pool,
          color: corAzulPiscina,
        );
      case 'Saúde':
        return Icon(
          Icons.favorite,
          color: corVermelha,
        );
      case 'Moradia':
        return Icon(
          Icons.home,
          color: corRoxaEscura,
        );
      case 'Pagamentos':
        return Icon(Icons.payment, color: corVerde);
      case 'Transporte':
        return Icon(Icons.time_to_leave, color: corLaranja);
      case 'Roupa':
        return Icon(
          Icons.store,
          color: corVioleta,
        );
      case 'Viagem':
        return Icon(
          Icons.airplanemode_active,
          color: corRoxa,
        );
      case 'Salário':
        return Icon(
          Icons.monetization_on,
          color: corVerde,
        );
      case 'Investimento':
        return Icon(
          FontAwesomeIcons.chartBar,
          color: corAzulClaro,
        );
      case 'Presente':
        return Icon(
          Icons.card_giftcard,
          color: corRoxa,
        );
      case 'Outros':
        return Icon(
          Icons.linear_scale,
          color: corAzulPiscina,
        );
      default:
        return Icon(
          Icons.payment,
          color: corVerde,
        );
    }
  }

  static List<DropdownMenuItem<String>> getCategoriasDespesas() {
    List<DropdownMenuItem<String>> categorias = [];

    categorias.add(new DropdownMenuItem(
      child: Row(
        children: [
          Icon(
            Icons.restaurant,
            color: corVinho,
          ),
          SizedBox(
            width: 15,
          ),
          Text("Alimentação"),
        ],
      ),
      value: "Alimentação",
    ));
    categorias.add(new DropdownMenuItem(
      child: Row(
        children: [
          Icon(
            Icons.lightbulb,
            color: corLaranja,
          ),
          SizedBox(
            width: 15,
          ),
          Text("Luz/Água/Telefone"),
        ],
      ),
      value: "Luz/Água/Telefone",
    ));
    categorias.add(new DropdownMenuItem(
      child: Row(
        children: [
          Icon(
            Icons.shopping_cart,
            color: corAmarela,
          ),
          SizedBox(
            width: 15,
          ),
          Text("Mercado"),
        ],
      ),
      value: "Mercado",
    ));
    categorias.add(new DropdownMenuItem(
      child: Row(
        children: [
          Icon(
            Icons.book,
            color: corAzulClaro,
          ),
          SizedBox(
            width: 15,
          ),
          Text("Educação"),
        ],
      ),
      value: "Educação",
    ));
    categorias.add(new DropdownMenuItem(
      child: Row(
        children: [
          Icon(
            Icons.pool,
            color: corAzulPiscina,
          ),
          SizedBox(
            width: 15,
          ),
          Text("Lazer"),
        ],
      ),
      value: "Lazer",
    ));
    categorias.add(new DropdownMenuItem(
      child: Row(
        children: [
          Icon(
            Icons.favorite,
            color: corVermelha,
          ),
          SizedBox(
            width: 15,
          ),
          Text("Saúde"),
        ],
      ),
      value: "Saúde",
    ));
    categorias.add(new DropdownMenuItem(
      child: Row(
        children: [
          Icon(
            Icons.home,
            color: corRoxaEscura,
          ),
          SizedBox(
            width: 15,
          ),
          Text("Moradia"),
        ],
      ),
      value: "Moradia",
    ));
    categorias.add(new DropdownMenuItem(
      child: Row(
        children: [
          Icon(Icons.payment, color: corVerde),
          SizedBox(
            width: 15,
          ),
          Text("Pagamentos"),
        ],
      ),
      value: "Pagamentos",
    ));

    categorias.add(new DropdownMenuItem(
      child: Row(
        children: [
          Icon(Icons.time_to_leave, color: corLaranja),
          SizedBox(
            width: 15,
          ),
          Text("Transporte"),
        ],
      ),
      value: "Transporte",
    ));
    categorias.add(new DropdownMenuItem(
      child: Row(
        children: [
          Icon(
            Icons.store,
            color: corVioleta,
          ),
          SizedBox(
            width: 15,
          ),
          Text("Roupa"),
        ],
      ),
      value: "Roupa",
    ));
    categorias.add(new DropdownMenuItem(
      child: Row(
        children: [
          Icon(
            Icons.airplanemode_active,
            color: corRoxa,
          ),
          SizedBox(
            width: 15,
          ),
          Text("Viagem"),
        ],
      ),
      value: "Viagem",
    ));
    categorias.add(new DropdownMenuItem(
      child: Row(
        children: [
          Icon(
            Icons.linear_scale,
            color: corAzulPiscina,
          ),
          SizedBox(
            width: 15,
          ),
          Text("Outros"),
        ],
      ),
      value: "Outros",
    ));

    return categorias;
  }

  static List<DropdownMenuItem<String>> getCategoriasReceitas() {
    List<DropdownMenuItem<String>> categorias = [];
    
    categorias.add(new DropdownMenuItem(
      child: Row(
        children: [
          Icon(
            Icons.monetization_on,
            color: corVerde,
          ),
          SizedBox(
            width: 15,
          ),
          Text("Salário"),
        ],
      ),
      value: "Salário",
    ));
    categorias.add(new DropdownMenuItem(
      child: Row(
        children: [
          Icon(
            FontAwesomeIcons.chartBar,
            color: corAzulClaro,
          ),
          SizedBox(
            width: 15,
          ),
          Text("Investimento"),
        ],
      ),
      value: "Investimento",
    ));
    categorias.add(new DropdownMenuItem(
      child: Row(
        children: [
          Icon(
            Icons.card_giftcard,
            color: corRoxa,
          ),
          SizedBox(
            width: 15,
          ),
          Text("Presente"),
        ],
      ),
      value: "Presente",
    ));
    categorias.add(new DropdownMenuItem(
      child: Row(
        children: [
          Icon(
            Icons.linear_scale,
            color: corAzulPiscina,
          ),
          SizedBox(
            width: 15,
          ),
          Text("Outros"),
        ],
      ),
      value: "Outros",
    ));

    return categorias;
  }
}
