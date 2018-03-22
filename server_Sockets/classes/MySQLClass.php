<?php


class MySQL{

	private $dbObject;
    private $table;
    private $condition;
    private static $MySQLInstance = null;
	
	private function __construct($Link,$dbName,$username,$password)
	{
		try
		{
			$this->dbObject = new PDO("mysql:host=$Link;dbname=$dbName",$username,$password);
		}
		catch(Exception $e)
		{
			die('Erreur :'.$e->getMessage());
		}
	}

	public static function init($Link,$dbName,$username,$password)
	{
		if(is_null(self::$MySQLInstance))
		{
			self::$MySQLInstance = new MySQL($Link,$dbName,$username,$password);
		}
		return self::$MySQLInstance;
	}

	public static function getInstance()
	{
		return self::$MySQLInstance;
	}

	public function fetchAllData($table,$condition=null)
	{

	    $requete = $this->dbObject->prepare("SELECT * from $table $condition");

		$fetchColumns = $this->dbObject->prepare("SELECT * FROM $table LIMIT 0");
		$columns = array();
		$fetchColumns->execute();

		for($i=0;$i<$fetchColumns->columnCount();$i++)
		{
			$col = $fetchColumns->getColumnMeta($i);
			$columns[] = $col['name'];
		}

		// print_r($columns);
		$datas = array();
		$requete->execute();

		if($requete->rowCount() == 0)
			return null;
		header("Access-Control-Allow-Origin: *");
		header("Content-Type: application/json; charset=UTF-8");
		$jsonString = json_encode($requete->fetchAll(PDO::FETCH_ASSOC));
		$jsonString = substr_replace($jsonString, '{"enregistrements":', 0,0);
		return substr_replace($jsonString,"}",strlen($jsonString));
	}

	public function checkIfExists($table,$condition=null)
	{
		return $this->dbObject->query("SELECT COUNT(*) FROM $table $condition")->fetchColumn() > 0;
	}

	public function fetchData($table,$columns,$condition=null)
	{
		$columnsString = "";
		foreach ($columns as $columnName) {
			$columnsString .= $columnName.",";
		}
		
		$requete = $this->dbObject->prepare("SELECT ".preg_replace("/,$/","",$columnsString)." from $table $condition");


		// print_r($columns);

		$requete->execute();
		$datas = array();
		header("Access-Control-Allow-Origin: *");
		header("Content-Type: application/json; charset=UTF-8");
		$jsonString = json_encode($requete->fetchAll(PDO::FETCH_ASSOC));
		$jsonString = substr_replace($jsonString, '{"enregistrements":', 0,0);
		return substr_replace($jsonString,"}",strlen($jsonString));
	}

	public function insertData($table,$columns,$values)
	{
		$columnsString = "";
		$prepareParameters = "";
		foreach ($columns as $columnName) {
			$columnsString .= $columnName.",";
		}

		foreach($columns as $columnName){
			$prepareParameters .= "?,";
		}


		$prepareInsertInto = "INSERT INTO $table (".preg_replace("/,$/", "", $columnsString).") values(".preg_replace("/,$/","",$prepareParameters).")";
		$query = $this->dbObject->prepare($prepareInsertInto);
		for($i=0;$i<count($values); $i++)
			$query->bindParam($i+1,$values[$i]);
		$query->execute();
	}

	public function updateData($table,$changeColumn,$newValue,$condition=null)
    {
    	$string = "UPDATE $table set $changeColumn=? $condition";
        $query = $this->dbObject->prepare($string);
        $query->execute(array($newValue));
        echo $string;
    }

    public function deleteData($table,$condition=null)
    {
    	$query = $this->dbObject->prepare("DELETE FROM $table $condition");
    	$query->execute();
    }

    public function getDBObject()
    {
    	return $this->dbObject;
    }

}