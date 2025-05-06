# 📚 Exercices JavaScript : Fonctions constructeurs, prototypes et fonctions retournant des fonctions

Bienvenue dans cette série d'exercices pratiques sur JavaScript ! Vous allez explorer des concepts essentiels tels que les fonctions constructeurs, les prototypes, les fermetures, et bien plus encore. Ces exercices sont conçus pour renforcer vos compétences en programmation orientée objet et en manipulation de fonctions. Prenez votre temps, expérimentez, et amusez-vous à coder !

## Exercice 1 : Créer un constructeur `Animal`

Crée une fonction constructeur `Animal` qui prend un nom et un type d’animal (ex: "chien") et les stocke dans l’objet. Ajoute une méthode `sePresenter()` qui affiche une phrase comme : "Je suis Rex, un chien."

<details>
<summary>💡Indice</summary>
Utilise `this.nom` et `this.type` dans le constructeur. Ajoute `sePresenter` dans `Animal.prototype`.
</details>

<details>
<summary>✅Solution</summary>

```js
function Animal(nom, type) {
  this.nom = nom;
  this.type = type;
}

Animal.prototype.sePresenter = function() {
  console.log(`Je suis ${this.nom}, un ${this.type}.`);
}

const rex = new Animal("Rex", "chien");
rex.sePresenter(); // Je suis Rex, un chien.
````

</details>

## Exercice 2 : Étendre un prototype

Ajoute une méthode `crier()` au prototype d’`Animal` qui dit : "Le \[type] fait un bruit !"

<details>
<summary>💡Indice</summary>
Ajoute une méthode à `Animal.prototype`, utilise `this.type`.
</details>

<details>
<summary>✅Solution</summary>

```js
Animal.prototype.crier = function() {
  console.log(`Le ${this.type} fait un bruit !`);
}

rex.crier(); // Le chien fait un bruit !
```

</details>

## Exercice 3 : Fonction qui retourne une fonction

Crée une fonction `multiplierPar(facteur)` qui retourne une fonction qui multiplie une valeur par ce facteur. Cette fonction peut être utile dans des calculs métiers (ex: calcul de TVA, ajustements dynamiques, etc.)

<details>
<summary>💡Indice</summary>
Retourne une fonction anonyme qui utilise la variable `facteur`.
</details>

<details>
<summary>✅Solution</summary>

```js
function multiplierPar(facteur) {
  return function(valeur) {
    return valeur * facteur;
  }
}

const doubler = multiplierPar(2);
console.log(doubler(5)); // 10
```

</details>

## Exercice 4 : Ajouter un compteur avec fermeture

Crée une fonction `compteur()` qui retourne une fonction. À chaque appel, cette fonction doit incrémenter et afficher un nombre : 1, puis 2, puis 3...

<details>
<summary>💡Indice</summary>
Utilise une variable interne `let count = 0` et retourne une fonction qui fait `count++`.
</details>

<details>
<summary>✅Solution</summary>

```js
function compteur() {
  let count = 0;
  return function() {
    count++;
    console.log(count);
  }
}

const monCompteur = compteur();
monCompteur(); // 1
monCompteur(); // 2
```

</details>

## Exercice 5 : Vérifier si un objet est une instance

Crée une fonction `estAnimal(obj)` qui retourne vrai si l’objet vient de `Animal`, faux sinon.

<details>
<summary>💡Indice</summary>
Utilise `instanceof` pour vérifier le prototype de l’objet.
</details>

<details>
<summary>✅Solution</summary>

```js
function estAnimal(obj) {
  return obj instanceof Animal;
}

console.log(estAnimal(rex)); // true
console.log(estAnimal({}));  // false
```

</details>

## Exercice 6 : Simuler un décorateur pour marquer une classe

Crée une fonction `Espèce(type)` qui simule un décorateur. Elle doit ajouter une propriété `espece` à la classe sur laquelle elle est appliquée.

Utilisation attendue :

```js
Espèce("chat")(class Chat {})
````

➡️ Doit ajouter `Chat.prototype.espece = "chat"`

<details>
<summary>💡Indice</summary>
Ta fonction `Espèce` doit retourner une autre fonction qui prend une classe comme paramètre, puis ajoute une propriété à son `prototype`.
</details>

<details>
<summary>✅Solution</summary>

```js
function Espèce(type) {
  return function(target) {
    target.prototype.espece = type;
  }
}

// Classe Chat
class Chat {
  miauler() {
    console.log("Miaou !");
  }
}

// Appliquer le décorateur à la main
Espèce("chat")(Chat);

const felix = new Chat();
console.log(felix.espece); // chat
felix.miauler(); // Miaou !
```

</details>



