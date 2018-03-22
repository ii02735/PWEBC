<?php

function getBDDInstance()
{
	require_once("./M/MySQLClass.php");
	$bdd = MySQL::init("localhost","projet_pwebc","root","root");
	return $bdd;
}

function getJoueurObject()
{
	require_once('./M/JoueurClass.php');
	return Joueur::init(getBDDInstance());
}

function getGestionnairePartieObject()
{
	require_once('./M/GestionnairePartieClass.php');
	return GestionnairePartie::init(getBDDInstance());
}

function envoyerCoordonnees()
{
	getBDDInstance()->insertData("Coords",array("IdPartie","Latitude","Longitude","pseudoJoueur"),array($_SESSION["IdPartie"],$_POST["lat"],$_POST["lon"],$_SESSION["joueur"]));
	echo "Coordonnées ".$_POST["lat"].",".$_POST["lon"]." transmises";
}

function choixCoordonnees()
{
	require_once("./M/pollingClass.php");
	$poll = new Polling(getGestionnairePartieObject());
	echo $poll->checkUpdates("choixCoordonnees");
}