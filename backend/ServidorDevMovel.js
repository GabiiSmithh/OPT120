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

app.get('/usuario', (req, res) => {
  // Query SQL para selecionar todos os usuários
  const sql = 'SELECT * FROM Usuario';

  // Executa a consulta
  conexao.query(sql, (error, results) => {
    if (error) {
      // Se houver um erro, envia uma resposta de erro
      return res.status(500).json({ error: 'Erro ao executar a consulta no banco de dados' });
    }

    // Se a consulta for bem-sucedida, envia os resultados como resposta
    res.json(results);
  });
});

app.get('/atividade', (req, res) => {
  // Query SQL para selecionar todos os usuários
  const sql = 'SELECT * FROM Atividade';

  // Executa a consulta
  conexao.query(sql, (error, results) => {
    if (error) {
      // Se houver um erro, envia uma resposta de erro
      return res.status(500).json({ error: 'Erro ao executar a consulta no banco de dados' });
    }

    // Se a consulta for bem-sucedida, envia os resultados como resposta
    res.json(results);
  });
});

app.get('/usuario_atividade', (req, res) => {
  // Query SQL para selecionar todos os usuários
  const sql = 'SELECT * FROM Usuario_Atividade';

  // Executa a consulta
  conexao.query(sql, (error, results) => {
    if (error) {
      // Se houver um erro, envia uma resposta de erro
      return res.status(500).json({ error: 'Erro ao executar a consulta no banco de dados' });
    }

    // Se a consulta for bem-sucedida, envia os resultados como resposta
    res.json(results);
  });
});

// Inicia o servidor
const PORT = 3024;
app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
});
