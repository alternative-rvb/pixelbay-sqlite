# Requetes SQL Cheat Sheet

Voici quelques requêtes SQL utiles dans le contexte de ta table `GL` (grand livre) et de ta table `projet` :

### 1. **Utilisation de `IN` pour filtrer plusieurs projets** :

```sql
SELECT *
FROM GL
WHERE projet_id IN (101, 102, 103);
```

Cela te permet de récupérer toutes les entrées du grand livre pour une liste de projets spécifiques.

### 2. **Filtrer par plage de dates** :

```sql
SELECT *
FROM GL
WHERE date BETWEEN '2024-01-01' AND '2024-12-31';
```

Ici, tu filtres les entrées du grand livre sur une période spécifique.

### 3. **Filtrer par montant supérieur ou inférieur à une valeur** :

```sql
SELECT *
FROM GL
WHERE montant > 10000;
```

Tu peux ainsi filtrer les entrées du grand livre pour celles dont le montant dépasse une certaine valeur.

### 4. **Utilisation de `LIKE` pour filtrer par nom de projet** :

```sql
SELECT g.*
FROM GL g
JOIN projet p ON g.projet_id = p.projet_id
WHERE p.nom LIKE 'Développement%';
```

Ce filtre récupère toutes les entrées du grand livre pour les projets dont le nom commence par "Développement".

### 5. **Combinaison de filtres avec `AND` et `OR`** :

```sql
SELECT *
FROM GL
WHERE projet_id = 123
  AND montant > 5000
  AND date >= '2024-01-01';
```

Ici, tu filtres les entrées du grand livre pour un projet spécifique, avec un montant supérieur à 5000 et une date à partir du 1er janvier 2024.

