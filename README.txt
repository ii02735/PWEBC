Le jeu la traque géographique reprend à peu près le concept de la bataille navale.
Deux joueurs se choisissent une base sur une carte leaflet, puis ensuite essaient de se localiser mutuellement.

L'inscription marche sous AJAX pour vérifier si le pseudo existe déjà.

Il existe 2 modes de jeu :
- Désigner un autre joueur connecté (dépend de la valeur booléenne Connexion dans la table Joueur)
La communication se fait par websockets
- Lancer une partie libre : on attend qu'un autre joueur rejoigne la partie libre depuis la section "gestionnaire
de parties"


Pour démarrer l'application WEB :

- Importer le fichier PWEBC.sql dans la base de données (phpmyadmin ou cmd)
- Vous pourrez visualiser les comptes existants, donc leur pseudo et leur mot de passe.
Des comptes existants :
- Pseudo : root 
  Mot de passe : as13ue!+
- Pseudo : bilaal
  Mot de passe : as13ue!+
- Vous pouvez également créer votre propre compte depuis le service d'inscription.
La vérification du mot de passe à l'inscription ne concerne que sa longueur, pas sa complexité

- Pour utiliser les websockets :
Exécuter le script lancerServeurWin.sh --> ouvrira le port 8081 pour la communication 
Attention : le script fonctionne uniquement pour une version PHP de 7.1.12, le répertoire risque de ne pas exister
si elle est exécutée sous une version d'UwAmp. Pour y remédier, exécuter le fichier php.exe depuis la racine du dossier de projet avec le script php websocket_server.php

Ce qui donne : <chemin fichier php.exe> ./server_Sockets/server/websocket_server.php

La création d'une partie se fait si les 2 joueurs ont accepté mutuellement de s'affronter (sélection mode spécification joueur).
Dans le cas contraire, une partie sera créée mais en état "inactif" d'après la table Partie dans la base de données. L'état sera mis à jour à "en cours" lorsqu'un joueur aura décidé de rejoindre un autre joueur qui attend un adversaire (sélection mode partie libre).

L'application n'étant pas achevée, les seuls fonctionnalités à terminer se trouvent dans le jeu :
Après sélection d'une base chez les 2 joueurs, ils doivent pouvoir se localiser mutuellement, cependant la communication tour par tour semble avoir des soucis (marche correctement mais une fois sur deux...notamment lorsqu'on clique sur la carte Leaflet : l'application ne veut pas mettre un autre marqueur)

Il est important de cliquer sur "se déconnecter" si on souhaite quitter l'application (sinon lors de la prochaine connexion, pour la sélection d'un joueur pour faire une partie, la liste générée par JQuery UI risque d'être inchangée : les joueurs qui ont quitté l'application seront vus comme étant connectés).

Fonctionnalités qui pourraient être rajoutées :
- Mettre en place le système de score (distance entre les coordonnées originales et les coordonnées proposées pour localisation)
- Evoluer le système d'indices qui ne se résume uniquement à la localisation du pays de la base du joueur adverse...