$(function()
{
//Expression régulière pour la saisie du mail
var emailRegex = /(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])/;
var champMdpInscr = $("#password_inscription");
//Lorsqu'on affiche les formulaires au lancement de la page, ces derniers sont vides
//Donc on désactive les boutons de soumission

//Il est plus pratique de désactiver les boutons de soumissions plutôt que de BLOQUER la soumission depuis un return false
$("#formConn > input[type='submit']").prop('disabled',true);
$("#formInscr > input[type='submit']").prop('disabled',true);

$("#formInscr > input[name='pseudo']").keyup(function(){
	$.get("index.php?controle=register&action=PseudoExistant&testPseudo="+this.value,function(data){
		if(data.length > 1)
		{
			$("#validPseudo").removeClass();
			$("#validPseudo").addClass("erreur");
			$("#validPseudo").addClass("pseudoErr");
		}
		else if($("#formInscr > input[name='pseudo']").val().length > 0){
			$("#validPseudo").removeClass();
			$("#validPseudo").addClass("checked");
		}
		else
		{
			$("#validPseudo").removeClass();
			$("#validPseudo").addClass("empty");
		}
		console.log(data);
	});
	$("#formInscr > input[type='submit']").prop('disabled',allChecked() && verifierCode(champMdpInscr.val()));
})

//Vérification du mot de passe pour l'inscription
$("#password_inscription").keyup(function(){

	//Si les champs sont vides OU que la vérification du mot de passe échoue
	/*On pourrait très bien vérifier si tous les champs sont remplis pour chaque champ, mais 
	  comme le champ du mot de passe nécessite une autre vérification (validité mot de passe),
	  on fait une pierre deux coups
	*/
	//Détermine si le bouton doit être disabled (true donc inactif) ou actif (false)
	$("#formInscr > input[type='submit']").prop('disabled',allChecked() && verifierCode(champMdpInscr.val()));		
	//allChecked retourne un booléen comme pour vérifierCode
});

//Vérification du mot de passe pour la connexion
$("#password_connexion").keyup(function(){

	//Idem qu'au dessus
	$("#formInscr > input[type='submit']").prop('disabled',allChecked() && verifierCode(champMdpInscr.val()));		
});

//Champ mail
$("#formInscr input[name='mail']").keyup(function(){
	$.get("index.php?controle=register&action=EmailExistant&testEmail="+this.value,function(data){
	if($("#formInscr input[name='mail']").val().length == 0){ //On vérifie si le champ n'est pas vide
		$("#validMail").removeClass(); //Si oui on enlève toute classe précédente
		$("#validMail").addClass("empty");//On met la classe empty à l'élément
	}
	else if(data.length > 1)//On vérifie d'abord que la regex soit valide PUIS on regarde si l'adresse mail est déjà utilisée
	{
		$("#validMail").removeClass();
		$("#validMail").addClass("erreur");
		$("#validMail").addClass("mailErr2");
	}
	else if(!verifExprReg($("#formInscr input[name='mail']").val(),emailRegex)) //Si la vérification du regex échoue
	{
		$("#validMail").removeClass();
		$("#validMail").addClass("erreur");
		$("#validMail").addClass("mailErr");//On peut mettre plusieurs classes
		$("#formInscr > input[type='submit']").prop('disabled',true);
	}
	else
	{
		$("#validMail").removeClass();
		$("#validMail").addClass("checked");
	}
	});
	$("#formInscr > input[type='submit']").prop('disabled',allChecked() && verifierCode(champMdpInscr.val()));		
});


	//Comparaison de 2 booléens : faux && faux = faux, vrai && faux = vrai, vrai && vrai = vrai
	//On a 2 booléens car nos 2 méthodes retournent un booléen

//On s'occupe maintenant de la connexion (qui est aussi idem)
$("#formConn > input[name='pseudo']").keyup(function(){
	$("#formConn input[type='submit']").prop('disabled',verifierChamps("#formConn input:not([type='submit'])"));
})

$("#password_connexion").keyup(function(){
	$("#formConn input[type='submit']").prop('disabled',verifierChamps("#formConn input:not([type='submit'])"));
})

});

function allChecked()
{
	return $("#error small:not(.checked)").length > 0;
}

function verifExprReg(string,expr)
{
	if(!(expr.test(string)))
		return false;
	else
		return true;
}

function verifierChamps(formulaireElements)
{
	var result = false;
	$(formulaireElements).each(function()
	{
		if($(this).val().length < 1){
			result = true;
			return false; // Attention, dans each return false équivaut à un break ! Tandis que return true équivault à un continue !
		}
	});
	return result;
}

function verifierCode(valeur)
{
	if(valeur.length == 0)
	{
		$("#StrongMeter").removeClass();
		$("#error #validMdp").removeClass();
		//On a utilisé des classes écrites depuis le CSS, elles procurent une couleur + un contenu
		//Cela est plus rapide plutôt que de modifier le CSS depuis JQuery ET d'ajouter du texte...
		$("#error #validMdp").addClass("empty");
	}
	else if(valeur.length <= 5)
	{
		$("#error #validMdp").removeClass();
		$("#error #validMdp").addClass("erreur");
		$("#error #validMdp").addClass("mdpErr");
		$("#StrongMeter").removeClass();
		$("#StrongMeter").addClass("faible");
	}
	else if(valeur.length > 5 && valeur.length < 10)
	{
		$("#error #validMdp").removeClass();
		$("#error #validMdp").addClass("mdpUnsure");
		$("#error #validMdp").addClass("checked");
		$("#StrongMeter").removeClass();
		$("#StrongMeter").addClass("moyen");
	}
	else
	{
		$("#error #validMdp").removeClass();
		$("#error #validMdp").addClass("checked");
		$("#StrongMeter").removeClass();
		$("#StrongMeter").addClass("fort");
	}
}