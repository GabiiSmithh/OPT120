import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UsuarioAtividade {
  final int idUsuario;
  final int idAtividade;
  String dataEntrega;
  double nota;

  UsuarioAtividade({
    required this.idUsuario,
    required this.idAtividade,
    required this.dataEntrega,
    required this.nota,
  });

  factory UsuarioAtividade.fromJson(Map<String, dynamic> json) {
    return UsuarioAtividade(
      idUsuario: json['USUARIO.ID'],
      idAtividade: json['ATIVIDADE.ID'],
      dataEntrega: json['DATA_ENTREGA'],
      nota: json['NOTA'].toDouble(),
    );
  }

  void atualizarDataEntrega(String novaDataEntrega) {
    this.dataEntrega = novaDataEntrega;
  }

  void atualizarNota(double novaNota) {
    this.nota = novaNota;
  }
}

class ListaUsuarioAtividadeScreen extends StatefulWidget {
  const ListaUsuarioAtividadeScreen({Key? key}) : super(key: key);

  @override
  _ListaUsuarioAtividadeScreenState createState() =>
      _ListaUsuarioAtividadeScreenState();
}

class _ListaUsuarioAtividadeScreenState
    extends State<ListaUsuarioAtividadeScreen> {
  final _formKey = GlobalKey<FormState>();
  late Future<List<UsuarioAtividade>> _usuariosAtividades;
  late final Map<int, bool> _isEditing = {};

  void startEditing(int idUsuario, int idAtividade) {
    setState(() {
      final idConcatenado = int.parse("$idUsuario$idAtividade");
      _isEditing[idConcatenado] = true;
    });
  }

  void stopEditing(int idUsuario, int idAtividade) {
    setState(() {
      final idConcatenado = int.parse("$idUsuario$idAtividade");
      _isEditing[idConcatenado] = false;
    });
    _usuariosAtividades =
        _getUsuariosAtividades(); // Atualiza a lista de atividades ao cancelar a edição
  }

  Future<List<UsuarioAtividade>> _getUsuariosAtividades() async {
    final response = await http
        .get(Uri.parse('http://localhost:3024/api/usuario_atividade'));
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((data) => UsuarioAtividade.fromJson(data))
          .toList();
    } else {
      throw Exception('Falha ao carregar os usuarios e atividades');
    }
  }

  @override
  void initState() {
    super.initState();
    _usuariosAtividades = _getUsuariosAtividades();
  }

  void editarUsuarioAtividade(UsuarioAtividade usuarioAtividade) {
    startEditing(usuarioAtividade.idUsuario, usuarioAtividade.idAtividade);
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

  void removerUsuarioAtividade(int idUsuario, int idAtividade) async {
    try {
      final response = await http.delete(Uri.parse(
          'http://localhost:3024/api/usuario_atividade/$idUsuario/$idAtividade'));
      if (response.statusCode == 200) {
        setState(() {
          _usuariosAtividades = _getUsuariosAtividades();
        });
      }
    } catch (error) {
      print('Erro ao fazer requisição DELETE: $error');
    }
  }

  void salvarEdicao(UsuarioAtividade usuarioAtividade) async {
    print(
        'Salvando edição do usuário e atividade ${usuarioAtividade.idUsuario} - ${usuarioAtividade.idAtividade}');

    DateTime dataEntrega = DateTime.parse(usuarioAtividade.dataEntrega);
    // Formatar a data no formato esperado pelo servidor
    final String formattedDate =
        '${dataEntrega.year}-${dataEntrega.month.toString().padLeft(2, '0')}-${dataEntrega.day.toString().padLeft(2, '0')}';
    final Uri uri = Uri.parse(
        'http://localhost:3024/api/usuario_atividade/${usuarioAtividade.idUsuario}/${usuarioAtividade.idAtividade}');
    final Map<String, String> headers = {'Content-Type': 'application/json'};
    final Map<String, dynamic> body = {
      'dataEntrega': formattedDate, // Data formatada
      'nota': usuarioAtividade.nota,
    };

    try {
      final response =
          await http.put(uri, headers: headers, body: json.encode(body));
      if (response.statusCode == 200) {
        setState(() {
          _usuariosAtividades =
              _getUsuariosAtividades(); // Atualiza a lista de usuários
        });
        stopEditing(usuarioAtividade.idUsuario, usuarioAtividade.idAtividade);
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
          'Lista de Usuários e Atividades',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: screenHeight * 0.02,
          horizontal: screenWidth * 0.1,
        ),
        child: FutureBuilder<List<UsuarioAtividade>>(
          future: _usuariosAtividades,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final usuarioAtividade = snapshot.data![index];
                  final idConcatenado = int.parse(
                      "${usuarioAtividade.idUsuario}${usuarioAtividade.idAtividade}");

                  final isEditing = _isEditing.containsKey(idConcatenado) &&
                      _isEditing[idConcatenado] == true;

                  return isEditing
                      ? _buildEditableUsuarioAtividade(usuarioAtividade)
                      : _buildStaticUsuarioAtividade(usuarioAtividade);
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

  Widget _buildStaticUsuarioAtividade(UsuarioAtividade usuarioAtividade) {
    // Converter a data de entrega para um objeto DateTime
    DateTime dataEntrega = DateTime.parse(usuarioAtividade.dataEntrega);

    // Formatar a data no formato desejado
    String formattedDate =
        '${dataEntrega.day.toString().padLeft(2, '0')}/${dataEntrega.month.toString().padLeft(2, '0')}/${dataEntrega.year}';

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
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
      child: ListTile(
        title: Text(
          'ID Usuário: ${usuarioAtividade.idUsuario.toString()} | ID Atividade: ${usuarioAtividade.idAtividade.toString()}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Nota: ${usuarioAtividade.nota.toString()} | Data de Entrega: $formattedDate',
        ),
        trailing: Wrap(
          spacing: 8,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                editarUsuarioAtividade(usuarioAtividade);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                removerUsuarioAtividade(
                    usuarioAtividade.idUsuario, usuarioAtividade.idAtividade);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableUsuarioAtividade(UsuarioAtividade usuarioAtividade) {
    TextEditingController notaController =
        TextEditingController(text: usuarioAtividade.nota.toString());

    DateTime dataEntrega = DateTime.parse(usuarioAtividade
        .dataEntrega); // Convertendo a string em um objeto DateTime

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
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
      child: Form(
        key: _formKey, // Define a chave do formulário
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Botão para exibir a data de entrega
            TextButton(
              onPressed: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: dataEntrega,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                // Atualiza a data de entrega se uma nova data for selecionada
                if (pickedDate != null) {
                  setState(() {
                    dataEntrega = pickedDate;
                    usuarioAtividade
                        .atualizarDataEntrega(dataEntrega.toIso8601String());
                  });
                }
              },
              child: Text(
                'Data de Entrega: ${dataEntrega.day.toString().padLeft(2, '0')}/${dataEntrega.month.toString().padLeft(2, '0')}/${dataEntrega.year}',
                style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
            TextFormField(
              controller: notaController,
              decoration: InputDecoration(labelText: 'Nota'),
              onChanged: (value) {
                usuarioAtividade.atualizarNota(double.parse(value));
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira uma nota';
                }
                // Validações adicionais podem ser realizadas aqui
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
                      // Execute a lógica de salvamento aqui
                      salvarEdicao(usuarioAtividade);
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
                    stopEditing(usuarioAtividade.idUsuario,
                        usuarioAtividade.idAtividade);
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
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ListaUsuarioAtividadeScreen(),
  ));
}
