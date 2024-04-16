import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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

class CadastroUsuarioPage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _nomeController;
  late final TextEditingController _emailController;
  late final TextEditingController _senhaController;

  CadastroUsuarioPage({Key? key})
      : _nomeController = TextEditingController(),
        _emailController = TextEditingController(),
        _senhaController = TextEditingController(),
        super(key: key);

  void _cadastrar(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final String nome = _nomeController.text;
      final String email = _emailController.text;
      final String senha = _senhaController.text;

      try {
        final response = await http.post(
          Uri.parse('http://localhost:3024/usuario'),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          body: {
            'nome': nome,
            'email': email,
            'senha': senha,
          },
        );

        if (response.statusCode == 201) {
          _showCadastroSuccessDialog(context);
        } else {
          print('Falha ao cadastrar: ${response.body}');
        }
      } catch (e) {
        print('Erro ao realizar cadastro: $e');
      }
    }
  }

  void _showCadastroSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Cadastro Concluído!"),
          content: Text("Seu cadastro foi realizado com sucesso!"),
          backgroundColor: Colors.white, // Alterando a cor de fundo para branco
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
            child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cadastrar Usuário',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
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
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextFormField(
                      controller: _nomeController,
                      decoration: InputDecoration(
                        labelText: 'Nome',
                        labelStyle: const TextStyle(color: Colors.teal),
                        prefixIcon: const Icon(Icons.person, color: Colors.teal),
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
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: const TextStyle(color: Colors.teal),
                        prefixIcon: const Icon(Icons.email, color: Colors.teal),
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
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextFormField(
                      controller: _senhaController,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        labelStyle: const TextStyle(color: Colors.teal),
                        prefixIcon: const Icon(Icons.lock, color: Colors.teal),
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
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: ElevatedButton(
                      onPressed: () => _cadastrar(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                      ),
                      child: const Text(
                        'Cadastrar',
                        style: TextStyle(color: Colors.white),
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
