// db/Database.js
import { Database } from 'bun:sqlite';

export class DB {
  constructor(dbPath = './pixelbay-sqlite.db') {
    this.db = new Database(dbPath);
  }

  all(sql, params = []) {
    const stmt = this.db.query(sql);
    return stmt.all(...params);
  }

  get(sql, params = []) {
    const stmt = this.db.query(sql);
    return stmt.get(...params);
  }

  run(sql, params = []) {
    const stmt = this.db.query(sql);
    return stmt.run(...params);
  }

  listTables() {
    const sql = `
      SELECT name FROM sqlite_master
      WHERE type='table' AND name NOT LIKE 'sqlite_%'
      ORDER BY name;
    `;
    return this.all(sql);
  }
}

export const db = new DB(); // ✅ Instance réutilisable
