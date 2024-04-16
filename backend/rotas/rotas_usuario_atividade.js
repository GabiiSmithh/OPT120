const express = require('express');
const router = express.Router();
const connection = require('../ConexaoSQL.js');

router.get('/usuario-atividade', (req, res) => {
  try {
    connection.query('SELECT * FROM Usuario_Atividade', (err, results) => {
      if (err) {
        console.error('Error fetching usuario-atividade:', err);
        res.status(500).json({ erro: 'Erro ao buscar usuário-atividade' });
        return;
      }
      res.json(results);
    });
  } catch (error) {
    console.error('Error fetching usuario-atividade:', error);
    res.status(500).json({ erro: 'Erro ao buscar usuário-atividade: ' + error.message });
  }
});

router.get('/usuario-atividade/:usuarioId/:atividadeId', (req, res) => {
  const usuarioId = req.params.usuarioId;
  const atividadeId = req.params.atividadeId;
  try {
    connection.query('SELECT * FROM Usuario_Atividade WHERE `USUARIO.ID` = ? AND `ATIVIDADE.ID` = ?', [usuarioId, atividadeId], (err, results) => {
      if (err) {
        console.error('Error fetching usuario-atividade by ID:', err);
        res.status(500).json({ erro: 'Erro ao buscar relação usuário-atividade' });
        return;
      }
      if (results.length === 0) {
        res.status(404).json({ mensagem: "Relação entre usuário e atividade não encontrada" });
      } else {
        res.json(results[0]);
      }
    });
  } catch (error) {
    console.error('Error fetching usuario-atividade by ID:', error);
    res.status(500).json({ erro: 'Erro ao buscar relação usuário-atividade: ' + error.message });
  }
});

router.post('/usuario-atividade', (req, res) => {
  const { usuarioId, atividadeId, dataEntrega, nota } = req.body;
  console.log(req.body)
  try {
    connection.query('INSERT INTO Usuario_Atividade (`USUARIO.ID`, `ATIVIDADE.ID`, DATA_ENTREGA, NOTA) VALUES (?, ?, ?, ?)', [usuarioId, atividadeId, dataEntrega, nota], (err, result) => {
      if (err) {
        console.error('Error creating usuario-atividade:', err);
        res.status(500).json({ erro: 'Erro ao criar relação usuário-atividade' });
        return;
      }
      res.status(200).json({ mensagem: 'Relação usuário-atividade criada com sucesso', id: result.insertId });
    });
  } catch (error) {
    console.error('Error creating usuario-atividade:', error);
    res.status(500).json({ erro: 'Erro ao criar relação usuário-atividade: ' + error.message });
  }
});

router.put('/usuario-atividade/:usuarioId/:atividadeId', (req, res) => {
  const usuarioId = req.params.usuarioId;
  const atividadeId = req.params.atividadeId;
  const { dataEntrega, nota } = req.body;
  try {
    connection.query('UPDATE Usuario_Atividade SET DATA_ENTREGA = ?, NOTA = ? WHERE `USUARIO.ID` = ? AND `ATIVIDADE.ID` = ?', [dataEntrega, nota, usuarioId, atividadeId], (err, result) => {
      if (err) {
        console.error('Error updating usuario-atividade:', err);
        res.status(500).json({ erro: 'Erro ao atualizar relação usuário-atividade' });
        return;
      }
      if (result.affectedRows === 0) {
        res.status(404).json({ mensagem: "Relação entre usuário e atividade não encontrada" });
      } else {
        res.json({ mensagem: 'Relação usuário-atividade atualizada com sucesso' });
      }
    });
  } catch (error) {
    console.error('Error updating usuario-atividade:', error);
    res.status(500).json({ erro: 'Erro ao atualizar relação usuário-atividade: ' + error.message });
  }
});

router.delete('/usuario-atividade/:usuarioId/:atividadeId', (req, res) => {
  const usuarioId = req.params.usuarioId;
  const atividadeId = req.params.atividadeId;
  try {
    connection.query('DELETE FROM Usuario_Atividade WHERE `USUARIO.ID` = ? AND `ATIVIDADE.ID` = ?', [usuarioId, atividadeId], (err, result) => {
      if (err) {
        console.error('Error deleting usuario-atividade:', err);
        res.status(500).json({ erro: 'Erro ao excluir relação usuário-atividade' });
        return;
      }
      if (result.affectedRows === 0) {
        res.status(404).json({ mensagem: "Relação entre usuário e atividade não encontrada" });
      } else {
        res.json({ mensagem: 'Relação usuário-atividade excluída com sucesso' });
      }
    });
  } catch (error) {
    console.error('Error deleting usuario-atividade:', error);
    res.status(500).json({ erro: 'Erro ao excluir relação usuário-atividade: ' + error.message });
  }
});

module.exports = router;
