Le jeu la traque g�ographique reprend � peu pr�s le concept de la bataille navale.
Deux joueurs se choisissent une base sur une carte leaflet, puis ensuite essaient de se localiser mutuellement.

L'inscription marche sous AJAX pour v�rifier si le pseudo existe d�j�.

Il existe 2 modes de jeu :
- D�signer un autre joueur connect� (d�pend de la valeur bool�enne Connexion dans la table Joueur)
La communication se fait par websockets
- Lancer une partie libre : on attend qu'un autre joueur rejoigne la partie libre depuis la section "gestionnaire
de parties"


Pour d�marrer l'application WEB :

- Importer le fichier PWEBC.sql dans la base de donn�es (phpmyadmin ou cmd)
- Vous pourrez visualiser les comptes existants, donc leur pseudo et leur mot de passe.
Des comptes existants :
- Pseudo : root 
  Mot de passe : as13ue!+
- Pseudo : bilaal
  Mot de passe : as13ue!+
- Vous pouvez �galement cr�er votre propre compte depuis le service d'inscription.
La v�rification du mot de passe � l'inscription ne concerne que sa longueur, pas sa complexit�

- Pour utiliser les websockets :
Ex�cuter le script lancerServeurWin.sh --> ouvrira le port 8081 pour la communication 
Attention : le script fonctionne uniquement pour une version PHP de 7.1.12, le r�pertoire risque de ne pas exister
si elle est ex�cut�e sous une version d'UwAmp. Pour y rem�dier, ex�cuter le fichier php.exe depuis la racine du dossier de projet avec le script php websocket_server.php

Ce qui donne : <chemin fichier php.exe> ./server_Sockets/server/websocket_server.php

La cr�ation d'une partie se fait si les 2 joueurs ont accept� mutuellement de s'affronter (s�lection mode sp�cification joueur).
Dans le cas contraire, une partie sera cr��e mais en �tat "inactif" d'apr�s la table Partie dans la base de donn�es. L'�tat sera mis � jour � "en cours" lorsqu'un joueur aura d�cid� de rejoindre un autre joueur qui attend un adversaire (s�lection mode partie libre).

L'application n'�tant pas achev�e, les seuls fonctionnalit�s � terminer se trouvent dans le jeu :
Apr�s s�lection d'une base chez les 2 joueurs, ils doivent pouvoir se localiser mutuellement, cependant la communication tour par tour semble avoir des soucis (marche correctement mais une fois sur deux...notamment lorsqu'on clique sur la carte Leaflet : l'application ne veut pas mettre un autre marqueur)

Il est important de cliquer sur "se d�connecter" si on souhaite quitter l'application (sinon lors de la prochaine connexion, pour la s�lection d'un joueur pour faire une partie, la liste g�n�r�e par JQuery UI risque d'�tre inchang�e : les joueurs qui ont quitt� l'application seront vus comme �tant connect�s).

Fonctionnalit�s qui pourraient �tre rajout�es :
- Mettre en place le syst�me de score (distance entre les coordonn�es originales et les coordonn�es propos�es pour localisation)
- Evoluer le syst�me d'indices qui ne se r�sume uniquement � la localisation du pays de la base du joueur adverse...