# Guide pratique : Interroger une API REST Oracle avec les paramètres OData  
_Un cheat sheet clair et concis pour filtrer, trier et agréger les données via l'URL_

---

### Introduction

Certaines API REST, comme celles exposées par **Oracle REST Data Services (ORDS)**, acceptent des **paramètres OData** dans l’URL. Ces paramètres permettent d’imiter des requêtes SQL classiques (filtrage, tri, pagination, agrégation) directement via l’URL, sans écrire de SQL. Ce guide synthétise les cas d’usage les plus utiles.

---

### Cheat Sheet — Requêtes OData courantes

| Objectif                             | Exemple d’URL                                                              | Équivalent SQL                                                   |
|--------------------------------------|----------------------------------------------------------------------------|------------------------------------------------------------------|
| Obtenir toutes les données           | `/api/employes`                                                            | `SELECT * FROM employes;`                                       |
| Sélectionner certaines colonnes      | `/api/employes?$select=nom,prenom`                                         | `SELECT nom, prenom FROM employes;`                             |
| Filtrer par égalité                  | `/api/employes?$filter=ville eq 'Paris'`                                   | `WHERE ville = 'Paris'`                                         |
| Filtrer avec plusieurs conditions    | `/api/employes?$filter=ville eq 'Paris' and age gt 30`                     | `WHERE ville = 'Paris' AND age > 30`                            |
| Tri croissant/décroissant            | `/api/employes?$orderby=nom desc`                                          | `ORDER BY nom DESC`                                             |
| Limiter les résultats                | `/api/employes?$top=10`                                                    | `FETCH FIRST 10 ROWS ONLY`                                      |
| Ignorer les premiers résultats       | `/api/employes?$skip=20`                                                   | `OFFSET 20 ROWS`                                                |
| Pagination complète                  | `/api/employes?$top=10&$skip=20`                                           | `OFFSET 20 ROWS FETCH NEXT 10 ROWS ONLY`                        |
| Compter les enregistrements          | `/api/employes/$count`                                                     | `SELECT COUNT(*) FROM employes;`                                |
| Somme avec groupement (si supporté)  | `/api/employes?$apply=groupby((departement), aggregate(salaire with sum))` | `SELECT departement, SUM(salaire) FROM employes GROUP BY departement;` |
| Filtrer par début de chaîne (`startswith`) | `/api/employes?$filter=startswith(nom, 'Du')`                        | `WHERE nom LIKE 'Du%'`                                          |
| Filtrer par contenu (`contains`)     | `/api/employes?$filter=contains(nom, 'bert')`                              | `WHERE nom LIKE '%bert%'`                                       |

---

### Opérateurs de filtre (`$filter`)

| OData               | SQL équivalent     |
|---------------------|--------------------|
| `eq`                | `=`                |
| `ne`                | `!=`               |
| `gt`                | `>`                |
| `ge`                | `>=`               |
| `lt`                | `<`                |
| `le`                | `<=`               |
| `and`               | `AND`              |
| `or`                | `OR`               |
| `startswith(a, 'x')`| `a LIKE 'x%'`      |
| `contains(a, 'x')`  | `a LIKE '%x%'`     |

---

### À savoir

- Les paramètres `$select`, `$filter`, `$orderby`, `$top`, `$skip` sont **généralement supportés**.
- `$apply` (agrégations, groupements) peut ne pas être disponible selon l’implémentation.
- Les valeurs de texte doivent être encadrées d’apostrophes simples `'`.
- Les opérations mathématiques ne sont **pas possibles dans l’URL**, mais peuvent être intégrées dans une **vue SQL côté Oracle**.

