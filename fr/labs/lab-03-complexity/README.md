---
nav_exclude: true
permalink: /fr/labs/lab-03-complexity/
title: "Lab 03 : Analyse de complexité"
description: "Analyser la complexité cyclomatique dans les 5 applications de démonstration à l'aide de Lizard et convertir les résultats au format SARIF."
---

# Lab 03 : Analyse de complexité

| Durée | Niveau | Prérequis |
|-------|--------|-----------|
| 30 min | Intermédiaire | Lab 02 |

## Objectifs d'apprentissage

- Comprendre la complexité cyclomatique (CCN) et pourquoi elle est importante
- Exécuter Lizard pour mesurer la complexité au niveau des fonctions
- Interpréter les scores CCN, la longueur des fonctions et le nombre de paramètres
- Convertir la sortie de Lizard au format SARIF à l'aide de `lizard-to-sarif.py`
- Identifier les fonctions qui dépassent les seuils de complexité

## Prérequis

- [Lab 02 : Linting](../lab-02-linting/) terminé
- Lizard installé (`pip install lizard`)

## Exercices

### Exercice 1 : Comprendre la complexité cyclomatique

La complexité cyclomatique (CCN) mesure le nombre de chemins d'exécution indépendants à travers une fonction. Un CCN plus élevé signifie plus de chemins à tester, un code plus difficile à comprendre et une probabilité de défauts plus élevée.

| Plage CCN | Niveau de risque | Action |
|-----------|-----------------|--------|
| 1–5 | Faible | Simple, facile à tester |
| 6–10 | Modéré | Acceptable, envisager une refactorisation |
| 11–20 | Élevé | Devrait être refactorisé — avertissement CI |
| 21+ | Très élevé | Doit être refactorisé — erreur CI |

L'atelier utilise un **seuil de 10** pour la porte de qualité CI.

### Exercice 2 : Exécuter Lizard sur toutes les applications

> **Répertoire de travail** : Exécutez les commandes suivantes depuis la racine du dépôt `code-quality-scan-demo-app`.

Exécutez Lizard sur toutes les applications de démonstration pour obtenir un résumé :

```powershell
lizard cq-demo-app-001/src cq-demo-app-002/src cq-demo-app-003/src cq-demo-app-004/src cq-demo-app-005/ --CCN 10
```

Lizard affiche un tableau avec les colonnes suivantes :

| Colonne | Description |
|---------|-------------|
| NLOC | Lignes de code hors commentaires |
| CCN | Nombre de complexité cyclomatique |
| Token | Nombre de jetons |
| PARAM | Nombre de paramètres |
| Length | Longueur totale de la fonction en lignes |
| Location | Chemin du fichier et nom de la fonction |

![Sortie de Lizard montrant les métriques de complexité](../../../images/lab-03/lab-03-lizard-output.png)

### Exercice 3 : Générer une sortie CSV

Générez une sortie CSV pour un traitement programmatique :

```powershell
lizard cq-demo-app-001/src cq-demo-app-002/src cq-demo-app-003/src cq-demo-app-004/src cq-demo-app-005/ --csv > lizard-output.csv
```

Affichez les premières lignes du CSV :

```powershell
Get-Content lizard-output.csv | Select-Object -First 15
```

Le CSV contient une ligne par fonction avec les colonnes : NLOC, CCN, Token, PARAM, Length, Location, File, Function, Start, End.

![Sortie CSV de Lizard](../../../images/lab-03/lab-03-lizard-csv.png)

### Exercice 4 : Convertir au format SARIF

Utilisez le convertisseur `lizard-to-sarif.py` pour transformer la sortie CSV de Lizard en SARIF :

```powershell
python src/converters/lizard-to-sarif.py --input lizard-output.csv --output complexity.sarif --ccn-threshold 10 --length-threshold 50
```

Le convertisseur crée un résultat SARIF pour chaque fonction qui dépasse l'un ou l'autre seuil :

- **CCN > 10** : Signalé comme violation de complexité
- **Longueur > 50 lignes** : Signalé comme violation de longueur de fonction

Examinez le SARIF généré :

```powershell
Get-Content complexity.sarif | ConvertFrom-Json | Select-Object -ExpandProperty runs | Select-Object -ExpandProperty results | Select-Object ruleId, level, @{N='function';E={$_.locations[0].physicalLocation.artifactLocation.uri}} | Format-Table
```

![Sortie de conversion lizard-to-sarif.py](../../../images/lab-03/lab-03-sarif-conversion.png)

### Exercice 5 : Identifier les fonctions à haute complexité

Filtrez les fonctions qui dépassent le seuil CCN :

```powershell
lizard cq-demo-app-001/src cq-demo-app-002/src cq-demo-app-003/src cq-demo-app-004/src cq-demo-app-005/ --CCN 10 --warnings_only
```

Pour chaque fonction signalée, notez :

1. **Quelle fonction** a une complexité élevée
2. **Ce qui la cause** — `if/else` imbriqués, instructions `switch`, boucles dans des boucles
3. **Comment la corriger** — extraire des fonctions auxiliaires, utiliser des retours anticipés, remplacer les conditions par des tables de correspondance

![Fonctions dépassant le seuil CCN](../../../images/lab-03/lab-03-high-ccn-functions.png)

### Exercice 6 : Analyser la profondeur d'imbrication

Examinez les fonctions les plus complexes et identifiez les motifs d'imbrication :

```powershell
lizard cq-demo-app-001/src cq-demo-app-002/src --CCN 15 --warnings_only -L 100
```

Causes courantes de complexité élevée :

| Motif | Impact CCN | Stratégie de refactorisation |
|-------|-----------|------------------------------|
| Chaînes `if/else` imbriquées | +1 par branche | Extraire en clauses de garde avec retours anticipés |
| `switch` avec de nombreux cas | +1 par cas | Utiliser une table de correspondance / dictionnaire |
| Boucle + condition | Multiplicatif | Extraire la logique interne dans une fonction |
| Try/catch avec réessai | +2–3 | Extraire la logique de réessai dans un utilitaire |

## Point de vérification

Vérifiez votre travail avant de continuer :

- [ ] Lizard s'est exécuté avec succès sur les 5 applications de démonstration
- [ ] Vous avez généré `lizard-output.csv` avec les métriques au niveau des fonctions
- [ ] Vous avez converti le CSV en `complexity.sarif` à l'aide de `lizard-to-sarif.py`
- [ ] Vous avez identifié au moins 3 fonctions avec un CCN > 10
- [ ] Vous comprenez la différence entre CCN et longueur de fonction

## Résumé

L'analyse de la complexité cyclomatique avec Lizard fournit des métriques de qualité au niveau des fonctions qui complètent les résultats de linting. Les fonctions à CCN élevé sont plus difficiles à tester, plus sujettes aux erreurs et difficiles à maintenir. En convertissant la sortie de Lizard en SARIF, vous pouvez suivre les tendances de complexité aux côtés des résultats de linting et de couverture dans un tableau de bord unifié.

Le seuil de l'atelier de CCN ≤ 10 est aligné sur les meilleures pratiques de l'industrie. Les fonctions dépassant ce seuil devraient être refactorisées en extrayant des fonctions auxiliaires, en utilisant des retours anticipés et en remplaçant les conditions complexes par des motifs de table de correspondance.

## Étapes suivantes

Passez au [Lab 04 : Détection de duplication](../lab-04-duplication/).
