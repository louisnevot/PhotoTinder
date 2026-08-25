# PhotoTinder

App iOS perso (100% gratuite, hors App Store) pour trier ses photos façon Tinder :
swipe à droite = garder, swipe à gauche = supprimer.

## Comment l'installer sur ton iPhone (sans Mac)

### 1. Mettre le code sur GitHub
1. Va sur https://github.com/new, crée un dépôt (public), par ex. `PhotoTinder`.
2. Sur ton PC, télécharge ce dossier `PhotoTinder` (ou clique "Add file" > "Upload files"
   sur la page du dépôt GitHub et glisse-dépose tout le contenu de ce dossier, en
   gardant bien la structure des sous-dossiers `Sources/` et `.github/workflows/`).
3. Valide (commit) sur la branche `main`.

### 2. Lancer la compilation
1. Dans ton dépôt GitHub, va dans l'onglet **Actions**.
2. Clique sur le workflow **Build PhotoTinder IPA** → bouton **Run workflow** → **Run workflow**.
3. Attends ~3-5 minutes que ça devienne vert ✅.
4. Clique sur le run terminé → en bas, section **Artifacts** → télécharge **PhotoTinder-IPA**
   (c'est un .zip qui contient `PhotoTinder.ipa`).

### 3. Installer AltStore sur ton PC Windows (ou Mac)
1. Va sur https://altstore.io et télécharge **AltServer**.
2. Installe-le, lance-le (il tourne dans la barre système / menu bar).
3. Connecte ton iPhone en USB à ton PC (iTunes ou Apple Devices doit être installé
   pour que le PC reconnaisse l'iPhone).
4. Clique sur l'icône AltServer → **Install AltStore** → choisis ton iPhone →
   entre ton identifiant Apple gratuit quand demandé.
5. AltStore s'installe sur ton iPhone (icône visible sur l'écran d'accueil).

### 4. Installer PhotoTinder via AltStore
1. Sur ton iPhone : Réglages → Général → VPN et gestion de l'appareil →
   fais confiance à ton identifiant Apple (première fois seulement).
2. Ouvre **AltStore** sur l'iPhone → onglet **Mes Apps** → bouton **+** en haut.
3. Sélectionne le fichier `PhotoTinder.ipa` (transfère-le sur l'iPhone via AirDrop,
   Fichiers/iCloud, mail à toi-même, ou le câble USB + app Fichiers).
4. L'app s'installe avec sa propre icône sur l'écran d'accueil.

### 5. Autoriser l'accès aux photos
Au premier lancement, l'app demande l'accès à tes photos : autorise "Accès total".

### 6. Renouvellement automatique (tous les 7 jours)
Tant qu'AltServer tourne sur ton PC (même en arrière-plan) et que ton iPhone est
sur le même wifi de temps en temps, AltStore renouvelle l'app tout seul avant
l'expiration. Sinon, ouvre juste AltStore sur l'iPhone (bouton "Refresh All")
quand ton PC est allumé et sur le même réseau.

## Modifier l'app plus tard
Si tu veux changer une couleur, un texte, un comportement : édite les fichiers
dans `Sources/`, valide sur GitHub, relance le workflow (étape 2), retélécharge
le nouvel `.ipa`, réinstalle via AltStore (étape 4).
