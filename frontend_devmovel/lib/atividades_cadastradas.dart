import 'package:flutter/material.dart';

class AtividadesCadastradasPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Exemplo de dados das atividades (substitua pelos seus dados reais)
    List<Map<String, dynamic>> atividades = [
      {
        'nomeUsuario': 'João',
        'titulo': 'Atividade 1',
        'dataEntrega': '01/04/2024',
        'nota': '9.5',
      },
      {
        'nomeUsuario': 'Maria',
        'titulo': 'Atividade 2',
        'dataEntrega': '03/04/2024',
        'nota': '8.0',
      },
      // Adicione mais atividades conforme necessário
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Atividades Cadastradas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Atividades:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: atividades.length,
                itemBuilder: (context, index) {
                  final atividade = atividades[index];
                  return Card(
                    child: ListTile(
                      title: Text('Nome do Usuário: ${atividade['nomeUsuario']}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Título: ${atividade['titulo']}'),
                          Text('Data de Entrega: ${atividade['dataEntrega']}'),
                          Text('Nota: ${atividade['nota']}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
