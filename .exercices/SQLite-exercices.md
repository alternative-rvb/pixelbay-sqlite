# 📚 Exercices SQL — Projet Pixelbay (avec indices et corrections cachées)

Bienvenue dans cette série d'exercices SQL conçus pour vous aider à maîtriser les bases et les concepts avancés de la manipulation de bases de données relationnelles. Ces exercices s'appuient sur un projet fictif, **Pixelbay**, pour rendre l'apprentissage concret et pratique. Chaque exercice est accompagné d'indices et de solutions pour vous guider dans votre progression. Bonne pratique !

- Niveau 🟢 : Lecture simple.
- Niveau 🟡 : Jointures et agrégations.
- Niveau 🔴 : Calculs, sous-requêtes, vues.

## 🟢 Niveau facile (exploration & filtres simples)

### Exercice 1

Affiche la liste des **noms** et **villes** de tous les magasins Pixelbay, triée par **ordre alphabétique** du nom.

<details>
<summary>💡 Indice</summary>

Utilise `ORDER BY nom`.
</details>

<details>
<summary>✅Solution</summary>

```sql
SELECT nom, ville
FROM magasins
ORDER BY nom;
```
</details>

### Exercice 2

Affiche tous les **produits** avec leur **nom**, **prix unitaire** et **TVA**, triés du **moins cher** au **plus cher**.

<details>
<summary>💡 Indice</summary>

`ORDER BY prix_unitaire ASC`.
</details>

<details>
<summary>✅Solution</summary>

```sql
SELECT nom, prix_unitaire, tva
FROM produits
ORDER BY prix_unitaire ASC;
```
</details>

### Exercice 3

Affiche toutes les **dépenses** réalisées par **"Pixelbay Lyon"**, avec :
- la date,
- le montant,
- la catégorie de dépense.

<details>
<summary>💡 Indice</summary>

Utilise `JOIN` entre `depenses`, `magasins` et `categories_depenses`.
</details>

<details>
<summary>✅Solution</summary>

```sql
SELECT d.date_depense, d.montant, cd.libelle
FROM depenses d
JOIN magasins m ON m.id = d.magasin_id
JOIN categories_depenses cd ON cd.id = d.categorie_depense_id
WHERE m.nom = 'Pixelbay Lyon';
```
</details>

### Exercice 4

Affiche la liste des **produits** appartenant à la catégorie **"Accessoires"**.

<details>
<summary>💡 Indice</summary>

Utilise `JOIN` entre `produits`, `produits_categories` et `categories_ventes`.
</details>

<details>
<summary>✅Solution</summary>

```sql
SELECT p.nom
FROM produits p
JOIN produits_categories pc ON pc.produit_id = p.id
JOIN categories_ventes cv ON cv.id = pc.categorie_vente_id
WHERE cv.libelle = 'Accessoires';
```
</details>

## 🟡 Niveau moyen (jointures & agrégations)

### Exercice 5

Affiche toutes les **ventes** avec :
- le nom du magasin,
- la date de vente,
- et le **nombre total d'articles** vendus.

<details>
<summary>💡 Indice</summary>

Pense à `SUM(vp.quantite)` et `GROUP BY v.id`.
</details>

<details>
<summary>✅Solution</summary>

```sql
SELECT m.nom, v.date_vente, SUM(vp.quantite) AS total_articles
FROM ventes v
JOIN magasins m ON m.id = v.magasin_id
JOIN ventes_produits vp ON vp.vente_id = v.id
GROUP BY v.id;
```
</details>

### Exercice 6

Pour chaque **magasin**, calcule le **montant total des dépenses**.

<details>
<summary>💡 Indice</summary>

Pense à `SUM(montant)` groupé par magasin.
</details>

<details>
<summary>✅Solution</summary>

```sql
SELECT m.nom, SUM(d.montant) AS total_depenses
FROM depenses d
JOIN magasins m ON m.id = d.magasin_id
GROUP BY m.id;
```
</details>

### Exercice 7

Pour chaque **produit**, affiche :
- le **nombre total de fois** où il a été vendu.

<details>
<summary>💡 Indice</summary>

Utilise `SUM(quantite)` sur `ventes_produits`.
</details>

<details>
<summary>✅Solution</summary>

```sql
SELECT p.nom, SUM(vp.quantite) AS total_vendu
FROM produits p
JOIN ventes_produits vp ON vp.produit_id = p.id
GROUP BY p.id;
```
</details>

