<?php

if(session_status() == PHP_SESSION_NONE){
	session_start();
}
		

if((count($_GET)!=0) && !(isset($_GET['controle']) && isset($_GET['action']))){
	require('./vue/erreur404.tpl');
}
	
else{
	if(count($_GET)==0){
		$controle="register";
		$action="getFormConnection";	
	}
	
	if (isset($_GET['controle']) & isset($_GET['action'])) {
		$controle = $_GET['controle'];
		$action= $_GET['action'];
	}
		
	//inclure le fichier php de contrôle 
	//et lancer la fonction-action issue de ce fichier.	
	require ('./C/' . $controle . '.php');   
	$action (); 
}	

?>

