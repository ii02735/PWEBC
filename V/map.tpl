<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Carte Leaflet</title>
    <link href="./V/css/style.css" rel="stylesheet">
    <link href="./V/leaflet/leaflet.css" rel="stylesheet">
    <script src="./V/leaflet/leaflet.js"></script>
    <style>
        #map
        {
            height:500px;
            width:70%;
        }
    </style>
</head>
<body>
    <h3>Joueur : <span id="username"><?php echo $_SESSION["joueur"] ?></span></h3>
    <h4>Id Partie : <?php echo $_SESSION["IdPartie"]?></h4>
    <div id="state"></div>
    <div id="map"></div>
    <div id="instructions">
        <ul>
            <li>Choisissez une position sur la carte</li>
            <li>Déduisez la position de votre adversaire !</li>
        </ul>
    </div>
    <script src="./V/js/jquery_min.js"></script>
    <script src="./V/js/jquery-ui.js"></script>
    <script src="./V/js/scriptMap.js"></script>
    <script>

        var marker = null;
        var map = L.map("map").setView([0,0],5);
        L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}',
            {
                minZoom:2,
                maxZoom: 18,
                id:'mapbox.dark',
                accessToken:'pk.eyJ1IjoiaWkwMjczNSIsImEiOiJjamNyZ3V2cTIyY3o2MnZvNG1pZmxua20wIn0.dDefu45uaH2oRz73y0FRlg'
            }).addTo(map);

        function onMapClick(e) {
            var lat=parseFloat(e.latlng.lat).toFixed(8);
            var lon=parseFloat(e.latlng.lng).toFixed(8);
            marker = L.marker([lat,lon]).addTo(map);
            $.ajax({
                url:"index.php?controle=jeuCarte&action=envoyerCoordonnees",
                data:{lon:lon,lat:lat},
                type:"POST",
                success:function(data){console.log(data);}
           });
            console.log(e.latlng);
        }

            map.on('click', onMapClick);
            
            $("#map").click(function(){
                map.off('click', onMapClick);
            })
    </script>


</body>
</html>