### Exercice 8

Affiche les **produits jamais vendus**.

<details>
<summary>💡 Indice</summary>

Utilise `LEFT JOIN` et `WHERE vp.id IS NULL`.
</details>

<details>
<summary>✅Solution</summary>

```sql
SELECT p.nom
FROM produits p
LEFT JOIN ventes_produits vp ON vp.produit_id = p.id
WHERE vp.id IS NULL;
```
</details>

## 🔴 Niveau difficile (groupes, sous-requêtes, calculs, vues)

### Exercice 9

Affiche pour chaque **magasin** son **chiffre d'affaires TTC**.

<details>
<summary>💡 Indice</summary>

`SUM(prix_unitaire * quantite * (1 + tva / 100))` après jointures.
</details>

<details>
<summary>✅Solution</summary>

```sql
SELECT m.nom, SUM(p.prix_unitaire * vp.quantite * (1 + p.tva / 100)) AS chiffre_affaires_ttc
FROM ventes v
JOIN magasins m ON m.id = v.magasin_id
JOIN ventes_produits vp ON vp.vente_id = v.id
JOIN produits p ON p.id = vp.produit_id
GROUP BY m.id;
```
</details>

### Exercice 10

Affiche pour chaque **magasin** son **bénéfice brut**.

<details>
<summary>💡 Indice</summary>

Fais deux sous-requêtes ou CTE : une pour le CA, une pour les dépenses, et soustrais.
</details>

<details>
<summary>✅Solution</summary>

```sql
WITH ca AS (
  SELECT m.id AS magasin_id, SUM(p.prix_unitaire * vp.quantite * (1 + p.tva / 100)) AS chiffre_affaires_ttc
  FROM ventes v
  JOIN magasins m ON m.id = v.magasin_id
  JOIN ventes_produits vp ON vp.vente_id = v.id
  JOIN produits p ON p.id = vp.produit_id
  GROUP BY m.id
),
dep AS (
  SELECT magasin_id, SUM(montant) AS total_depenses
  FROM depenses
  GROUP BY magasin_id
)
SELECT ca.magasin_id, ca.chiffre_affaires_ttc, COALESCE(dep.total_depenses, 0) AS total_depenses,
       (ca.chiffre_affaires_ttc - COALESCE(dep.total_depenses, 0)) AS benefice_brut
FROM ca
LEFT JOIN dep ON dep.magasin_id = ca.magasin_id;
```
</details>

### Exercice 11

**Crée une vue** `vue_chiffre_affaires_magasin`.

<details>
<summary>💡 Indice</summary>

Utilise la requête de l'exercice 9 et fais un `CREATE VIEW`.
</details>

<details>
<summary>✅Solution</summary>

```sql
CREATE VIEW vue_chiffre_affaires_magasin AS
SELECT m.id AS magasin_id, m.nom AS magasin_nom,
       SUM(p.prix_unitaire * vp.quantite * (1 + p.tva / 100)) AS chiffre_affaires_ttc
FROM ventes v
JOIN magasins m ON m.id = v.magasin_id
JOIN ventes_produits vp ON vp.vente_id = v.id
JOIN produits p ON p.id = vp.produit_id
GROUP BY m.id;
```
</details>

### Exercice 12

**Crée une vue** `vue_benefices_magasin`.

<details>
<summary>💡 Indice</summary>

Utilise les résultats de l'exercice 10 dans un `CREATE VIEW`.
</details>

<details>
<summary>✅Solution</summary>

```sql
CREATE VIEW vue_benefices_magasin AS
WITH ca AS (
  SELECT m.id AS magasin_id, SUM(p.prix_unitaire * vp.quantite * (1 + p.tva / 100)) AS chiffre_affaires_ttc
  FROM ventes v
  JOIN magasins m ON m.id = v.magasin_id
  JOIN ventes_produits vp ON vp.vente_id = v.id
  JOIN produits p ON p.id = vp.produit_id
  GROUP BY m.id
),
dep AS (
  SELECT magasin_id, SUM(montant) AS total_depenses
  FROM depenses
  GROUP BY magasin_id
)
SELECT ca.magasin_id, ca.chiffre_affaires_ttc, COALESCE(dep.total_depenses, 0) AS total_depenses,
       (ca.chiffre_affaires_ttc - COALESCE(dep.total_depenses, 0)) AS benefice_brut
FROM ca
LEFT JOIN dep ON dep.magasin_id = ca.magasin_id;
```
</details>
