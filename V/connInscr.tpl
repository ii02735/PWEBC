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
		
	<header class="container-fluid banner mb-5">
		<h2 class="text-center py-4 display-5 headertitle">La traque géographique</h2>
	</header>
	<section class="container">
		<article class="row d-md-flex justify-content-center">
			<div class="formConnSub col-12 col-md-5 mx-0 mx-md-1 col-lg-5 col-xl-5 mx-lg-2 mx-xl-4 my-3 my-lg-0 my-md-0">
				<div class="px-2 py-2">
					<h3>Inscrivez-vous</h3>
					<p class="pt-3">Pas de compte ? Inscrivez-vous c'est gratuit !</p>
					<form method="post" action="index.php?controle=register&action=inscription">
						<label for="pseudo"><b>Votre pseudo :</b></label>
							<input id="pseudoInscr" name="pseudo" type="text" class="form-control">
							<div class="small mb-2" id="erreurPseudo"></div>
						<label for="mdp"><b>Votre mot de passe :</b></label>
							<input id="passwordInscr" name="mdp" type="password" class="form-control mb-2">
							<div id="strengthBar" class="mb-3"><span></span></div>
						<label for="email"><b>Votre adresse mail :</b></label>
							<input id="email" type="mail" name="email" class="form-control mb-3">
							<div class="small mb-2" id="erreurMail"></div>
						<input id="btnInscr" type="submit" value="valider" role="button" class="btn btn-form mx-auto">
					</form>
				</div>
			</div>
			<div class="formConnSub col-12 col-md-5 mx-md-1 col-lg-5 col-xl-5 mx-lg-2 mx-xl-4">
				<div class="px-2 py-2">
					<h3>Connectez-vous</h3>
					<p class="pt-3">Authentifiez-vous avant de traquer des adversaires !</p>
						<form method="post" action="index.php?controle=register&action=connexion" id="connecter">
						<label for="pseudoConnexion"><b>Votre pseudo :</b></label>
							<input id="pseudoConn" name="pseudoConnexion" type="text" class="form-control mb-3">
						<label for="mdpConnexion"><b>Votre mot de passe :</b></label>
							<input id="MdpConn" name="mdpConnexion" type="password" class="form-control mb-3">
						<input id="btnConn" type="submit" value="valider" role="button" class="btn btn-form mx-auto">
						<div id="erreur" class="mt-2" style="color:crimson"></div>
					</form>
				</div>
			</div>
		</article>
	</section>
	
	<script src="bootstrap-4.0.0/dist/js/jquery-min.js"></script>
	<script src="bootstrap-4.0.0/dist/js/popper.min.js"></script>
	<script src="bootstrap-4.0.0/dist/js/bootstrap.min.js"></script>
	<script src="./V/js/jquery-ui.min.js"></script>
	<script src="./V/js/scriptRegistry.js"></script>
</body>
</html>
