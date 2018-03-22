var wrongPass = true;
var wrongPseudo = true;
var wrongMail = true;
var typingTimer;
var doneTypingInterval = 1200;
var emailRegex = /(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])/;
var pseudoConnEmpty = true;
$(function()
{
	//WebSockets
		var websocket_server = new WebSocket("ws://localhost:8081/");
			websocket_server.onopen = function(e) {
				websocket_server.send(
					JSON.stringify({
						'type':'socket',
						'user_id':"<?php echo $_SESSION['Joueur'];?>"
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
					case 'chat':
						$('#chat_output').append(json.msg);//$response_to
						break;
					case 'connexion':
						alert(json.info);
						break;
				}
			}
			// Events
			// $('#chat_input').on('keyup',function(e){
			// 	if(e.keyCode==13 && !e.shiftKey)
			// 	{
			// 		var chat_msg = $(this).val();
			// 		//Envoi d'un message
			// 		websocket_server.send(
			// 			JSON.stringify({
			// 				'type':'chat',
			// 				'user_id':"<?php echo $_SESSION['Joueur'];?>",
			// 				'chat_msg':chat_msg
			// 			})
			// 		);
			// 		$(this).val('');
			// 	}
			// });

	$("#btnInscr").attr("disabled",true);
	$("#btnConn").attr("disabled",true);

	$("#pseudoConn").keydown(function(event){
		if(event.keyCode == 32)
			event.preventDefault();
		else
		{
			setTimeout(function(){
				if($("#pseudoConn").val().length > 0)
				    $("#btnConn").attr("disabled",$("#MdpConn").val().length == 0);
				else
					$("#btnConn").attr("disabled",true);
			},1000);
		}
	});

	$("#MdpConn").keydown(function(event){
		if(event.keyCode == 32)
			event.preventDefault();
		else{
			setTimeout(function(){
				if($("#MdpConn").val().length > 0)
				    $("#btnConn").attr("disabled",$("#pseudoConn").val().length == 0);
				else
					$("#btnConn").attr("disabled",true);
			},1000);
		}
	});
	//Attendre quelques secondes avant l'exécution de l'AJAX
	$("#pseudoInscr").keydown(function(event){
		if(event.keyCode == 32)
			event.preventDefault();
		else{
			$("#erreurPseudo").html("<span style='color:gold'>Patientez...</span>");
			clearTimeout(doneTypingInterval);
			if($(this).val()){
				typingTimer = setTimeout(checkPseudo,doneTypingInterval);
			}
		}
	});

	$("#connecter").submit(function(event){
		event.preventDefault();
		$.post("index.php?controle=register&action=verification",{pseudoConnexion:$("#pseudoConn").val(),mdpConnexion:$("#MdpConn").val()},function(data)
		{
			if(data.enregistrements){
				$("#connecter").unbind("submit").submit();
				//Envoi d'un message
				websocket_server.send(
					JSON.stringify({
						'type':'connexion',
						'username':$("#pseudoConn").val()
					})
				);


			}
			else{
				$("#erreur").text("Identifiant / mot de passe erroné");
			}
		});
	});
	
	$("#passwordInscr").keydown(function(event){
		if(event.keyCode == 32)
			event.preventDefault();
		else
			setTimeout(strengthTester,1000);
	});

	$("#email").keydown(function(event){
		if(event.keyCode == 32)
			event.preventDefault();
		else{
			if(verifExprReg($(this).val(),emailRegex)){
				$("#erreurMail").html("<span style='color:gold'>Patientez...</span>")
				clearTimeout(doneTypingInterval);
				if($(this).val()){
					typingTimer = setTimeout(checkEmail,doneTypingInterval);
				}
			}
			else{
				$("#erreurMail").html("<span style='color:crimson'>L'email ne respecte pas le format imposé : example@example.exp...</span>")
				wrongMail = true;
				$("#btnInscr").attr("disabled",true);

			}
		}
	});

})


function strengthTester()
{
	if($("#passwordInscr").val().length < 4)
	{
		$("#strengthBar span").css("width","0%").css("background-color","crimson");
		wrongPass = true;
		$("#btnInscr").attr("disabled",true);
	}
	else if($("#passwordInscr").val().length < 8)
	{
		$("#strengthBar span").css("width","25%").css("background-color","crimson");
		wrongPass = true;
		$("#btnInscr").attr("disabled",true);
	}
	else if($("#passwordInscr").val().length < 15)
	{
		$("#strengthBar span").css("width","50%").css("background-color","orange");
		wrongPass = false;
		$("#btnInscr").attr("disabled",checkFields());	
	}
	else if($("#passwordInscr").val().length < 20)
	{
		$("#strengthBar span").css("width","75%").css("background-color","green");
		wrongPass = false;
		$("#btnInscr").attr("disabled",checkFields());
	}
	else if($("#strengthBar span").val().length<30)
	{
		$("#strengthBar span").css("width","100%").css("background-color","lime");
		wrongPass = false;
		$("#btnInscr").attr("disabled",checkFields());
	}
	
}

function checkPseudo()
{
	$.post("index.php?controle=register&action=checkPseudo",{pseudo:$("#pseudoInscr").val()},function(data){
		if(data.enregistrements){
			$("#erreurPseudo").html("<span style='color:crimson'>Le pseudo existe déjà</span>");
			wrongPseudo = true;
			$("#btnInscr").attr("disabled",true);
		}
		else{
			console.log("good");
			$("#erreurPseudo").empty();
			wrongPseudo = false;
			$("#btnInscr").attr("disabled",checkFields());
		}
	});	
		
}

function checkEmail()
{
	$.post("index.php?controle=register&action=checkEmail",{email:$("#email").val()},function(data){
			console.log(data);
			if(data.enregistrements){
				$("#erreurMail").html("<span style='color:crimson'>L'email existe déjà</span>");
				wrongMail = true;
				$("#btnInscr").attr("disabled",true);
			}
			else{
				
				$("#erreurMail").empty();
				wrongMail = false;
				$("#btnInscr").attr("disabled",checkFields());
			}
	});	
}


function verifExprReg(string,expr)
{
	if(!(expr.test(string)))
		return false;
	else
		return true;
}

function checkFields()
{
	if(wrongPseudo==false)
		if(wrongPass==false)
			if(wrongMail==false)
				return false;
	return true;
}