<!DOCTYPE html>
<html lang="fr">
<head>
	<title></title>
	<meta charset="utf-8">
	<link rel="stylesheet" href="bootstrap-4.0.0/dist/css/bootstrap.min.css">
	<link href="https://fonts.googleapis.com/css?family=Pacifico|Comfortaa" rel="stylesheet">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<link rel="stylesheet" href="./V/css/style.css">
	<link rel="stylesheet" href="./V/css/jquery-ui.min.css">
	<link href="./V/leaflet/leaflet.css" rel="stylesheet">


</head>

<body>
	
	<header class="container-fluid mb-5 banner">
		<h2 class="text-center py-4 display-5 headertitle">La traque géographique</h2>
		<a class="text-center" href="index.php?controle=register&action=deconnexion">Se déconnecter</a>
	</header>

<div class="container">
	<h3 class="text-center" id="statutPartie">
		<?php if(!empty($_GET['premierJoueur']) AND !empty($_GET['secondJoueur']))
				echo $_GET['premierJoueur']." VS ".$_GET['secondJoueur'];
			  else
			  	echo "En attente d'un adversaire...";?>
	</h3>
	<div id="map"></div>
	<button id="gps" class="btn btn-form">Utiliser le GPS</button>
</div>

	<div class="modal fade" id="attendsAdv" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
	  <div class="modal-dialog modal-dialog-centered" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h5 class="modal-title" id="titleAttAdv">Halte !</h5>
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	          <span aria-hidden="true">&times;</span>
	        </button>
	      </div>
	      <div class="modal-body">
	      	Vous ne pouvez plus choisir une autre position !
	      </div>
	      <div class="modal-footer">
	        <button id="okWait" type="button" class="btn btn-form">OK</button>
	      </div>
	    </div>
	  </div>
	</div>

	<div class="container">
		
	</div>

	<div class="modal fade" id="notifCoords" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
	  <div class="modal-dialog modal-dialog-centered" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h5 class="modal-title" id="titleAttAdv">Coordonnées choisies</h5>
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	          <span aria-hidden="true">&times;</span>
	        </button>
	      </div>
	      <div class="modal-body">
	      </div>
	      <div class="modal-footer">
	        <button id="okWait2" type="button" class="btn btn-form">OK</button>
	      </div>
	    </div>
	  </div>
	</div>

	<script src="bootstrap-4.0.0/dist/js/jquery-min.js"></script>
	<script src="bootstrap-4.0.0/dist/js/popper.min.js"></script>
	<script src="bootstrap-4.0.0/dist/js/bootstrap.min.js"></script>
	<script src="./V/js/jquery-ui.min.js"></script>
	<script src="./V/leaflet/leaflet.js"></script>
	<script src="./V/js/scriptJeu.js"></script>
</body>
</html>
