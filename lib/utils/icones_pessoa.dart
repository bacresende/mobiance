class IconePessoas{
  
  static List<String> getPessoas(){
    List<String> pessoas = [];
    pessoas.add('assets/imagens/icones/man.png');
    pessoas.add('assets/imagens/icones/user.png');

    for(int i = 1; i <= 22; i++){
      pessoas.add('assets/imagens/icones/user-$i.png');
    }
    
    return pessoas;
  }

}