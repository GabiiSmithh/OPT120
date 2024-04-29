import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Usuario {
  final int id;
  String nome;
  String email;

  Usuario({required this.id, required this.nome, required this.email});

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['ID_USUARIO'],
      nome: json['NOME'],
      email: json['EMAIL'],
    );
  }

  void atualizarNome(String novoNome) {
    this.nome = novoNome;
  }

  void atualizarEmail(String novoEmail) {
    this.email = novoEmail;
  }
}

class ListaUsuarioScreen extends StatefulWidget {
  const ListaUsuarioScreen({Key? key}) : super(key: key);

  @override
  _ListaUsuarioScreenState createState() => _ListaUsuarioScreenState();
}

class _ListaUsuarioScreenState extends State<ListaUsuarioScreen> {
  final _formKey = GlobalKey<FormState>();
  late Future<List<Usuario>> _usuarios;
  late final Map<int, bool> _isEditing = {};

  void startEditing(int id) {
    setState(() {
      _isEditing[id] = true;
    });
  }

  void stopEditing(int id) {
    setState(() {
      _isEditing[id] = false;
    });
    _usuarios =
        _getUsuarios(); // Atualiza a lista de atividades ao cancelar a edição
  }

  Future<List<Usuario>> _getUsuarios() async {
    final response =
        await http.get(Uri.parse('http://localhost:3024/api/usuario'));
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Usuario.fromJson(data)).toList();
    } else {
      throw Exception('Falha ao carregar os usuários');
    }
  }

  @override
  void initState() {
    super.initState();
    _usuarios = _getUsuarios();
  }

  void editarUsuario(Usuario usuario) {
    startEditing(usuario.id);
  }

  void _showSnackBarMessage(String message,
      {Color backgroundColor = Colors.red}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  void removerUsuario(int id) async {
    try {
      final response =
          await http.delete(Uri.parse('http://localhost:3024/api/usuario/$id'));
      if (response.statusCode == 200) {
        setState(() {
          _usuarios = _getUsuarios();
        });
      }
    } catch (error) {
      print('Erro ao fazer requisição DELETE: $error');
      _showSnackBarMessage('Erro ao fazer requisição DELETE');
    }
  }

  void salvarEdicao(Usuario usuario) async {
    print('Salvando edição do usuário ${usuario.id}');

    final Uri uri =
        Uri.parse('http://localhost:3024/api/usuario/${usuario.id}');
    final Map<String, String> headers = {'Content-Type': 'application/json'};
    final Map<String, dynamic> body = {
      'nome': usuario.nome,
      'email': usuario.email,
    };

    try {
      final response =
          await http.put(uri, headers: headers, body: json.encode(body));
      if (response.statusCode == 200) {
        setState(() {
          _usuarios = _getUsuarios(); // Atualiza a lista de usuários
        });
        stopEditing(usuario.id);
      }
    } catch (error) {
      print('Erro ao fazer requisição PUT: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text(
          'Lista de Usuários',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: screenHeight * 0.02,
          horizontal: screenWidth * 0.1,
        ),
        child: FutureBuilder<List<Usuario>>(
          future: _usuarios,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final usuario = snapshot.data![index];
                  final isEditing = _isEditing.containsKey(usuario.id) &&
                      _isEditing[usuario.id] == true;

                  return isEditing
                      ? _buildEditableUsuario(usuario)
                      : _buildStaticUsuario(usuario);
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Erro: ${snapshot.error}'),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStaticUsuario(Usuario usuario) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                usuario.nome,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 5),
              Text(
                usuario.email,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  editarUsuario(usuario);
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  removerUsuario(usuario.id);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEditableUsuario(Usuario usuario) {
    TextEditingController nomeController =
        TextEditingController(text: usuario.nome);
    TextEditingController emailController =
        TextEditingController(text: usuario.email);

    return Form(
      key: _formKey, // Define the form key
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: nomeController,
            decoration: InputDecoration(labelText: 'Nome'),
            onChanged: (value) {
              usuario.atualizarNome(value);
            },
          ),
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(labelText: 'Email'),
            onChanged: (value) {
              usuario.atualizarEmail(value);
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira um email';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                  .hasMatch(value)) {
                return 'Por favor, insira um email válido';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Perform the saving logic here
                    salvarEdicao(usuario);
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.teal,
                  backgroundColor: Color.fromARGB(255, 218, 218, 218),
                ),
                child: Text('Salvar'),
              ),
              SizedBox(width: 8),
              TextButton(
                onPressed: () {
                  stopEditing(usuario.id);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.teal,
                  backgroundColor: Color.fromARGB(255, 218, 218, 218),
                ),
                child: Text('Cancelar', style: TextStyle(color: Colors.teal)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ListaUsuarioScreen(),
  ));
}
