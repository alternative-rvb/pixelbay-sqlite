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

## ℹ️ Points à connaître

| Pratique              | Pourquoi c’est utile                                 |
| --------------------- | ---------------------------------------------------- |
| `NVL(colonne, 0)`     | Remplace les `NULL` par zéro dans les calculs.       |
| `TO_DATE()`           | Pour gérer les dates au format Oracle.               |
| Vues ou sous-requêtes | Pour éviter des `JOIN` complexes dans AXML.          |
| `ORDER BY` + `LIMIT`  | Pour trier et restreindre le résultat (si supporté). |
| `WITH`                | Pour créer des sous-requêtes temporaires.            |
| `UNION`               | Pour combiner plusieurs requêtes.                    |
| `ROLLUP`              | Pour des totaux intermédiaires dans les agrégats.    |
| `HAVING`              | Pour filtrer les résultats d’un `GROUP BY`.           |
| `CASE`                | Pour des conditions complexes dans les sélections.   |
| `COALESCE()`          | Pour gérer les valeurs manquantes.                   |
| `DISTINCT`            | Pour éviter les doublons dans les résultats.         |
| `ORDER BY`            | Pour trier les résultats selon un ou plusieurs champs. |
| `LIMIT`               | Pour restreindre le nombre de résultats retournés.    |
| `OFFSET`              | Pour paginer les résultats.                          |
| `FETCH FIRST`         | Pour limiter le nombre de lignes retournées.         |
| `ROWNUM`             | Pour limiter le nombre de lignes dans une requête.   |
| `EXISTS`              | Pour vérifier l’existence de lignes dans une sous-requête. |
| `NOT EXISTS`          | Pour vérifier l'absence de lignes dans une sous-requête. |
| `UNION ALL`           | Pour combiner les résultats de plusieurs requêtes sans éliminer les doublons. |
| `INTERSECT`           | Pour obtenir les lignes communes entre deux requêtes. |
| `MINUS`               | Pour obtenir les lignes d'une requête qui ne sont pas dans une autre. |
| `WITH ROLLUP`         | Pour obtenir des totaux cumulés dans les résultats.  |
| `WITH CUBE`           | Pour obtenir des totaux cumulés sur plusieurs dimensions. |
| `GROUPING SETS`       | Pour définir des ensembles de regroupement personnalisés. |
| `PARTITION BY`        | Pour diviser les résultats en partitions pour les fonctions analytiques. |
| `WINDOW`              | Pour définir des fenêtres pour les fonctions analytiques. |
| `LAG()`               | Pour accéder à la valeur d'une ligne précédente dans une partition. |
| `LEAD()`              | Pour accéder à la valeur d'une ligne suivante dans une partition. |
| `RANK()`              | Pour attribuer un rang à chaque ligne dans une partition. |
| `DENSE_RANK()`        | Pour attribuer un rang sans sauter de valeurs en cas de doublons. |
| `NTILE(n)`            | Pour diviser les résultats en n groupes égaux.       |
| `ROW_NUMBER()`        | Pour attribuer un numéro de ligne unique à chaque ligne dans une partition. |
| `SUM()`               | Pour calculer la somme des valeurs d'une colonne.    |
| `AVG()`               | Pour calculer la moyenne des valeurs d'une colonne.  |
| `COUNT()`             | Pour compter le nombre de lignes ou de valeurs non nulles. |
| `MAX()`               | Pour obtenir la valeur maximale d'une colonne.       |
| `MIN()`               | Pour obtenir la valeur minimale d'une colonne.       |
| `STDDEV()`            | Pour calculer l'écart type des valeurs d'une colonne. |
| `VARIANCE()`          | Pour calculer la variance des valeurs d'une colonne.  |
| `SUM(CASE WHEN condition THEN 1 ELSE 0 END)` | Pour compter les lignes qui répondent à une condition. |
| `COUNT(DISTINCT colonne)` | Pour compter les valeurs uniques d'une colonne.     |
| `GROUP BY ROLLUP(colonne)` | Pour obtenir des totaux cumulés sur une colonne.   |
| `GROUP BY CUBE(colonne)` | Pour obtenir des totaux cumulés sur plusieurs colonnes. |
| `GROUP BY GROUPING SETS(colonne1, colonne2)` | Pour obtenir des totaux cumulés sur des ensembles de colonnes. |
| `HAVING COUNT(*) > 1` | Pour filtrer les groupes ayant plus d'une ligne.    |
| `HAVING SUM(montant) > 10000` | Pour filtrer les groupes ayant un montant total supérieur à 10 000. |
| `HAVING AVG(montant) < 1000` | Pour filtrer les groupes ayant une moyenne inférieure à 1 000. |
| `HAVING MAX(date_operation) < TO_DATE('2024-01-01', 'YYYY-MM-DD')` | Pour filtrer les groupes dont la date maximale est antérieure au 1er janvier 2024. |
| `HAVING MIN(montant) IS NOT NULL` | Pour filtrer les groupes ayant au moins une valeur non nulle. |
| `HAVING COUNT(DISTINCT colonne) > 1` | Pour filtrer les groupes ayant plus d'une valeur unique. |
| `HAVING SUM(CASE WHEN condition THEN 1 ELSE 0 END) > 0` | Pour filtrer les groupes ayant au moins une ligne répondant à une condition. |
| `HAVING COUNT(*) > 0` | Pour filtrer les groupes ayant au moins une ligne.   |
| `HAVING COUNT(*) = 0` | Pour filtrer les groupes n'ayant aucune ligne.       |
| `HAVING COUNT(*) BETWEEN 1 AND 10` | Pour filtrer les groupes ayant entre 1 et 10 lignes. |
| `HAVING COUNT(*) > (SELECT AVG(count) FROM (SELECT COUNT(*) AS count FROM GL GROUP BY project_id))` | Pour filtrer les groupes ayant plus de lignes que la moyenne. |
