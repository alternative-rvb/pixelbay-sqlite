import { db } from "../db/Database.js";

export default async function listTables(c) {
  try {
    const tables = db.listTables();
    return c.json(tables);
  } catch (err) {
    return c.status(500).json({ error: err.message });
  }
}
