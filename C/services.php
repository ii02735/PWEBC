<?php

function getBDDInstance()
{
	require_once("./M/MySQLClass.php");
    $bdd = MySQL::init("localhost","projet_pwebc","root","root");
    return $bdd;
}

function getListeJoueurs()
{
	echo (getBDDInstance()->fetchData("Joueur",array("Pseudo","Connexion"),'WHERE Pseudo <> \''.$_SESSION['Joueur'].'\' AND Pseudo like \'%'.$_POST['recherche'].'%\''));
}

function afficherServices()
{
	if(isset($_SESSION['partie']) AND !empty($_SESSION['partie']))
		unset($_SESSION['partie']);
	if(isset($_SESSION["Joueur"]) && !empty($_SESSION["Joueur"]))
		require("./V/services.tpl");
	else
		header("Location:index.php");
}


function creerPartieLibre()
{
	$a = json_decode((getBDDInstance()->fetchAllData("Partie","WHERE PseudoJoueur1='".$_SESSION['Joueur']."' AND PseudoJoueur2 IS NULL")));
	if(!isset($a) AND empty($a)){
		getBDDInstance()->insertData("Partie",array("PseudoJoueur1"),array($_SESSION["Joueur"]));
		$a = json_decode(getBDDInstance()->fetchAllData("Partie","WHERE PseudoJoueur1='".$_SESSION['Joueur']."' AND PseudoJoueur2 IS NULL"))->enregistrements[0];
		$_SESSION['partie'] = $a->IdPartie;
		echo $_SESSION['partie'];
	}
	else
		echo "failure";
}


function recupererIdPartie()
{
	$_SESSION['partie'] = getBDDInstance()->fetchData("Partie",array("IdPartie"),"WHERE (PseudoJoueur1='".$_SESSION['Joueur']."' OR PseudoJoueur2='".$_SESSION['Joueur']."') AND Etat='en cours'");
	echo $_SESSION['partie'];
}

function recupererIdPartieLibre()
{
	echo $_SESSION['partie']; //La variable a déjà été attribuée ultérieurement depuis la fonction lancée en AJAX 
}

function recupererIdPartieLibreRej()
{
	$a = json_decode((getBDDInstance()->fetchAllData("Partie","WHERE PseudoJoueur2='".$_SESSION['Joueur']."' AND Etat='inactif'")));
	$_SESSION['partie'] = $a->enregistrements[0]->IdPartie;
	getBDDInstance()->updateData("Partie","Etat","en cours","WHERE IdPartie = ".$_SESSION['partie']);
	echo $_SESSION['partie'];
}

function recupererPartieLibre()
{
	echo getBDDInstance()->fetchData("Partie",array("IdPartie","PseudoJoueur1"),"WHERE Etat='inactif' AND PseudoJoueur1 <> '".$_SESSION["Joueur"]."'");
}

function afficherJeu()
{
	require("./V/jeu.tpl");
}

function creerCoords()
{
	//On récupère l'id de la partie en premier
	getBDDInstance()->insertData("Coords",array("IdPartie","Latitude","Longitude","PseudoJoueur"),array($_POST["sessionPartie"],$_POST["lat"],$_POST["lng"],$_SESSION["Joueur"]));
	$_SESSION['partie'] = $_POST["sessionPartie"];
}

function debutPartie()
{
	echo (getBDDInstance()->getDBObject()->query("SELECT * FROM Partie WHERE IdPartie=".$_SESSION['partie'])->fetchColumn());
}


function getSession()
{
	echo($_SESSION['Joueur']);
}

function changerStatutPartieLibre()
{
	getBDDInstance()->updateData("Partie","Etat",$_POST['statut'],"WHERE IdPartie=".$_POST['IdPartie']);
}

function getCoords()
{
	echo getBDDInstance()->fetchData("Coords",array("Latitude","Longitude"),"WHERE IdPartie=".$_POST['partie']." AND PseudoJoueur <> '".$_SESSION["Joueur"]."'");
}