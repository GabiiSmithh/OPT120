const express = require('express');
const router = express.Router();

const connection = require('../ConexaoSQL.js');

// Rota para obter todas as atividades
router.get('/atividade', async (req, res) => {
  try {
    connection.query('SELECT * FROM Atividade WHERE CANCELAMENTO = ?', 'N', (err, results) => {
      if (err) {
        throw err;
      }
      res.json(results);
    });
  } catch (error) {
    res.status(500).json({ erro: error.message });
  }
});

// Rota para obter uma atividade específica por ID
router.get('/atividade/:id', async (req, res) => {
  const id = req.params.id;
  try {
    connection.query('SELECT * FROM Atividade WHERE ID_ATIVIDADE = ? AND CANCELAMENTO = ?', [id, 'N'], (err, results) => {
      if (err) {
        throw err;
      }
      if (results.length === 0) {
        res.status(404).json({ mensagem: "Atividade não encontrada" });
        return;
      }
      res.json(results[0]);
    });
  } catch (error) {
    res.status(500).json({ erro: error.message });
  }
});

// Rota para criar uma nova atividade
router.post('/atividade', async (req, res) => {
  const { TITULO, DESC, DATA } = req.body;
  try {
    connection.query("INSERT INTO Atividade (TITULO, `DESC`, `DATA`, CANCELAMENTO) VALUES (?, ?, ?, ?)", [TITULO, DESC, DATA, 'N'], (err, result) => {
      if (err) {
        throw err;
      }
      res.status(201).json({ mensagem: 'Atividade criada com sucesso', id: result.insertId });
    });
  } catch (error) {
    res.status(500).json({ erro: error.message });
  }
});

// Rota para atualizar uma atividade existente
router.put('/atividade/:id', async (req, res) => {
  const id = req.params.id;
  const { TITULO, DESC, DATA } = req.body;
  try {
    connection.query('UPDATE Atividade SET TITULO = ?, `DESC` = ?, `DATA` = ? WHERE ID_ATIVIDADE = ?', [TITULO, DESC, DATA, id], (err, result) => {
      if (err) {
        throw err;
      }
      if (result.affectedRows === 0) {
        res.status(404).json({ mensagem: "Atividade não encontrada" });
        return;
      }
      res.json({ mensagem: 'Atividade atualizada com sucesso' });
    });
  } catch (error) {
    res.status(500).json({ erro: error.message });
  }
});

// Rota para excluir uma atividade
router.delete('/atividade/:id', async (req, res) => {
  const id = req.params.id;
  try {
    connection.query('UPDATE Atividade SET CANCELAMENTO = ? WHERE ID_ATIVIDADE = ?', ['S', id], (err, result) => {
      if (err) {
        throw err;
      }
      if (result.affectedRows === 0) {
        res.status(404).json({ mensagem: "Atividade não encontrada" });
        return;
      }
      res.json({ mensagem: 'Atividade excluída com sucesso' });
    });
  } catch (error) {
    res.status(500).json({ erro: error.message });
  }
});

module.exports = router;
