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
</head>

<body>
		
	<header class="container-fluid mb-5 banner">
		<h2 class="text-center py-4 display-5 headertitle">La traque géographique</h2>
		<a class="text-center" href="index.php?controle=register&action=deconnexion">Se déconnecter</a>
	</header>

<div class="container">
	<h3 class="text-center">Bienvenue <?php echo $_SESSION["Joueur"] ?> !</h3>
	<h5 class="text-center">Que souhaitez-vous faire ?</h5>
<div id="accordion">
  <div class="card">
    <div class="card-header" id="headingOne">
      <h5 class="mb-0">
 		<button class="container btn btn-play text-justify" type="button" data-toggle="collapse" data-target="#collapseOne" aria-expanded="true" aria-controls="collapseOne">Commencer une partie</button>
      </h5>
    </div>

    <div id="collapseOne" class="collapse show" aria-labelledby="headingOne" data-parent="#accordion">
      <div class="card-body row">
       <form action="index.php?controle=services&action=afficherJeu" method="post" class="col-12 col-md-6" id="seekPlayer">
			<p class="text-center">
				<b>Rejoindre un joueur :</b><br/>
				Envoyez une invitation à un joueur pour qu'il puisse vous affronter !
			</p>
			<label for="pseudoJoueur" style="display:block" class="text-center">Pseudo du joueur :</label>
			<div class="ui-widget">
				<input type="text" name='pseudoJoueur' class="form-control mb-3">
			</div>
			<input type="submit" value="Créer une partie !" role="button" class="btn btn-form mx-auto">
			<small id="joueurSelectionne"></small>
		</form>
		<form id="freeGame" action="index.php?controle=services&action=afficherJeu&jeu=libre" method="post" class="col-12 col-md-6 my-auto pt-4 pt-md-0">
			<p class="text-center">
				<b>Mode partie libre :</b><br/>
				Créez une partie et attendez qu'un joueur vous rejoigne !
			</p>
			<input type="submit" value="Créer une partie libre !" role="button" class="btn btn-form mx-auto">
			<small id="joueurSelectionne"></small>
		</form>
      </div>
    </div>
  </div>
  <div class="card">
    <div class="card-header" id="headingTwo">
      <h5 class="mb-0">
		<button class="container btn btn-game text-justify" type="button" data-toggle="collapse" data-target="#collapseTwo" aria-expanded="true" aria-controls="collapseTwo">Gestionnaire de parties</button>
      </h5>
    </div>
    <div id="collapseTwo" class="collapse" aria-labelledby="headingTwo" data-parent="#accordion">
      <div class="card-body">
      	<div id="row">
		<table id="partiesLibres" class='table col-12 col-md-6 col-lg-6'>
			<tr>
				<th>Id de la partie</th>
				<th>Joueur</th>
			</tr>
		</table>
		</div>
      </div>
    </div>
  </div>
</div>
</div>
<div class="modal fade" id="invitation" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="titreDialog"></h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div id="messageDialog" class="modal-body">
      </div>
      <div class="modal-footer">
      	<button id="deny" type="button" class="btn btn-form">Non</button>
        <button id="accept" type="button" class="btn btn-form">Oui</button>
      </div>
    </div>
  </div>
</div>

<div class="modal fade" id="refus" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="refusDialog"></h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div id="messageRefus" class="modal-body">
      </div>
      <div class="modal-footer">
        <button id="okbutton" type="button" class="btn btn-form">OK</button>
      </div>
    </div>
  </div>
</div>
	<script src="bootstrap-4.0.0/dist/js/jquery-min.js"></script>
	<script src="bootstrap-4.0.0/dist/js/popper.min.js"></script>
	<script src="bootstrap-4.0.0/dist/js/bootstrap.min.js"></script>
	<script src="./V/js/jquery-ui.min.js"></script>
	<script src="./V/js/scriptServices.js"></script>
</body>
</html>
