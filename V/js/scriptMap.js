var joueurs = [];
$(function(){


	if(getUrlParameter("hote") == $("#username").text()){//joueur hôte
	joueurs.push({pseudoJoueur1:getUrlParameter("hote")});
	$("#state").html("En attente d'un second joueur...");
	//JQUERY UI mettre en place une fenêtre modale
	PollingAttenteSecondJoueur();
	}
	else if(getUrlParameter("hote") != $("#username").text()){ //second joueur
		joueurs.push({pseudoJoueur1:getUrlParameter("hote")});
		joueurs.push({pseudoJoueur2:$("#username").text()});
		verifierConnJoueurs("pseudoJoueur1");
	}

});

function PollingAttenteSecondJoueur()
{
	$.post("index.php?controle=services&action=verifierSecondJoueur",{},function(data)
		{
			if(getUrlParameter("hote") == $("#username").text()){
				$("#state").html("Joueur <b>"+data.enregistrements[0].pseudoJoueur2+" vous a rejoint !</b>");
				joueurs.push({pseudoJoueur2:data.enregistrements[0].pseudoJoueur2});
				verifierConnJoueurs("pseudoJoueur2");
				PollingAttenteChoixCoords();
			}
		});
}

function PollingAttenteChoixCoords()
{
	console.log("Launch polling...");
	$.post("index.php?controle=jeuCarte&action=choixCoordonnees",{pseudoJoueur1:joueurs[0],pseudoJoueur2:joueurs[1]},function(data)
	{
		if(data.length > 0)
		{
			console.log(data);
		}
		else
			PollingAttenteChoixCoords();
	});
}

function verifierConnJoueurs(verifierJoueur)
{
	$.post("index.php?controle=services&action=verifierConnJoueur",{joueurAdv:verifierJoueur},function(data)
	{
		if(verifierJoueur=="pseudoJoueur1")
		{
			console.log((data=="Connecté")?"Hôte connecté":"Hôte déconnecté");
			if(data=="Connecté")
			{
				$("#state").html("<b>Requête envoyé à l'hôte avec succès</b>");
			}
		}
		else
		{
			console.log((data=="Connecté")?"Second joueur connecté":"Second joueur déconnecté");
		}
		$("#instructions").css("display","block");
		PollingAttenteChoixCoords();
	});
}



function getUrlParameter(sParam) {
    var sPageURL = decodeURIComponent(window.location.search.substring(1)),
        sURLVariables = sPageURL.split('&'),
        sParameterName,
        i;

    for (i = 0; i < sURLVariables.length; i++) {
        sParameterName = sURLVariables[i].split('=');

        if (sParameterName[0] === sParam) {
            return sParameterName[1] === undefined ? true : sParameterName[1];
        }
    }
};