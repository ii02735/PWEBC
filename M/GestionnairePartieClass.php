<?php

	class GestionnairePartie{
		
		private $MySQLObject;
		private static $PartieInstance = null;

		private function __construct($MySQLObject)
        {
            $this->MySQLObject = $MySQLObject;
        }

        public static function init($MySQLObject)
        {
            if(is_null(self::$PartieInstance))
                self::$PartieInstance = new GestionnairePartie($MySQLObject);
            return self::$PartieInstance;
        }
        public function creerPartie($pseudoSecondJoueur)
        {
            $this->MySQLObject->insertData("Partie",array("pseudoJoueur1","pseudoJoueur2"),array($_SESSION["joueur"],$pseudoSecondJoueur));
        }

        public function creerPartieLibre()
        {
            if(!$this->partieExistante()){
                $this->MySQLObject->insertData("Partie",array("pseudoJoueur1"),array($_SESSION["joueur"]));
                return true;
            }
            else
                return false;       
        }

        public function recupererDernierePartie()//Renvoie la partie la plus récente créée
        {
            $temp = json_decode($this->MySQLObject->fetchData("Partie",array("IdPartie"),"ORDER BY IdPartie DESC LIMIT 1",true));
            return $temp->enregistrements[0]->IdPartie; 
        }

        public function listerPartiesJouees($pseudoJoueur){
           return $this->MySQLObject->fetchData("Partie",array("DatePartie,pseudoJoueur2,ScoreJoueur1,ScoreJoueur2,Gagnant"),"WHERE Pseudo='$pseudoJoueur' AND Etat='fini'",true);
        }

        public function listerPartiesLibres(){
            return $this->MySQLObject->fetchData("Partie",array("IdPartie,pseudoJoueur1","Etat"),"WHERE pseudoJoueur2 is null AND Etat='inactif'",true);
        }

        public function partieExistante()
        {
            return $this->MySQLObject->checkIfExists("Partie","WHERE pseudoJoueur1 = '".$_SESSION["joueur"]."' AND Etat='inactif'") > 0;
        }

        public function effacerPartie()
        {
            $this->MySQLObject->deleteData('Partie','WHERE IdPartie = '.$_POST["IdPartie"]);
        }

        public function changerEtatPartie($IdPartie,$etat)
        {
            $this->MySQLObject->updateData('Partie','Etat',$etat,"WHERE IdPartie=$IdPartie");
        }

        public function detecterSecondJoueur()//Pour démarrer une partie
        {
            return $this->MySQLObject->fetchData('Partie',array('pseudoJoueur2'),"WHERE IdPartie=".$_SESSION["IdPartie"],true);
        }

        public function verifierConnJoueur()//les 2 joueurs doivent bien être connectés
        {
            $connexionJoueurAdv = $this->MySQLObject->getDBObject()->query("SELECT Connexion FROM Joueur WHERE Pseudo=(SELECT ".$_POST["joueurAdv"]." FROM Partie WHERE IdPartie=".$_SESSION["IdPartie"].")")->fetch();
            return ($connexionJoueurAdv["Connexion"] == 1)?"Connecté":"Hors ligne";
        }

        public function choixCoordonnees()
        {
            $coordJoueur1 = $this->MySQLObject->fetchData("Coords",array("Latitude","Longitude"),"WHERE PseudoJoueur ='".$_POST["pseudoJoueur1"]."' AND IdPartie=".$_SESSION["IdPartie"],true);

            $coordJoueur2 = $this->MySQLObject->fetchData("Coords",array("Latitude","Longitude"),"WHERE PseudoJoueur ='".$_POST["pseudoJoueur2"]."' AND IdPartie=".$_SESSION["IdPartie"],true);

            return array($coordJoueur1,$coordJoueur2);
        }
    }