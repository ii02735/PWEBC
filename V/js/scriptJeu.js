var tab = [];
var secondJoueur = null;
var sessionJoueur = null;
var sessionPartie = null;
var coordChoisies = false;
var proposition = null;
var marqueur;
var tabCoord = [];
$(function(){

    $.get("index.php?controle=services&action=getSession",function(data){
        sessionJoueur = data.replace(/[\n\r]+/g, '')
    });

    if(getURLParameter("IdPartie")){
        sessionPartie = parseInt(getURLParameter("IdPartie"));
        $.post("index.php?controle=services&action=changerStatutPartieLibre",{IdPartie:sessionPartie,statut:'en cours'},function(data)
        {
            console.log("Statut changé avec succès");
        })
    }
    else if(!getURLParameter("jeu"))
    {
        $.get("index.php?controle=services&action=recupererIdPartie",function(data){//On donne l'id aux joueurs pour une partie ciblée (pas libre)
            //console.log(data);
            if(data.enregistrements.length > 0)
                sessionPartie = parseInt(data.enregistrements[0].IdPartie);
        })
    }
    else{
        $.get("index.php?controle=services&action=recupererIdPartieLibre",function(data){//On donne l'id à celui qui crée la partie
            sessionPartie = parseInt(data.replace(/[\n\r]+/g, ''));
        });
    }
	var marker = L.icon({
    	iconUrl: './V/leaflet/images/pin.svg',
    	iconSize:  [38, 95] // size of the icon
	});

    var ciblage = L.icon({
        iconUrl:'./V/leaflet/images/circular-target_1.svg',
        iconSize: [38,95]
    })

    var map = L.map("map").setView([0,0],5);
    L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}',
        {
            minZoom:2,
            maxZoom: 18,
            id:'mapbox.dark',
            accessToken:'pk.eyJ1IjoiaWkwMjczNSIsImEiOiJjamNyZ3V2cTIyY3o2MnZvNG1pZmxua20wIn0.dDefu45uaH2oRz73y0FRlg'
        }).addTo(map);

    map.on("click",function(e){
    	if(!marqueur){
    		//alert(!marqueur);
	    	marqueur = new L.marker(e.latlng,{icon:marker}).addTo(map);
	    	/*console.log(e.latlng.lat + " " + e.latlng.lng);*/
	    	$.post("index.php?controle=services&action=creerCoords",{sessionPartie:sessionPartie,lat:e.latlng.lat,lng:e.latlng.lng},function(data){
	    		console.log(data);
	    	});
	    	map.addLayer(marqueur);   
            if(!coordChoisies)
            {
                coordChoisies = true;
                websocket_server.send(
                    JSON.stringify({
                        'type':'coordChoisies',
                        'username':sessionJoueur,
                        'IdPartie':sessionPartie,
                        'coordChoisies':coordChoisies
                    })
                )
            }
	    	/*marqueur.bindPopup("Test réussi").openPopup();*/
    	}
        /*else{
    		$("#attendsAdv").modal({
                backdrop: 'static',
                keyboard: false
            });
        }*/
	});

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
            case 'rejoindre':
            if(json.session == sessionJoueur)
            {
                $("#statutPartie").html(sessionJoueur + " VS " + json.adversaire);
            }
            break;
            case 'coordChoisies':
            if(json.IdPartie == sessionPartie && json.adversaire != sessionJoueur)
            {
                if(coordChoisies == false && json.coordChoisies == true)
                {
                    $("#notifCoords .modal-body").text(json.msg);
                    $("#notifCoords").modal({
                        backdrop: 'static',
                        keyboard: false
                    });
                }
                else if(coordChoisies == true && json.coordChoisies == true)
                {
                    proposition = false;
                    $("#notifCoords .modal-body").text("La partie peut maintenant commencer ! Commencez à deviner la position de votre adversaire.");
                    $("#notifCoords .modal-title").text("Début de la partie");
                    $("#notifCoords").modal({
                        backdrop: 'static',
                        keyboard: false
                    });
                    websocket_server.send(
                        JSON.stringify({
                            'type':'debut',
                            'IdPartie':sessionPartie,
                            'username':sessionJoueur
                        })
                    )
                    map.on("click",function(e){
                        if(proposition == false)
                        {
                            var target = new L.marker(e.latlng,{icon:ciblage}).addTo(map);
                            $("#notifCoords .modal-title").text("Tour suivant");
                            $("#notifCoords .modal-body").text("C'est au tour de votre adversaire.");
                            $("#notifCoords").modal({
                                backdrop:'static',
                                keyboard: false
                            });
                            websocket_server.send(
                                JSON.stringify({
                                    'type':'suivant',
                                    'IdPartie':sessionPartie,
                                    'username':sessionJoueur
                                })
                            )
                            proposition = true;
                        }
                    });



                }
            }
            break;
            case 'debut':
            {
                if(json.IdPartie == sessionPartie && json.adversaire != sessionJoueur){
                proposition = false;
                $("#notifCoords .modal-title").text("Début de la partie");
                $("#notifCoords .modal-body").text(json.msg);   
                $("#notifCoords").modal({
                        backdrop: 'static',
                        keyboard: false
                    });
                }
                $("#okWait .modal-body").text("Ce n'est pas encore à vous de jouer...");
             }
             break;
             case 'suivant':
             {
                if(json.IdPartie == sessionPartie && json.adversaire != sessionJoueur)
                {

                    $("#notifCoords .modal-title").text("Tour suivant");
                    $("#notifCoords .modal-body").text(json.msg);
                    $("#notifCoords").modal({
                        backdrop: 'static',
                        keyboard: false
                    });
                    proposition = false;
                }
             }
             break;
        }
    }

     map.on("click",function(e){
        if(proposition == false)
        {
            var target = new L.marker(e.latlng,{icon:ciblage}).addTo(map);
            proposition = true;
            $("#notifCoords .modal-title").text("Tour suivant");
            $("#notifCoords .modal-body").text("C'est au tour de votre adversaire.");
            $("#notifCoords").modal({
                backdrop:'static',
                keyboard: false
            });
            websocket_server.send(
                JSON.stringify({
                    'type':'suivant',
                    'IdPartie':sessionPartie,
                    'username':sessionJoueur
                })
            )
        }
    });
    $("#okWait").click(function()
    {
        $("#attendsAdv").modal("toggle");
    })

    $("#okWait2").click(function()
    {
        $("#notifCoords").modal("toggle");
    })

    $("#gps").click(function(){
        $.post("index.php?controle=services&action=getCoords",{partie:sessionPartie},function(data){
            $.get("https://nominatim.openstreetmap.org/search.php?q="+data.enregistrements[0].Latitude+"+"+data.enregistrements[0].Longitude+"+&polygon_geojson=1&viewbox=&format=json",function(data)
            {
                tab = data;
                tab = tab[0].display_name.split(",")
                $("#notifCoords .modal-body").text("Votre adversaire se trouve dans la localisation suivante : "+tab[tab.length - 1]);
                $("#notifCoords .modal-title").text("Indice : GPS")
                $("#notifCoords").modal({
                        backdrop: 'static',
                        keyboard: false
                });

            })
        }) 
        $(this).attr("disabled",true);
    })
});

function getURLParameter(name) {
  return decodeURIComponent((new RegExp('[?|&]' + name + '=' + '([^&;]+?)(&|#|;|$)').exec(location.search) || [null, ''])[1].replace(/\+/g, '%20')) || null;
}

function haversineDistance(coords1, coords2) {
  function toRad(x) {
    return x * Math.PI / 180;
  }

  var lon1 = coords1[0];
  var lat1 = coords1[1];

  var lon2 = coords2[0];
  var lat2 = coords2[1];

  var R = 6371; // km

  var x1 = lat2 - lat1;
  var dLat = toRad(x1);
  var x2 = lon2 - lon1;
  var dLon = toRad(x2)
  var a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(toRad(lat1)) * Math.cos(toRad(lat2)) *
    Math.sin(dLon / 2) * Math.sin(dLon / 2);
  var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  var d = R * c;

 // if(isMiles) d /= 1.60934;

  return d;

}
