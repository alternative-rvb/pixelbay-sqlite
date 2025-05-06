# PixelBay SQLite

[![MIT License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![SQLite](https://img.shields.io/badge/SQLite-3.49.1-blue)](https://sqlite.org/)
[![Bun](https://img.shields.io/badge/Bun-1.2.11-green)](https://bun.sh/)
[![Node.js](https://img.shields.io/badge/Node.js-22.12.0-green)](https://nodejs.org/)
[![Hono](https://img.shields.io/badge/Hono-4.7.8-orange)](https://hono.dev/)
[![Contributions Welcome](https://img.shields.io/badge/Contributions-Welcome-brightgreen)](https://github.com/alternative-rvb/pixelbay-sqlite/pulls)

PixelBay SQLite est un projet développé avec Bun, Hono et SQLite comme solution de base de données légère.

Ce projet permet de gérer des jeux de données de gestion et s'entraîner aux requêtes SQL ainsi qu'au développement JavaScript pour manipuler ces données.

Le projet inclut également des exercices pratiques en JavaScript et des démonstrations d'API REST utilisant Bun et Hono.

## Fonctionnalités

- Gestion de base de données légère et rapide avec SQLite.
- Jeux de données de gestion pour s'entraîner aux requêtes SQL.
- Exercices JavaScript pour manipuler les données.
- Implémentation d'API REST avec Bun et Hono.

## Prérequis

- **SQLite** : Assurez-vous que SQLite est installé sur votre système.
- **Node.js** : Pour les exercices JavaScript.
- **Bun** : Nécessaire pour exécuter les exemples d'API REST.

## Installation

1. Clonez le dépôt :
    ```bash
    git clone https://github.com/alternative-rvb/pixelbay-sqlite.git
    cd pixelbay-sqlite
    ```

1. Exécutez le script Bash pour configurer la base de données SQLite :
    ```bash
    bash setup-pixelbay-sqlite.sh
    ```

1. Exécutez les requêtes SQL générées par le script
    à l'aide de SQLite :
    ```
    sqlite-queries/0.00-init/0.01-create_schema_and_data.sql
    ```

1. Installez Bun si ce n'est pas déjà fait :
    ```bash
    curl https://bun.sh/install | bash
    ```

1. Installez les dépendances du projet avec Bun :
    ```bash
    bun install
    ```

1. Lancez l'application principale ou explorez les exercices :
    ```bash
    # Exemple pour lancer un script principal
    bun server.js
    ```

Pour les exercices JavaScript et API REST, suivez les instructions spécifiques dans les sous-dossiers correspondants.

## Utilisation

- Explorez les jeux de données de gestion fournis pour vous entraîner aux requêtes SQL.
- Manipulez les données avec les exercices JavaScript.
- Testez les API REST avec Bun et Hono pour des cas d'utilisation avancés.

## Contribution

Les contributions sont les bienvenues ! Veuillez forker le dépôt et soumettre une pull request.

## Licence

Ce projet est sous licence MIT. Consultez le fichier [LICENSE](LICENSE) pour plus de détails.

## Remerciements

- SQLite pour sa solution de base de données légère.
- Bun et Hono pour leurs outils performants pour les API REST.
- Les contributeurs open source pour leur soutien.

## Auteur

[Alternative RVB](https://github.com/alternative-rvb) - Développeur principal et mainteneur du projet.
