// Importando os módulos necessários
const express = require('express');
const router = express.Router();

const connection = require('../ConexaoSQL.js');

// Rota para obter todos os usuários
router.get('/usuario', (req, res) => {
  connection.query('SELECT * FROM Usuario', (err, results) => {
    if (err) {
      res.status(500).json({ erro: err.message });
      return;
    }
    res.json(results);
  });
});

// Rota para obter um usuário específico por ID
router.get('/usuario/:id', (req, res) => {
  const id = req.params.id;
  connection.query('SELECT * FROM Usuario WHERE ID_USUARIO = ?', id, (err, results) => {
    if (err) {
      res.status(500).json({ erro: err.message });
      return;
    }
    if (results.length === 0) {
      res.status(404).json({ mensagem: "Usuário não encontrado" });
      return;
    }
    res.json(results[0]);
  });
});

// Rota para criar um novo usuário
router.post('/usuario', (req, res) => {
  const { NOME, EMAIL, SENHA } = req.body;
  connection.query('INSERT INTO Usuario (NOME, EMAIL, SENHA) VALUES (?, ?, ?)', [NOME, EMAIL, SENHA], (err, result) => {
    if (err) {
      res.status(500).json({ erro: err.message });
      return;
    }
    res.status(201).json({ mensagem: 'Usuário criado com sucesso', id: result.insertId });
  });
});

// Rota para atualizar um usuário existente
router.put('/usuario/:id', (req, res) => {
  const id = req.params.id;
  const { NOME, EMAIL, SENHA } = req.body;
  connection.query('UPDATE Usuario SET NOME = ?, EMAIL = ?, SENHA = ? WHERE ID_USUARIO = ?', [NOME, EMAIL, SENHA, id], (err, result) => {
    if (err) {
      res.status(500).json({ erro: err.message });
      return;
    }
    if (result.affectedRows === 0) {
      res.status(404).json({ mensagem: "Usuário não encontrado" });
      return;
    }
    res.json({ mensagem: 'Usuário atualizado com sucesso' });
  });
});

// Rota para excluir um usuário
router.delete('/usuario/:id', (req, res) => {
  const id = req.params.id;
  connection.query('DELETE FROM Usuario WHERE ID_USUARIO = ?', id, (err, result) => {
    if (err) {
      res.status(500).json({ erro: err.message });
      return;
    }
    if (result.affectedRows === 0) {
      res.status(404).json({ mensagem: "Usuário não encontrado" });
      return;
    }
    res.json({ mensagem: 'Usuário excluído com sucesso' });
  });
});

module.exports = router;
