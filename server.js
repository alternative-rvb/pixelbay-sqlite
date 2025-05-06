// server.js
import { Hono } from "hono";
import { serveStatic } from "@hono/node-server/serve-static";

import metaRoutes from "./routes/meta.routes.js";
import productsRoute from "./routes/products.routes.js";
import shopsRoute from "./routes/shops.routes.js";
import salesRoute from "./routes/sales.routes.js";

const app = new Hono();

// Middleware JSON (optionnel, juste pour illustrer un use global)
app.use("*", async (c, next) => {
  await next();
});

// Static files (comme Express.static)
app.use("*", serveStatic({ root: "./public" }));

app.get("/test", (c) => c.text("Hello depuis Hono + Bun"));

// Routes
app.route("/meta", metaRoutes);
app.route("/produits", productsRoute);
app.route("/magasins", shopsRoute);
app.route("/ventes", salesRoute);

// 404
app.notFound((c) => c.text("404 - Ressource non trouvée", 404));

console.log("🚀 Lancement du serveur Hono avec Bun...");

// Pour Bun (autoécoute sur le port 3000)
// export de l'application Hono

// export default app; 

Bun.serve({
  port: 3000,
  fetch: app.fetch,
});

console.log("✅ Serveur actif sur http://localhost:3000");
