<?php
require("./M/MySQLClass.php");
$bdd = MySQL::init("localhost","projet_pwebc","root","root");
$a = json_decode(($bdd->fetchAllData("Partie","WHERE PseudoJoueur1='root' AND PseudoJoueur2 IS NULL")));
echo is_null($a);

//print_r(($bdd->fetchData("Joueur",array("Pseudo","Connexion"),'WHERE Pseudo <> \'bilaal\' AND Pseudo like \'%t%\'')));
?>

