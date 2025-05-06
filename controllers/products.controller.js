import { db } from '../db/Database.js';

export default  async function getProducts(c) {
  try {
    const produits = db.all('SELECT * FROM produits');
    return c.json(produits);
  } catch (err) {
    return c.status(500).json({ error: err.message });
  }
}
