<?php

	class Polling
	{
		private $classInstance;

		public function __construct($classInstance)
		{
			$this->classInstance = $classInstance;
		}


		public function checkUpdates($method)
		{
			$data = $this->classInstance->$method();
			session_write_close();
			while(1)
			{
				session_start();
				session_write_close();

				if($this->hasChanged($data,$method))
				{
					return $data;
					break;
				}
				sleep(2);
			}
		}

		private function hasChanged(&$oldData,$method)
		{
			$currentData = $this->classInstance->$method();
			if($oldData != $currentData)
			{
				$oldData = $currentData;
				return true;
			}
			return false;
		}
	}