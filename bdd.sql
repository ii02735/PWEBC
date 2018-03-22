SET foreign_key_checks = 0;
DROP DATABASE IF EXISTS projet_pwebc;
DROP TABLE IF EXISTS Joueur;
DROP TABLE IF EXISTS Partie;
DROP TABLE IF EXISTS Score;

SET foreign_key_checks = 'ON';

CREATE DATABASE projet_pwebc;
USE projet_pwebc;
CREATE TABLE Joueur
(
	Pseudo VARCHAR(50) PRIMARY KEY NOT NULL,
	Mdp VARCHAR(50) NOT NULL,
	Email VARCHAR(50) NOT NULL,
	Victoires INT DEFAULT 0,
	Connexion BOOLEAN DEFAULT 0
);

CREATE TABLE Partie(
	IdPartie INT Primary Key AUTO_INCREMENT,
	DatePartie TIMESTAMP DEFAULT NOW(),
	pseudoJoueur1 VARCHAR(50) NOT NULL DEFAULT 'null',
	pseudoJoueur2 VARCHAR(50),
	ScoreJoueur1 INT NOT NULL DEFAULT 0,
        ScoreJoueur2 INT NOT NULL DEFAULT 0,
	Gagnant VARCHAR(50),
	ScoreGagnant INT NOT NULL DEFAULT 0,
	FOREIGN KEY (pseudoJoueur1) REFERENCES Joueur(Pseudo),
	FOREIGN KEY (pseudoJoueur2) REFERENCES Joueur(Pseudo),
	Etat ENUM('inactif','sur ecoute','en cours','fini') NOT NULL DEFAULT 'inactif'
);

CREATE TABLE Score
(	
	Points INT NOT NULL DEFAULT 0,
	Pseudo VARCHAR(50),
	IdPartie INT,
	FOREIGN KEY (IdPartie) REFERENCES Partie(IdPartie), 
	FOREIGN KEY (Pseudo) REFERENCES Joueur(Pseudo)
);

CREATE TABLE Coords
(
	IdPartie INT NOT NULL,
	Latitude DECIMAL(10,8) NOT NULL,
	Longitude DECIMAL(10,8) NOT NULL,
	PseudoJoueur VARCHAR(50) NOT NULL,
	FOREIGN KEY(PseudoJoueur) REFERENCES Joueur(Pseudo),
	CONSTRAINT FK_IdPartie FOREIGN KEY(IdPartie) REFERENCES Partie(IdPartie)
);

DELIMITER //
CREATE TRIGGER inserer_scores AFTER UPDATE ON Partie
FOR EACH ROW
BEGIN
	DECLARE scoreJoueur1 integer;
	DECLARE scoreJoueur2 integer;
	SET scoreJoueur1 = (SELECT Points From Score WHERE Pseudo = old.PseudoJoueur1 AND IdPartie = old.IdPartie);
	SET scoreJoueur2 = (SELECT Points From Score WHERE Pseudo = old.PseudoJoueur2 AND IdPartie = old.IdPartie);
IF old.Etat  = 'fini' THEN
    IF scoreJoueur1 > scoreJoueur2 THEN
	UPDATE Partie SET Gagnant = old.PseudoJoueur1 WHERE IdPartie = old.IdPartie;
	UPDATE Partie SET ScoreGagnant = scoreJoueur1 WHERE IdPartie = old.IdPartie;
	UPDATE Joueur SET Victoires = Victoires + 1 WHERE Pseudo = old.PseudoJoueur1;
   ELSE
	UPDATE Partie SET Gagnant = old.PseudoJoueur2 WHERE IdPartie = old.IdPartie;
	UPDATE Partie SET ScoreGagnant = scoreJoueur2  WHERE IdPartie = old.IdPartie;
	UPDATE Joueur SET Victoires = Victoires + 1 WHERE Pseudo = old.PseudoJoueur2;
   END IF;
   END IF;
END //
DELIMITER ;
