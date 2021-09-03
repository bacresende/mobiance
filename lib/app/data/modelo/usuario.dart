class Usuario {
  String nome;
  String telefone;
  String dataNascimento;
  String cpf;
  String email;
  String idUsuario;
  String senha;
  bool dadosCompleto;
  String imagemPerfil;
  String tipoUsuario = 'free';

  Usuario(
      {this.nome,
      this.telefone,
      this.dataNascimento,
      this.cpf,
      this.email,
      this.idUsuario,
      this.dadosCompleto,
      this.imagemPerfil});

  Usuario.fromJson(Map<String, dynamic> json) {
    nome = json['nome'];
    telefone = json['telefone'];
    dataNascimento = json['dataNascimento'];
    cpf = json['cpf'];
    email = json['email'];
    idUsuario = json['idUsuario'];
    dadosCompleto = json['dadosCompleto'];
    imagemPerfil = json['imagemPerfil'];
  }
  alterarDadosFromJson(Map<String, dynamic> json) {
    nome = json['nome'];
    telefone = json['telefone'];
    dataNascimento = json['dataNascimento'];
    imagemPerfil = json['imagemPerfil'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome'] = this.nome;
    data['telefone'] = this.telefone;
    data['dataNascimento'] = this.dataNascimento;
    data['cpf'] = this.cpf;
    data['email'] = this.email;
    data['idUsuario'] = this.idUsuario;
    data['dadosCompleto'] = this.dadosCompleto;
    data['imagemPerfil'] = this.imagemPerfil;
    data['tipoUsuario'] = this.tipoUsuario;
    return data;
  }

  Map<String, dynamic> toJsonUpdate() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome'] = this.nome;
    data['telefone'] = this.telefone;
    data['dataNascimento'] = this.dataNascimento;
    data['cpf'] = this.cpf;
    data['dadosCompleto'] = this.dadosCompleto;
    data['imagemPerfil'] = this.imagemPerfil;
    return data;
  }

  Map<String, dynamic> toJsonEditar() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome'] = this.nome;
    data['telefone'] = this.telefone;
    data['dataNascimento'] = this.dataNascimento;
    data['imagemPerfil'] = this.imagemPerfil;
    return data;
  }

  @override
  String toString() {
    return 'nome: $nome, telefone: $telefone, dataNascimento: $dataNascimento, cpf: $cpf, email: $email, idUsuario: $idUsuario, dadosCompleto: $dadosCompleto, imagemPerfil: $imagemPerfil,';
  }

  Usuario novoUsuario(){
    Usuario usuario = new Usuario();
    usuario.nome = nome;
    usuario.telefone = telefone;
    usuario.dataNascimento = dataNascimento;
    usuario.cpf = cpf;
    usuario.email = email;
    usuario.idUsuario = idUsuario;
    usuario.dadosCompleto = dadosCompleto;
    usuario.imagemPerfil = imagemPerfil;
    
    return usuario;
  }



  /*void testarEncriptacao() {
    final plainText = 'Bruno Aurélio Cipriano Resende';
    final key = Key.fromLength(32);
    final iv = IV.fromLength(8);
    final encrypter = Encrypter(Salsa20(key));

    final encrypted = encrypter.encrypt(plainText, iv: iv);
    final decrypted = encrypter.decrypt(encrypted, iv: iv);

    print(decrypted); // Lorem ipsum dolor sit amet, consectetur adipiscing elit
    print(encrypted.base16);
    print(encrypted.base64);
  }*/
}
