<?php
set_time_limit(0);

use Ratchet\MessageComponentInterface;
use Ratchet\ConnectionInterface;
use Ratchet\Server\IoServer;
use Ratchet\Http\HttpServer;
use Ratchet\WebSocket\WsServer;
require_once('../vendor/autoload.php');
require_once("../classes/MySQLClass.php");

class Socket implements MessageComponentInterface {
	protected $clients;
	protected $users;
	protected $SQLInstance;
	private $idPartie;
	public function __construct() {

		$this->SQLInstance = MySQL::init("localhost","projet_pwebc","root","root");
		$this->clients = new \SplObjectStorage;
		$this->idPartie = 0;
	}

	public function onOpen(ConnectionInterface $conn) {
		$this->clients->attach($conn);
		// $this->users[$conn->resourceId] = $conn;
	}

	public function onClose(ConnectionInterface $conn) {
		$this->clients->detach($conn);
		// unset($this->users[$conn->resourceId]);
	}

	public function onMessage(ConnectionInterface $from,  $data) {
		$from_id = $from->resourceId;
		$data = json_decode($data);
		$type = $data->type;
			switch ($type) {
		
				case 'connexion':
					$user_id = $data->username;//On récupère la variable session de l'émetteur
					$response_to = $user_id." s'est connecté"; //on inscrit son message
					foreach ($this->clients as $client) {
						if($from!=$client)//On vérifie que l'envoyeur n'est pas le destinataire
						{
							$client->send(json_encode(array("type"=>$type,"info"=>$response_to)));
						}
					}
				break;
				case 'inviter':
					$user_id = $data->username;
					$response_to = "Demande en provenance de ".$user_id;
					$destinataire = $data->adversaire;
					foreach ($this->clients as $client) {
						if($from!=$client)//On vérifie que l'envoyeur n'est pas le destinataire
						{
							$client->send(json_encode(array("type"=>$type,"info"=>$response_to,"adversaire"=>$destinataire,"emetteur"=>$data->username)));
						}
					}
				break;
				case 'refuser':
					$user_id = $data->username;
					$response_to = "Rejet de la demande";
					$msg = "<strong>".$user_id."</strong> a rejeté votre demande ! :(";
					$destinataire = $data->adversaire;
					foreach ($this->clients as $client) {
						if($from!=$client)//On vérifie que l'envoyeur n'est pas le destinataire
						{
							$client->send(json_encode(array("type"=>$type,"info"=>$response_to,"adversaire"=>$destinataire,"emetteur"=>$data->username,"msg"=>$msg)));
						}
					}
				break;
				case 'accepter':
					$user_id = $data->username;
					$destinataire = $data->adversaire;
					$url="index.php?controle=services&action=afficherJeu&premierJoueur=".$destinataire."&secondJoueur=".$user_id;
			
					$this->SQLInstance->insertData("Partie",array("PseudoJoueur1","PseudoJoueur2","Etat"),array("$user_id","$destinataire","en cours"));
			
					foreach ($this->clients as $client) {
						if($from!=$client)//On vérifie que l'envoyeur n'est pas le destinataire
						{
							$client->send(json_encode(array("type"=>$type,"adversaire"=>$destinataire,"redirection"=>$url)));
						}
					}
				break;
				case 'partieLibre':
					$user_id = $data->username;
					$donnees = $this->SQLInstance->fetchData("Partie",array("PseudoJoueur1"),"WHERE Etat='inactif'");
					$donnees = json_decode($donnees);
						foreach ($this->clients as $client){
							if($from!=$client)
								$client->send(json_encode(array("type"=>$type,"donnees"=>$donnees)));
						}
				break;
				case 'rejoindre':
					$idPartie = $data->IdPartie;
					$user_id = $data->username;
					$destinataire = $data->adversaire;
					$this->SQLInstance->updateData("Partie","PseudoJoueur2",$user_id,"WHERE idPartie=$idPartie");
					foreach($this->clients as $client){
						if($from!=$client){
							$client->send(json_encode(array("type"=>$type,"adversaire"=>$user_id,"session"=>$destinataire)));
						}
					}
				break;
				case 'coordChoisies':
					$IdPartie = $data->IdPartie;
					$user_id = $data->username;
					$coordChoisies = $data->coordChoisies;
					$msg = $user_id." a choisi ses coordonnées. Il ne reste plus que vous !";
					foreach($this->clients as $client){
						if($from!=$client){
							$client->send(json_encode(array("type"=>$type,"adversaire"=>$user_id,"IdPartie"=>$IdPartie,"msg"=>$msg,"coordChoisies"=>$coordChoisies)));
						}
					}
					break;
				case 'debut':
					$IdPartie = $data->IdPartie;
					$user_id = $data->username;
					$msg = $user_id." commence la partie.";
					foreach($this->clients as $client){
						if($from!=$client){
							$client->send(json_encode(array("type"=>$type,"adversaire"=>$user_id,"IdPartie"=>$IdPartie,"msg"=>$msg)));
						}
					}
					break;
				case 'suivant':
					$IdPartie=$data->IdPartie;
					$user_id = $data->username;
					$msg = "C'est à votre tour";
					foreach ($this->clients as $client) {
						
						$client->send(json_encode(array("type"=>$type,"adversaire"=>$user_id,"IdPartie"=>$IdPartie,"msg"=>$msg)));
					}
				break;		
		}
	}

	public function onError(ConnectionInterface $conn, \Exception $e) {
		$conn->close();
	}
}
$server = IoServer::factory(
	new HttpServer(new WsServer(new Socket())),
	8081
);
$server->run();
?>
