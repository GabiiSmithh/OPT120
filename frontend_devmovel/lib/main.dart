import 'package:flutter/material.dart';
import 'cadastro_usuario.dart'; // Importe o arquivo para a tela de registro de usuário
import 'cadastro_atividade.dart'; // Importe o arquivo para a tela de registro de atividade
import 'cadastro_usuario_atividade.dart'; // Importe o arquivo para a tela de registro de usuário e atividade
import 'lista_atividades.dart'; // Importe o arquivo para a tela de lista de atividades
import 'lista_usuarios.dart'; // Importe o arquivo para a tela de lista de usuários
import 'lista_usuario_atividade.dart'; // Importe o arquivo para a tela de lista de usuários e atividades

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Área de Trabalho',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal),
      ),
      home: const MyHomePage(title: 'Menu Inicial'),
      routes: {
        '/cadastro_usuario': (context) => CadastroUsuarioPage(),
        '/cadastro_atividade': (context) => CadastroAtividadePage(),
        '/cadastro_usuario_atividade': (context) => CadastroUsuarioAtividade(),
        '/lista_atividades': (context) => ListaAtividadeScreen(),
        '/lista_usuarios': (context) => ListaUsuarioScreen(),
        '/lista_usuario_atividade': (context) => ListaUsuarioAtividade(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.teal,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Cadastro de Usuário'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/cadastro_usuario');
              },
            ),
            ListTile(
              leading: const Icon(Icons.assignment),
              title: const Text('Cadastro de Atividade'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/cadastro_atividade');
              },
            ),
            ListTile(
              leading: const Icon(Icons.assignment_ind),
              title: const Text('Cadastro de Usuário e Atividade'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/cadastro_usuario_atividade');
              },
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Lista de Atividades'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/lista_atividades');
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Lista de Usuários'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/lista_usuarios');
              },
            ),
            ListTile(
              leading: const Icon(Icons.group_work),
              title: const Text('Lista de Usuários e Atividades'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/lista_usuario_atividade');
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: Container(
              width: 400,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const Center(
            child: Text(
              'Ainda não há nada aqui',
              style: TextStyle(fontSize: 20.0, color: Colors.teal),
            ),
          ),
        ],
      ),
    );
  }
}
