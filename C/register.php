<?php

function getFormConnection()
{
	if(isset($_SESSION["Joueur"]) && !empty($_SESSION["Joueur"]))
		header("Location:index.php?controle=services&action=afficherServices");
	else
		require("./V/connInscr.tpl");
}

function getBDDInstance()
{
	require_once("./M/MySQLClass.php");
    $bdd = MySQL::init("localhost","projet_pwebc","root","root");
    return $bdd;
}

function inscription()
{
    getBDDInstance()->insertData("Joueur",array('Pseudo','Mdp','Email'),array($_POST['pseudo'],$_POST['mdp'],$_POST['email']));
    $_SESSION["Joueur"] = $_POST["pseudo"];
    header("Location:index.php?controle=services&action=afficherServices");
}	  

function checkPseudo()
{
	echo getBDDInstance()->fetchAllData("Joueur","WHERE Pseudo='".$_POST['pseudo']."'");
}

function checkEmail()
{
	echo getBDDInstance()->fetchAllData("Joueur","WHERE Email='".$_POST['email']."'");
}

//Lancer l'ajax en premier avant la connexion
function verification()
{
	echo getBDDInstance()->fetchAllData("Joueur","WHERE Pseudo='".$_POST["pseudoConnexion"]."' AND Mdp='".$_POST["mdpConnexion"]."'");
}

function connexion()
{
	$_SESSION["Joueur"] = $_POST["pseudoConnexion"];
	header("Location:index.php?controle=services&action=afficherServices");
}

function deconnexion()
{
	session_destroy();
	header("Location:index.php");
}