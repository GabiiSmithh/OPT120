
const mysql = require('mysql');

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

module.exports = conexao;