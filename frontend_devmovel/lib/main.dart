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
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {
        '/cadastro_usuario': (context) => CadastroUsuarioPage(), // Adicionando rota para a tela de cadastro de usuário
        '/cadastro_atividade': (context) => CadastroAtividadePage(), // Adicionando rota para a tela de cadastro de atividade
        '/atividades_cadastradas': (context) => AtividadesCadastradasPage(), // Adicionando rota para a tela de atividades cadastradas
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/cadastro_usuario'); // Navegar para a tela de cadastro de usuário
              },
              child: Text('Ir para Cadastro de Usuário'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/cadastro_atividade'); // Navegar para a tela de cadastro de atividade
              },
              child: Text('Ir para Cadastro de Atividade'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/atividades_cadastradas'); // Navegar para a tela de atividades cadastradas
              },
              child: Text('Visualizar Atividades Cadastradas'),
            ),
          ],
        ),
      ),
    );
  }
}
