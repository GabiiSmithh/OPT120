import 'package:flutter/material.dart';
import 'cadastro_usuario.dart'; // Importar o arquivo da tela de cadastro de usuário
import 'cadastro_atividade.dart'; // Importar o arquivo da tela de cadastro de atividade
import 'atividades_cadastradas.dart'; // Importar o arquivo da tela de atividades cadastradas

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
        '/cadastro_usuario': (context) => CadastroUsuarioPage(), // Adicionando rota para a tela de cadastro de usuário
        '/cadastro_atividade': (context) => CadastroAtividadePage(), // Adicionando rota para a tela de cadastro de atividade
        '/atividades_cadastradas': (context) => AtividadesCadastradasPage(), // Adicionando rota para a tela de atividades cadastradas
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
        backgroundColor: Colors.white, // Define a cor da AppBar como roxo
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
              leading: const Icon(Icons.person), // Ícone para cadastro de usuário
              title: const Text('Cadastro de Usuário'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/cadastro_usuario');
              },
            ),
            ListTile(
              leading: const Icon(Icons.assignment), // Ícone para cadastro de atividade
              title: const Text('Cadastro de Atividade'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/cadastro_atividade');
              },
            ),
            ListTile(
              leading: const Icon(Icons.list), // Ícone para atividades cadastradas
              title: const Text('Atividades Cadastradas'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/atividades_cadastradas');
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
                borderRadius: BorderRadius.circular(10), // Define bordas arredondadas
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
