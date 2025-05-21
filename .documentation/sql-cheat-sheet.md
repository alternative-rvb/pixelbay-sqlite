# 📜 Cheat Sheet SQL — Solde de Gestion (IFS Cloud / Oracle)

Ce guide couvre les cas les plus fréquents dans un environnement comptable utilisant les tables suivantes :

* `GL` : mouvements du grand livre, avec `project_id` (clé étrangère vers `Project`)
* `Project` : projets, avec `agence_id` (clé étrangère vers `Agence`)
* `Agence` : agences ou directions financières

---

## 1. `WHERE` — Filtres simples

> **But** : sélectionner uniquement les lignes correspondant à une condition précise (égalité, seuil...).

```sql
SELECT * FROM GL WHERE project_id = 1001;
```

> Affiche toutes les écritures du projet 1001.

```sql
SELECT * FROM Project WHERE agence_id <> 42;
```

> Affiche tous les projets qui ne sont pas rattachés à l’agence 42.

```sql
SELECT * FROM GL WHERE montant > 10000;
```

> Affiche les écritures avec un montant strictement supérieur à 10 000.

---

## 2. `BETWEEN ... AND` — Plage de valeurs

> **But** : filtrer les données entre deux bornes (dates ou montants).

```sql
SELECT * FROM GL
WHERE date_operation BETWEEN TO_DATE('2024-01-01', 'YYYY-MM-DD') AND TO_DATE('2024-12-31', 'YYYY-MM-DD');
```

> Affiche les écritures du grand livre pour l’année 2024.

---

## 3. `LIKE` — Motifs sur du texte

> **But** : filtrer les chaînes de texte avec des jokers (`%`, `_`).

```sql
SELECT * FROM Project WHERE nom LIKE 'Développement%';
```

> Affiche tous les projets dont le nom commence par "Développement".

```sql
SELECT * FROM Project WHERE nom LIKE '%Urgent';
```

> Affiche tous les projets dont le nom se termine par "Urgent".

---

## 4. `REGEXP_LIKE` — Recherches par expression régulière

> **But** : filtrer avec des motifs plus puissants (ex. : chiffres, lettres, formats complexes).

```sql
SELECT * FROM Project WHERE REGEXP_LIKE(nom, '^DEV[0-9]{3}$');
```

> Affiche les projets dont le nom suit exactement le format `DEV` suivi de 3 chiffres, comme `DEV001`.

---

## 5. `IS NULL` / `IS NOT NULL`

> **But** : détecter les champs vides ou renseignés.

```sql
SELECT * FROM GL WHERE commentaire IS NULL;
```

> Affiche les écritures sans commentaire.

```sql
SELECT * FROM Project WHERE agence_id IS NOT NULL;
```

> Affiche les projets rattachés à une agence.

---

## 6. `AND` / `OR` — Conditions multiples

> **But** : combiner plusieurs critères de filtrage.

```sql
SELECT * FROM GL
WHERE montant > 1000
  AND statut = 'VALIDÉ'
  OR date_operation >= TO_DATE('2025-01-01', 'YYYY-MM-DD');
```

> Affiche :
>
> * Les écritures validées avec un montant > 1000
> * Ou toutes les écritures à partir du 1er janvier 2025

---

## 7. `IN` — Liste de valeurs

> **But** : filtrer selon plusieurs valeurs possibles.

```sql
SELECT * FROM GL WHERE project_id IN (101, 102, 103);
```

> Affiche toutes les écritures pour les projets 101, 102 et 103.

### Variante avancée avec `LIKE` ou `REGEXP`

> **But** : filtrer selon plusieurs motifs textuels.

```sql
-- Plusieurs motifs avec LIKE (OR)
SELECT * FROM Project
WHERE nom LIKE 'Dev%' OR nom LIKE 'Compta%' OR nom LIKE 'RH%';
```

> Affiche tous les projets dont le nom commence par Dev, Compta ou RH.

```sql
-- Expression régulière combinée
SELECT * FROM Project
WHERE REGEXP_LIKE(nom, '^Dev|^Compta|^RH');
```

> Plus lisible et évolutif pour de multiples motifs.

---

## 8. `EXISTS` / `NOT EXISTS`

> **But** : vérifier si une relation existe avec une autre table.

```sql
SELECT * FROM Project p
WHERE EXISTS (
  SELECT 1 FROM GL g WHERE g.project_id = p.project_id AND g.montant > 10000
);
```

> Affiche uniquement les projets qui ont au moins une écriture de plus de 10 000 dans le grand livre.

---

## 9. `JOIN` — Combiner plusieurs tables

### a. `GL` → `Project`

```sql
SELECT g.montant, p.nom
FROM GL g
JOIN Project p ON g.project_id = p.project_id;
```

> Affiche les montants du grand livre avec le nom du projet correspondant.

---

### b. `GL` → `Project` → `Agence`

```sql
SELECT g.montant, p.nom, a.nom_agence
FROM GL g
JOIN Project p ON g.project_id = p.project_id
JOIN Agence a ON p.agence_id = a.agence_id;
```

> Affiche les montants du grand livre, le nom du projet, et l’agence associée.

---

## 10. Agrégats et `GROUP BY`

### a. Total des montants par projet

```sql
SELECT g.project_id, SUM(g.montant) AS total_montant
FROM GL g
GROUP BY g.project_id;
```

