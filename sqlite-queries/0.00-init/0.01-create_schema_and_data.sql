-- database: ../pixelbay.db
-- Magasins
CREATE TABLE magasins (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nom TEXT NOT NULL,
  ville TEXT NOT NULL
);

-- Catégories de ventes
CREATE TABLE categories_ventes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  libelle TEXT NOT NULL
);

-- Catégories de dépenses
CREATE TABLE categories_depenses (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  libelle TEXT NOT NULL
);

-- Produits
CREATE TABLE produits (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nom TEXT NOT NULL,
  prix_unitaire REAL NOT NULL CHECK(prix_unitaire >= 0),
  tva REAL NOT NULL DEFAULT 20.0 CHECK(tva >= 0)
);

-- Ventes
CREATE TABLE ventes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  magasin_id INTEGER NOT NULL,
  date_vente DATE NOT NULL,
  FOREIGN KEY (magasin_id) REFERENCES magasins(id)
);

-- Dépenses
CREATE TABLE depenses (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  magasin_id INTEGER NOT NULL,
  date_depense DATE NOT NULL,
  montant REAL NOT NULL CHECK(montant >= 0),
  categorie_depense_id INTEGER NOT NULL,
  description TEXT,
  FOREIGN KEY (magasin_id) REFERENCES magasins(id),
  FOREIGN KEY (categorie_depense_id) REFERENCES categories_depenses(id)
);

-- Table de liaison ventes-produits (Many-to-Many)
CREATE TABLE ventes_produits (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  vente_id INTEGER NOT NULL,
  produit_id INTEGER NOT NULL,
  quantite INTEGER NOT NULL DEFAULT 1 CHECK(quantite > 0),
  FOREIGN KEY (vente_id) REFERENCES ventes(id),
  FOREIGN KEY (produit_id) REFERENCES produits(id)
);

-- Table de liaison produits-catégories de ventes (Many-to-Many)
CREATE TABLE produits_categories (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  produit_id INTEGER NOT NULL,
  categorie_vente_id INTEGER NOT NULL,
  FOREIGN KEY (produit_id) REFERENCES produits(id),
  FOREIGN KEY (categorie_vente_id) REFERENCES categories_ventes(id)
);

-- Insertion des magasins
INSERT INTO magasins (nom, ville) VALUES
('Pixelbay Lyon', 'Lyon'),
('Pixelbay Marseille', 'Marseille'),
('Pixelbay Paris', 'Paris');

-- Insertion des catégories de ventes
INSERT INTO categories_ventes (libelle) VALUES
('Jeux Vidéo'),
('Consoles'),
('Accessoires'),
('Produits dérivés'),
('Cartes Cadeaux');

-- Insertion des catégories de dépenses
INSERT INTO categories_depenses (libelle) VALUES
('Loyer'),
('Électricité'),
('Salaires'),
('Marketing'),
('Fournitures de bureau');

-- Insertion des produits
INSERT INTO produits (nom, prix_unitaire, tva) VALUES
('Console PS5', 499.99, 20.0),
('Manette PS5', 69.99, 20.0),
('Jeu Zelda Switch', 59.99, 20.0),
('Jeu FIFA PS5', 69.99, 20.0),
('Casque Gaming', 89.99, 20.0),
('Carte cadeau 50€', 50.00, 0.0),
('T-shirt Mario', 24.99, 20.0),
('Figurine Sonic', 34.99, 20.0),
('Support de manette', 19.99, 20.0),
('Chargeur USB-C', 14.99, 20.0);

-- Liaisons produits-catégories
INSERT INTO produits_categories (produit_id, categorie_vente_id) VALUES
(1, 2),
(2, 3),
(3, 1),
(4, 1),
(5, 3),
(6, 5),
(7, 4),
(8, 4),
(9, 3),
(10, 3);

-- Insertion des ventes
INSERT INTO ventes (magasin_id, date_vente) VALUES
(1, '2024-04-01'),
(1, '2024-04-03'),
(2, '2024-04-02'),
(2, '2024-04-05'),
(3, '2024-04-01'),
(3, '2024-04-04'),
(1, '2024-04-06'),
(2, '2024-04-07'),
(3, '2024-04-07'),
(1, '2024-04-08');

-- Liaisons ventes-produits
INSERT INTO ventes_produits (vente_id, produit_id, quantite) VALUES
(1, 1, 2),
(1, 3, 1),
(2, 4, 1),
(2, 2, 1),
(3, 5, 2),
(3, 7, 1),
(4, 8, 3),
(5, 1, 1),
(5, 6, 2),
(6, 9, 1),
(7, 2, 1),
(7, 3, 2),
(8, 5, 1),
(8, 10, 1),
(9, 4, 1),
(9, 7, 2),
(10, 1, 1),
(10, 3, 1);

-- Insertion des dépenses
INSERT INTO depenses (magasin_id, date_depense, montant, categorie_depense_id, description) VALUES
(1, '2024-04-01', 2500.00, 1, 'Loyer avril'),
(1, '2024-04-02', 150.00, 2, 'Facture électricité'),
(2, '2024-04-01', 2700.00, 1, 'Loyer avril'),
(2, '2024-04-03', 200.00, 2, 'Facture électricité'),
(3, '2024-04-01', 3200.00, 1, 'Loyer avril'),
(3, '2024-04-04', 180.00, 2, 'Facture électricité'),
(1, '2024-04-05', 8000.00, 3, 'Salaires avril'),
(2, '2024-04-05', 8500.00, 3, 'Salaires avril'),
(3, '2024-04-05', 9500.00, 3, 'Salaires avril'),
(1, '2024-04-06', 500.00, 4, 'Campagne pub Facebook');

