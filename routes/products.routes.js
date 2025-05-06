import {Hono} from "hono";
import  getProducts  from "../controllers/products.controller.js";

const router = new Hono();

router.get("/", getProducts); // GET /produits

export default router;
