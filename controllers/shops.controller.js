import { db } from "../db/Database.js";

export default async function getShops(c) {
  try {
    const magasins = db.all("SELECT * FROM magasins");
    return c.json(magasins);
  } catch (err) {
    return c.status(500).json({ error: err.message });
  }
}