> Calcule le solde de gestion pour chaque projet.

---

### b. Total par agence

```sql
SELECT a.nom_agence, SUM(g.montant) AS total_montant
FROM GL g
JOIN Project p ON g.project_id = p.project_id
JOIN Agence a ON p.agence_id = a.agence_id
GROUP BY a.nom_agence;
```

> Calcule le solde global pour chaque agence.

---

## ℹ️ Points à connaître (par ordre de priorité)

| Niveau | Pratique                                      | Pourquoi c’est utile                                    |
| ------ | --------------------------------------------- | ------------------------------------------------------- |
| 🥇      | `SELECT ... FROM`                             | Requête de base                                         |
| 🥇      | `WHERE`                                       | Filtrage simple (égalité, comparaison)                  |
| 🥇      | `AND` / `OR`                                  | Combiner des conditions                                 |
| 🥇      | `IN (...)`                                    | Filtrer sur une liste de valeurs                        |
| 🥇      | `BETWEEN ... AND`                             | Intervalle de valeurs                                   |
| 🥇      | `IS NULL` / `IS NOT NULL`                     | Tester les valeurs manquantes                           |
| 🥇      | `ORDER BY`                                    | Trier les résultats                                     |
| 🥇      | `LIMIT` / `FETCH FIRST`                       | Limiter le nombre de lignes retournées                  |
| 🥇      | `OFFSET`                                      | Paginer les résultats                                   |
| 🥇      | `JOIN` (`INNER JOIN`)                         | Lier deux tables                                        |
| 🥇      | `LEFT JOIN`                                   | Inclure toutes les lignes de la table principale        |
| 🥇      | `COUNT(*)`, `SUM()`, `AVG()`                  | Fonctions d’agrégation de base                          |
| 🥇      | `GROUP BY`                                    | Regrouper les données pour les calculs                  |
| 🥇      | `HAVING`                                      | Filtrer après un `GROUP BY`                             |
| 🥈      | `DISTINCT`                                    | Éliminer les doublons                                   |
| 🥈      | `LIKE`                                        | Filtrer avec motifs simples                             |
| 🥈      | `REGEXP_LIKE()`                               | Filtrage avec motifs complexes                          |
| 🥈      | `NVL(colonne, 0)`                             | Remplacer les `NULL` dans les calculs                   |
| 🥈      | `TO_DATE()`                                   | Convertir une chaîne en date Oracle                     |
| 🥈      | `CASE`                                        | Expressions conditionnelles dans `SELECT` ou `WHERE`    |
| 🥈      | `UNION` / `UNION ALL`                         | Combiner des requêtes                                   |
| 🥈      | `EXISTS` / `NOT EXISTS`                       | Tester l’existence ou l’absence de lignes               |
| 🥈      | `COALESCE()`                                  | Premier champ non nul (alternative à NVL plus souple)   |
| 🥈      | `HAVING COUNT(*) > 1`                         | Détecter les doublons après groupement                  |
| 🥉      | `GROUP BY ROLLUP`                             | Totaux cumulés (hiérarchie)                             |
| 🥉      | `GROUP BY CUBE`                               | Totaux toutes combinaisons possibles                    |
| 🥉      | `GROUPING SETS`                               | Totaux personnalisés                                    |
| 🥉      | `SUM(CASE WHEN ...)`                          | Comptage conditionnel                                   |
| 🥉      | `COUNT(DISTINCT colonne)`                     | Nombre de valeurs uniques                               |
| 🥉      | `HAVING` avec agrégats complexes              | Filtrage avancé des groupes                             |
| 🧠      | `PARTITION BY`                                | Regrouper les lignes sans les agréger                   |
| 🧠      | `ROW_NUMBER()`                                | Numéro de ligne unique dans une partition               |
| 🧠      | `RANK()` / `DENSE_RANK()`                     | Classement avec ou sans saut de rang                    |
| 🧠      | `LAG()` / `LEAD()`                            | Comparaison avec la ligne précédente ou suivante        |
| 🧠      | `NTILE(n)`                                    | Diviser les lignes en n groupes égaux                   |
| 🧠      | `WINDOW`                                      | Définir des fenêtres personnalisées                     |
| 🔧      | `WITH` (CTE)                                  | Lisibilité et réutilisation des sous-requêtes           |
| 🔧      | `MINUS` / `INTERSECT`                         | Différence ou intersection de deux requêtes             |
| 🔧      | `ROWNUM`                                      | Ancienne méthode pour limiter les lignes (Oracle < 12c) |
| 🔧      | `MAX()`, `MIN()`, `VARIANCE()`, `STDDEV()`    | Statistiques utiles                                     |
| 🔧      | `TRUNC()`, `ADD_MONTHS()`, `MONTHS_BETWEEN()` | Fonctions temporelles pratiques                         |

| Pratique              | Pourquoi c’est utile                                 |
| --------------------- | ---------------------------------------------------- |
| `NVL(colonne, 0)`     | Remplace les `NULL` par zéro dans les calculs.       |
| `TO_DATE()`           | Pour gérer les dates au format Oracle.               |
| Vues ou sous-requêtes | Pour éviter des `JOIN` complexes dans AXML.          |
| `ORDER BY` + `LIMIT`  | Pour trier et restreindre le résultat (si supporté). |
