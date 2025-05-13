// server.js
import { Hono } from "hono";
import { serveStatic } from "@hono/node-server/serve-static";

import metaRoutes from "./routes/meta.routes.js";
import productsRoute from "./routes/products.routes.js";
import shopsRoute from "./routes/shops.routes.js";
import salesRoute from "./routes/sales.routes.js";

const app = new Hono();

// API REST avec Hono
// https://hono.dev/

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

// Test de l'API OData
// https://services.odata.org/V4/Northwind/Northwind.svc/

app.get("/proxy/odata", async (c) => {
  const query = c.req.query("query");
  if (!query) {
    return c.text("Le paramètre 'query' est requis", 400);
  }

  // Base URL OData
  const baseUrl = "https://services.odata.org/V4/Northwind/Northwind.svc/";

  // Construction de l'URL complète
  const fullUrl = baseUrl + query;

  console.log("🛰️ Appel vers :", fullUrl);

  try {
    // Requête à l'API OData
    const response = await fetch(fullUrl);
    const data = await response.json();
    return c.json(data);
  } catch (err) {
    return c.text("Erreur lors de l'appel OData : " + err.message, 500);
  }
});

console.log("🚀 Lancement du serveur Hono avec Bun...");

// Pour Bun (autoécoute sur le port 3000)
// export de l'application Hono

// export default app;

Bun.serve({
  port: 3000,
  fetch: app.fetch,
});

console.log("✅ Serveur actif sur http://localhost:3000");
