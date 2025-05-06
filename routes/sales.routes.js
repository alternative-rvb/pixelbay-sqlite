import {Hono} from "hono";
import  getSales  from "../controllers/sales.controller.js";

const router = new Hono();

router.get("/", getSales); // GET /produits

export default router;
