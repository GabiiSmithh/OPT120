const express = require('express');
const mysql = require('mysql');

const app = express();

// Configurações do banco de dados
const conexao = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: 'password',
  database: 'mydb'
});

// Conecta ao banco de dados
conexao.connect((err) => {
  if (err) {
    console.error('Erro ao conectar ao banco de dados:', err);
    return;
  }
  console.log('Conexão bem sucedida ao banco de dados!');
});


// Exemplo de rota
app.get('/', (req, res) => {
  res.send('Servidor Rodando Corretamente!');
});

// Inicia o servidor
const PORT = 3024;
app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
});
