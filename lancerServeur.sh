#!/bin/sh
if [ -d "server_Sockets/" ]; then 
	cd "server_Sockets/server"
	echo "Démarrage du serveur Apache sur le port 8081..."
	php "websocket_server.php"
else
echo "Erreur durant l'accès au chemin server_Sockets/server"
fi
