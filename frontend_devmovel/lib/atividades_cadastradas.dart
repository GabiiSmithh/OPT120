import 'package:flutter/material.dart';

class AtividadesCadastradasPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Inicializar a lista de atividades como vazia
    List<Map<String, dynamic>> atividades = [];

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
              child: atividades.isEmpty
                  ? Stack(
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
                            'Suas Atividades Aparecerão Aqui :)',
                            style: TextStyle(fontSize: 20.0, color: Colors.teal),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      itemCount: atividades.length,
                      itemBuilder: (context, index) {
                        final atividade = atividades[index];
                        return Card(
                          child: ListTile(
                            title: Text(
                                'Nome do Usuário: ${atividade['nomeUsuario']}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Título: ${atividade['titulo']}'),
                                Text(
                                    'Data de Entrega: ${atividade['dataEntrega']}'),
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
