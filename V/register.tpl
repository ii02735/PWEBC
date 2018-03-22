

<!DOCTYPE html>
	<html lang="fr-FR">
	<head>
		<meta charset="utf-8">
		<title>authentification</title>
		<link rel="stylesheet" type="text/css" href="./V/css/style.css">
	</head>
	<body>	

		<h3>Connectez-vous</h3>
		<form id="formConn" action="index.php?controle=register&action=connexion" method="post">
			<label for="pseudo">Pseudo / Mail : </label>
			<input type="text" name="pseudo">
			<label for="mdp">Mot de passe :</label>
			<input id="password_connexion" type="password" name="mdp">
			<input type="submit" value="Se connecter" id="connexion">
		</form>
		<div id="errorConn" class="erreur"><small><?php echo (isset($message)?$message:null)?></small></div>
		<br/>
		<button>Nouveau joueur ?</button>
		<div id="formulaire_inscription" title="Inscrivez-vous">
		<form id="formInscr" action="index.php?controle=register&action=inscrireJoueur" method="post">
			<label for="pseudo">Pseudo : </label>
			<input type="text" name="pseudo">
			<br/>
			<label for="mdp">Mot de passe :</label>
			<input id="password_inscription" type="password" name="mdp">
			<small id="StrongMeter">
			</small>
			<br/>
			<label for="mail">Mail :</label>
			<input type="text" name="mail">
			<br>
			<input type="submit" value="Valider" id="inscription">
			<ul id="error">
				<li><small id="validPseudo" class="empty">Pseudo : </small></li>
				<li><small id="validMdp" class="empty">Mot de passe : </small></li>
				<li><small id="validMail" class="empty">Email : </small></li>
			</ul>
		</form>
		</div>

	<script src="./V/js/jquery_min.js"></script>
	<script src="./V/js/jquery-ui.js"></script>
	<script src="./V/js/script.js">
	</script>
	</body>
</html>