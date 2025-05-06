import {Hono} from 'hono';
import  listTables  from '../controllers/meta.controller.js';

const router = new Hono();

router.get('/tables', listTables); // GET /meta/tables

export default router;
