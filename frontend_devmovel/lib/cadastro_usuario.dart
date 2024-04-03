import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro',
      theme: ThemeData(
        primaryColor: Colors.teal,
        hintColor: Colors.tealAccent,
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.teal),
          bodyText1: TextStyle(fontSize: 16.0, color: Colors.black87),
          button: TextStyle(fontSize: 18.0, color: Colors.white),
        ),
      ),
      home: CadastroUsuarioPage(),
    );
  }
}

// ignore: must_be_immutable
class CadastroUsuarioPage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _nome = '';
  String _email = '';
  String _senha = '';

  CadastroUsuarioPage({super.key});

  void _cadastrar() {
    if (_formKey.currentState!.validate()) {
      // Aqui você faria o request para o backend com os dados do formulário
      print('Nome: $_nome');
      print('Email: $_email');
      print('Senha: $_senha');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cadastrar Usuário',
          style: TextStyle(color: Colors.white), // Altera a cor do texto para branco
          ),
        backgroundColor: Colors.teal, // Define a cor da AppBar como roxo
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200], // Define a cor de fundo desejada
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8, // Define a largura dos inputs
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Nome',
                        labelStyle: const TextStyle(color: Colors.teal),
                        prefixIcon: const Icon(Icons.person, color: Colors.teal), // Ícone no início do campo de texto
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal.withOpacity(0.5)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira seu nome';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        _nome = value;
                      },
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8, // Define a largura dos inputs
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: const TextStyle(color: Colors.teal),
                        prefixIcon: const Icon(Icons.email, color: Colors.teal), // Ícone no início do campo de texto
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal.withOpacity(0.5)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira seu email';
                        }
                        if (!value.contains('@')) {
                          return 'Email inválido';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        _email = value;
                      },
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8, // Define a largura dos inputs
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        labelStyle: const TextStyle(color: Colors.teal),
                        prefixIcon: const Icon(Icons.lock, color: Colors.teal), // Ícone no início do campo de texto
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal.withOpacity(0.5)),
                        ),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira sua senha';
                        }
                        if (value.length < 6) {
                          return 'A senha deve conter pelo menos 6 caracteres';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        _senha = value;
                      },
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5, // Define a largura do botão
                    child: ElevatedButton(
                      onPressed: _cadastrar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal, // Altera a cor de fundo do botão
                      ),
                      child: const Text(
                        'Cadastrar',
                        style: TextStyle(color: Colors.white), // Altera a cor do texto do botão
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
