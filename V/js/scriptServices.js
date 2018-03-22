var tab = [];
var secondJoueur = null;
var sessionJoueur = null;
$(function(){	

	$.get("index.php?controle=services&action=getSession",function(data)
	{
		sessionJoueur = data.replace(/[\n\r]+/g, '');
	})
	var websocket_server = new WebSocket("ws://localhost:8081/");
		websocket_server.onopen = function(e) {
			websocket_server.send(
				JSON.stringify({
					'type':'socket',
					'user_id':sessionJoueur
				})
			);
		};
		websocket_server.onerror = function(e) {
			// Errorhandling
		}
		websocket_server.onmessage = function(e)
		{
			var json = JSON.parse(e.data);
			switch(json.type) {
				case 'inviter':
				if(json.adversaire == sessionJoueur)
				{
					adversaire = json.emetteur;
					$("#titreDialog").text(json.info);
					$("#messageDialog").html("<strong>"+adversaire+"</strong> souhaite vous affronter !<br/>Acceptez-vous sa demande ?");
					$("#invitation").modal({
						    backdrop: 'static',
			    			keyboard: false
					})
					
				}
				break;
				case 'refuser':
				if(json.adversaire == sessionJoueur)
				{
					$("#refusDialog").text(json.info);
					$("#messageRefus").html(json.msg);
					$("#refus").modal({
						    backdrop: 'static',
			    			keyboard: false
					})
					
				}
				break;
				case 'accepter':
				if(json.adversaire == sessionJoueur)
				{
					window.location.href=json.redirection;
				}
				break;
				case 'partieLibre':
				$("#partiesLibres").html("<tr><th>Joueur</th></tr>");
				$.get("index.php?controle=services&action=recupererPartieLibre",function(data){
				for(donnee of data.enregistrements)
					{
						$("#partiesLibres").append("<tr><td>"+donnee.IdPartie+"</td><td>"+donnee.PseudoJoueur1+"<td><button class='btn btn-form affronter'>Affronter</button></td></tr>")
					}
				});
				break;
			}
		}
	$.get("index.php?controle=services&action=recupererPartieLibre",function(data){
		
		for(donnee of data.enregistrements)
		{
			$("#partiesLibres").append("<tr><td>"+donnee.IdPartie+"</td><td>"+donnee.PseudoJoueur1+"</td><td><button class='btn btn-form affronter'>Affronter</button></td></tr>")
		}
	});

	$("#seekPlayer input[name='pseudoJoueur']").keyup(function(){
		tab = [];
		if($(this).val().length < 1)
			$("#seekPlayer input[type='submit']").prop('disabled',true);
		else{
			$("#seekPlayer input[type='submit']").prop('disabled',false);
			$.post("index.php?controle=services&action=getListeJoueurs",{recherche:$(this).val()},function(data){
				for(index in data.enregistrements){
					tab.push({Pseudo:data.enregistrements[index].Pseudo,Connexion:data.enregistrements[index].Connexion});
				}
			});
			
		}
	});

	$("#seekPlayer input[name='pseudoJoueur']").autocomplete({
		source:function(request,response){
			response($.map(tab,function(value,key){
				return{
					label: value.Pseudo,
					value: value.Pseudo,
					boolean: value.Connexion
				}
			}));
		},
		select:function(event,ui){
			$("#seekPlayer input[name='pseudoJoueur']").val(ui.item.label);
		}
	});
		// Events
		$('#seekPlayer').submit(function(e){
				e.preventDefault();
				websocket_server.send(
					JSON.stringify({
						'type':'inviter',
						'username':sessionJoueur,
						'adversaire':$("#seekPlayer input[name='pseudoJoueur']").val()
					})
				);
		});


		$("table").on("click",".affronter",function(){
			chaine = $("#partiesLibres .affronter:eq("+[$(".affronter").index(this)]+")").parent().parent().html().match(/([^\<td>](.+)<\/td>)[^button]/)[0].split('<');
			IdPartie = parseInt(chaine[0]);
			secondJoueur = chaine[2].split(">")[1];
			websocket_server.send(
				JSON.stringify({
					"type":"rejoindre",
					"username":sessionJoueur,
					"adversaire":secondJoueur,
					"IdPartie":IdPartie
				})
			)
			window.location.href="index.php?controle=services&action=afficherJeu&premierJoueur="+sessionJoueur+"&secondJoueur="+secondJoueur+"&IdPartie="+IdPartie;
		})

		$('#deny').click(function(){
			$("#invitation").modal("toggle");
			websocket_server.send(
				JSON.stringify({
					'type':'refuser',
					'username':sessionJoueur,
					'adversaire':adversaire
				}));
			adversaire = null;
		})

		$('#accept').click(function(){
			websocket_server.send(
				JSON.stringify({
					'type':'accepter',
					'username':sessionJoueur,
					'adversaire':adversaire
				}));
			window.location.href = "index.php?controle=services&action=afficherJeu&premierJoueur="+sessionJoueur+"&secondJoueur="+adversaire;
		})



		$("#okbutton").click(function(){
			$("#refus").modal("toggle");
		});

		$("#freeGame").submit(function(e){
			e.preventDefault();
			$.post("index.php?controle=services&action=creerPartieLibre",{},function(data)
			{
				//alert(data);
				if(data != "failure"){
				websocket_server.send(
					JSON.stringify({
						'type':'partieLibre',
						'username':sessionJoueur,

					}));
				$("#freeGame").unbind("submit").submit();
				}
				else
					alert("Partie déjà existante");
			});
			
		});
});