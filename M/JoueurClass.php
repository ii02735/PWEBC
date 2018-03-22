<?php

	class Joueur{
		
		private $MySQLObject;
		private static $JoueurInstance = null;

		private function __construct($MySQLObject)
        {
            $this->MySQLObject = $MySQLObject;
        }

        public static function init($MySQLObject)
        {
            if(is_null(self::$JoueurInstance))
                self::$JoueurInstance = new Joueur($MySQLObject);
            return self::$JoueurInstance;
        }

        public function inscription($Pseudo,$mdp,$email)
        {
            $this->MySQLObject->insertData("Joueur",array("Pseudo","mdp","email"),array($Pseudo,$mdp,$email));
        }

        public function donneesJoueur()
        {
            $this->MySQLObject->fetchData("Joueur",array("Pseudo","email","Victoires"));
        }

        public function changerMDP($pseudo,$mdp)
        {
            $this->MySQLObject->updateData("Joueur","Mdp",$mdp,"WHERE Pseudo = '$pseudo'");
        }
		
		public function connexion($pseudo,$mdp)
        {
            if(($this->MySQLObject->checkIfExists("Joueur", "WHERE Pseudo='$pseudo' AND Mdp ='$mdp'"))){
				$this->MySQLObject->updateData("Joueur","Connexion",1,"WHERE Pseudo ='$pseudo'");
               $_SESSION["joueur"] = $pseudo;
               return true;
            }
                return false;
        }
		
        public function estConnecte($pseudo)
        {
            if($this->MySQLObject->fetchData("Joueur",array("Connexion"),"WHERE Pseudo='$pseudo'") == 1)
                return true;
            else
                return false;
        }

		public function deconnexion($pseudo)
        {
			$this->MySQLObject->updateData("Joueur","Connexion",0,"WHERE Pseudo = '$pseudo'");
			session_destroy();
        }
    }