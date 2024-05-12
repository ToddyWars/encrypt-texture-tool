import 'package:get/get.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          //DESENVOLVIMENTO
          'rain': "It's rainy here",
          //LOGIN
          'username': 'Username',
          'email': 'Email',
          'password': 'Password',
          'login': 'Login',
          'signup': 'Sign up',
          'create_account': 'Create',
          'cancel_account': 'Cancel',
          //HOME
          'play': 'Play',
          'store': 'Marketplace',
          'notes': 'Version notes',
          'all': 'All',
          'hello': 'Hello',
          'Pesquisar': 'Search',
          'tex': 'Textures',
          'maps': 'Maps',
          //PROFILE
          'back': 'Back',
          'language': 'Language',
          'config': 'Settings',
        },
        'pt_BR': {
          //DESENVOLVIMENTO
          'rain': '''Está chuvoso aqui''',
          //LOGIN
          'username': 'Nome e Sobrenome',
          'email': 'Email',
          'password': 'Senha',
          'hello': 'Olá',
          'login': 'Entrar',
          'Pesquisar': 'Pesquisar',
          'signup': 'Criar Conta',
          'create_account': 'Criar',
          'cancel_account': 'Cancelar',
          //HOME,
          'play': 'Jogar',
          'store': 'Loja',
          'all': 'Tudo',
          'maps': 'Mapas',
          'tex': 'Texturas',
          'notes': 'Notas de versão',
          //PROFILE
          'back': 'Voltar',
          'language': 'Idioma',
          'config': 'Configurações',
        }
      };
}