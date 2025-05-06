import {Hono} from 'hono';
import  getShops  from "../controllers/shops.controller.js";

const router = new Hono();

router.get("/", getShops); // GET /produits

export default router;
