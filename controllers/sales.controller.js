import { db } from "../db/Database.js";

export default  async function getSales(c) {
  try {
    const ventes = db.all("SELECT * FROM ventes");
    return c.json(ventes);
  } catch (err) {
    return c.status(500).json({ error: err.message });
  }
}
