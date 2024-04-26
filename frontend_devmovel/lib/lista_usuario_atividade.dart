import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListaUsuarioAtividade extends StatefulWidget {
  @override
  _ListaUsuarioAtividadeState createState() => _ListaUsuarioAtividadeState();
}

class _ListaUsuarioAtividadeState extends State<ListaUsuarioAtividade> {
  List<Map<String, dynamic>> usuarios = [];
  List<Map<String, dynamic>> atividades = [];

  @override
  void initState() {
    super.initState();
    fetchUsuarios();
    fetchAtividades();
  }

  Future<void> fetchUsuarios() async {
    try {
      var response = await http.get(Uri.parse('http://localhost:3024/usuario'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          usuarios = data.map<Map<String, dynamic>>((usuario) {
            return {
              'id': usuario['ID_USUARIO'],
              'nome': usuario['NOME'],
            };
          }).toList();
        });
      } else {
        print('Falha ao carregar usuários: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar usuários: $e');
    }
  }

  Future<void> fetchAtividades() async {
    try {
      var response =
          await http.get(Uri.parse('http://localhost:3024/atividade'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          atividades = data.map<Map<String, dynamic>>((atividade) {
            return {
              'id': atividade['ID_ATIVIDADE'],
              'titulo': atividade['TITULO'],
              'descricao': atividade['DESC'],
            };
          }).toList();
        });
      } else {
        print('Falha ao carregar atividades: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar atividades: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lista de Usuários e Atividades',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Usuários:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: usuarios.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(usuarios[index]['nome']),
                  subtitle: Text('ID: ${usuarios[index]['id']}'),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Atividades:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: atividades.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(atividades[index]['titulo']),
                  subtitle: Text(atividades[index]['descricao']),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
