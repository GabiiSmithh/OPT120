import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Atividade {
  final int id;
  final String titulo;
  final String desc;
  final String data;

  Atividade({required this.id, required this.titulo, required this.desc, required this.data});

  factory Atividade.fromJson(Map<String, dynamic> json) {
    return Atividade(
      id: json['ID_ATIVIDADE'],
      titulo: json['TITULO'],
      desc: json['DESC'],
      data: json['DATA'],
    );
  }
}

class ListaAtividadeScreen extends StatefulWidget {
  const ListaAtividadeScreen({Key? key}) : super(key: key);

  @override
  _ListaAtividadeScreenState createState() => _ListaAtividadeScreenState();
}

class _ListaAtividadeScreenState extends State<ListaAtividadeScreen> {
  late Future<List<Atividade>> _atividades;

  Future<List<Atividade>> _getAtividades() async {
    final response = await http.get(Uri.parse('http://localhost:3024/atividade'));
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Atividade.fromJson(data)).toList();
    } else {
      throw Exception('Falha ao carregar as atividades');
    }
  }

  Future<void> _deleteAtividade(int id) async {
    final response = await http.delete(Uri.parse('http://localhost:3024/atividade/$id'));
    if (response.statusCode == 200) {
      // Atualize a lista de atividades após a exclusão
      setState(() {
        _atividades = _getAtividades();
      });
    } else {
      throw Exception('Falha ao excluir a atividade');
    }
  }

  @override
  void initState() {
    super.initState();
    _atividades = _getAtividades();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text(
          'Lista de Atividades',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: screenHeight * 0.02,
          horizontal: screenWidth * 0.1,
        ),
        child: FutureBuilder<List<Atividade>>(
          future: _atividades,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Erro: ${snapshot.error}'),
              );
            } else if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      title: Text(snapshot.data![index].titulo),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(snapshot.data![index].desc),
                          Text('Data: ${snapshot.data![index].data}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              // Implemente a lógica de edição aqui
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _deleteAtividade(snapshot.data![index].id);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Text('Nenhuma atividade encontrada.'),
              );
            }
          },
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ListaAtividadeScreen(),
  ));
}
