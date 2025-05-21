# Guide pratique : Interroger l'API OData Northwind

Ce guide montre comment interroger l'API REST publique suivante avec des paramètres OData :

**Base URL** : [https://services.odata.org/V4/Northwind/Northwind.svc/](https://services.odata.org/V4/Northwind/Northwind.svc/)

L'API supporte les filtres OData courants : `$filter`, `$select`, `$orderby`, `$top`, `$skip`, `$expand`, `$count`, et dans une moindre mesure `$apply` (groupement/agrégation).

---

## 🔹 Cheat Sheet OData - Northwind

| Objectif                          | Exemple d’URL                                           | Équivalent SQL                                |
| --------------------------------- | ------------------------------------------------------- | --------------------------------------------- |
| Obtenir tous les produits         | `/Products`                                             | `SELECT * FROM Products`                      |
| Sélectionner des colonnes         | `/Products?$select=ProductName,UnitPrice`               | `SELECT ProductName, UnitPrice FROM Products` |
| Filtrer par égalité               | `/Products?$filter=CategoryID eq 1`                     | `WHERE CategoryID = 1`                        |
| Filtrer avec plusieurs conditions | `/Products?$filter=CategoryID eq 1 and UnitPrice gt 20` | `WHERE CategoryID = 1 AND UnitPrice > 20`     |
| Trier par prix décroissant        | `/Products?$orderby=UnitPrice desc`                     | `ORDER BY UnitPrice DESC`                     |
| Limiter le nombre de résultats    | `/Products?$top=5`                                      | `FETCH FIRST 5 ROWS ONLY`                     |
| Sauter des résultats              | `/Products?$skip=10`                                    | `OFFSET 10 ROWS`                              |
| Pagination                        | `/Products?$top=5&$skip=10`                             | `OFFSET 10 ROWS FETCH NEXT 5 ROWS ONLY`       |
| Compter les produits              | `/Products/$count`                                      | `SELECT COUNT(*) FROM Products`               |
| Début de chaîne                   | `/Products?$filter=startswith(ProductName,'Ch')`        | `WHERE ProductName LIKE 'Ch%'`                |
| Contient une chaîne               | `/Products?$filter=contains(ProductName,'ola')`         | `WHERE ProductName LIKE '%ola%'`              |

---

## 🔹 Jointures avec `$expand`

| Objectif                                 | Exemple d’URL                                                                    | SQL approximatif                                                |
| ---------------------------------------- | -------------------------------------------------------------------------------- | --------------------------------------------------------------- |
| Produit avec sa catégorie                | `/Products?$expand=Category`                                                     | `JOIN Categories ON Products.CategoryID = Categories.ID`        |
| Client avec ses commandes                | `/Customers?$expand=Orders`                                                      | `LEFT JOIN Orders ON Customers.CustomerID = Orders.CustomerID`  |
| Commandes > 100                          | `/Customers?$expand=Orders($filter=Freight gt 100)`                              | `LEFT JOIN Orders WHERE Freight > 100`                          |
| Produit avec nom de catégorie uniquement | `/Products?$expand=Category($select=CategoryName)&$select=ProductName,UnitPrice` | `SELECT ProductName, UnitPrice, CategoryName FROM Products ...` |

---

## 🔹 Opérateurs de filtre `$filter`

| OData               | SQL            |
| ------------------- | -------------- |
| `eq`                | `=`            |
| `ne`                | `!=`           |
| `gt`                | `>`            |
| `ge`                | `>=`           |
| `lt`                | `<`            |
| `le`                | `<=`           |
| `and`               | `AND`          |
| `or`                | `OR`           |
| `startswith(a,'x')` | `a LIKE 'x%'`  |
| `contains(a,'x')`   | `a LIKE '%x%'` |

---

## ℹ️ Points à connaître

* Les chaînes doivent être entourées d’apostrophes simples `'`.
* La casse est importante (`ProductName` ≠ `productname`).
* `$apply` (agrégations comme `SUM`, `GROUP BY`) est rarement supporté dans les API publiques.
* Tu peux chaîner les paramètres : `/Products?$select=X&$filter=...&$orderby=...`


