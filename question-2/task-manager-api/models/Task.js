const db = require('../config/db');

class Task {
  static async getAll() {
    const [tasks] = await db.query('SELECT * FROM tasks');
    return tasks;
  }

  static async getById(id) {
    const [task] = await db.query('SELECT * FROM tasks WHERE id = ?', [id]);
    return task[0];
  }

  static async create({ title, description, status, user_id }) {
    const [result] = await db.query(
      'INSERT INTO tasks (title, description, status, user_id) VALUES (?, ?, ?, ?)',
      [title, description, status, user_id]
    );
    return { id: result.insertId, title, description, status, user_id };
  }

  static async update(id, { title, description, status }) {
    await db.query(
      'UPDATE tasks SET title = ?, description = ?, status = ? WHERE id = ?',
      [title, description, status, id]
    );
    return { id, title, description, status };
  }

  static async delete(id) {
    await db.query('DELETE FROM tasks WHERE id = ?', [id]);
    return { id };
  }
}

module.exports = Task;