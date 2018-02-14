<?php
	include("../../include/config.php");
	include("../../include/arrays.php");
	include("../../include/function.php");

/* ~~~~~~~~~~ FUNCTIONS ~~~~~~~~~~ */
	/**
	 * Affiche une liste de sources au format JSON (pour les autocomplete)
	 */
	function get_Sources_list() {
        global $database_vanillabp;
        $source=array();

        $result=sqlrequest($database_vanillabp,"SELECT db_names FROM bp_sources");

        while ($line = mysql_fetch_array($result)){
			$sources[]=$line[0];
        }
        echo json_encode($sources);
	}	
	
	/**
	 * Créé un array qui contient les informations sur les hosts d'une bp_source.
	 *
	 * @param $source_name (String) -> Nom de la bp_source concernée.
	 *
	 * @return (Array) -> tableau d'infos.
	 */
	function mysql_evaluate_array($source_name) {

		$thruk_idx = getThrukId($source_name);
		$result = sqlrequest("thruk", "SELECT host_name, 'bobby' as bobby FROM ".$thruk_idx."_host");

		$values = array();
		for ($i=0; $i<mysql_num_rows($result); ++$i)
			$values[] = mysql_fetch_assoc($result);
		return $values;
	}

	/**
	 * Créé un array qui contient les informations sur les bp_sources.
	 *
	 * @return (Array) -> tableau d'infos.
	 */
	function mysql_evaluate_array_source() {
		global $database_vanillabp;
		$values = array();
		$result = sqlrequest($database_vanillabp,"SELECT db_names, nick_name FROM bp_sources");
		for ($i=0; $i<mysql_num_rows($result); ++$i)
			$values[] = mysql_fetch_assoc($result);
		return $values;
	}

	/**
	 * Récupère le nick_name d'une source.
	 *
	 * @param $db_name (String) -> Nom de la source.
	 *
	 * @return (String) -> Le nick_name de la source.
	 */
	function getNickName($db_name)
	{
		global $database_vanillabp;

		$result = sqlrequest($database_vanillabp, "SELECT nick_name FROM bp_sources WHERE db_names='$db_name'");
		while ($line = mysql_fetch_array($result)){
			$nick_name=$line[0];
        }

		return $nick_name;
	}
	
	/**
	 * Récupère le thruk_idx d'une source.
	 *
	 * @param $source_name (String) -> Nom de la source choisie.
	 *
	 * @return (String) -> Le thruk_idx associé à la source.
	 */
	function getThrukId($source_name)
	{
		global $database_vanillabp;

		$result = sqlrequest($database_vanillabp, "SELECT thruk_idx FROM bp_sources WHERE db_names='$source_name'");
		while ($line = mysql_fetch_array($result)){
			$thruk_idx=$line[0];
        }

		return $thruk_idx;
	}
/* ~~~~~~~~~~ ! FUNCTIONS ~~~~~~~~~~ */
	
	// définit la source qui a été choisie dans le <select id="selectsource">
	if( !empty($_POST["definedSource"]) )
	{
		$defined_source = $_POST["choosenSource"];
	}

switch($_POST['option']){
	case "select" :
		// on obtient le thruk_idx de la source concernée
		$thruk_idx = getThrukId($defined_source);
	
		// on chope l'ID du host concerné
		$id = 0;
		$host_id = sqlrequest("thruk", "SELECT host_id FROM ".$thruk_idx."_host WHERE host_name='".$_POST["valeur"]."'");
		while ($line = mysql_fetch_array($host_id)){
			$id = $line[0];
        }
		
		// on utilise cet ID pour selectionner les bon services
		$result = sqlrequest("thruk", "SELECT * FROM ".$thruk_idx."_service WHERE host_id=".$id." order by service_description" );
		$nbr_row =  mysql_num_rows($result);
		
		// s'il y a des services liés a cet host, on remplis le <select id="change">
		if($nbr_row > 0)
		{
			 echo "<option value='Hoststatus'>Hoststatus</option>;";
			while ($line = mysql_fetch_array($result)){
				$service=$line[2];
				echo "<option value='$service'>$service</option>";
			}
		}
		else // sinon on le laisse vide et on le passe a l'état disabled
		{
			//echo '<script>$("#change").attr("disabled", true);</script>';
			echo "<option value='Hoststatus'>Hoststatus</option>;";
		}
		break ;
	case "selectsource" :
		// on obtient le thruk_idx de la source concernée
		$id = getThrukId( $_POST["choosenSource"] );
		
		// on établie la liste des hosts dans la table qui porte le bon thruk_idx
		$host_list = sqlrequest("thruk", "SELECT host_name FROM ".$id."_host");
		$nbr_host = mysql_num_rows($host_list);
		
		// s'il y a des résultats, on remplis le <select id="select">
		if($nbr_host > 0)
		{
			while ($line = mysql_fetch_array($host_list)){
				$host=$line[0];
				echo "<option value='$host'>$host</option>";
			}
		}
		break;
	case "changesource" :
		if ($_POST['valeur'] == "true"){
			// on disable les champs qui doivent l'être
			echo '<script type="text/javascript">'.
						'$("input[name=equip]").attr("disabled", false);'.
						'$("#change").attr("disabled", false);'.
						'$("#check").attr("disabled", false);'.
					'</script>';
					
			// on va utiliser la source pour différencier le GLOBAL des autres.
			if( !empty($_POST["definedSource"]) )
			{
				if( $_POST["definedSource"] == "global_nagiosbp" )
				{
					echo "<select size='1' name='source[]' id='selectsource' style='width:360px;' onChange='javascript:selectValueSource(\"selectsource\",this.value);'>";
							$results=mysql_evaluate_array_source() ;
							foreach ($results as $result){
								echo "<option value='$result[db_names]'>".$result["nick_name"]."</option>";
							}
					echo "</select>";
				}
				else // dans les autres cas, on ne remplis qu'avec la source concernée
				{
					echo "<select size='1' name='source[]' id='selectsource' style='width:360px;' onChange='javascript:selectValueSource(\"selectsource\",this.value);'>";
							$results=mysql_evaluate_array_source() ;
							foreach ($results as $result){
								if( $_POST["definedSource"] == $result["db_names"] ){
									echo "<option value='$result[db_names]'>$result[nick_name]</option>";	
								}
							}
					echo "</select>";	
				}
			}
		}
		else { // quand on décoche la premiere checkbox, on obtien un champs text
			echo '<script type="text/javascript">'.
						'$("input[name=equip]").attr("disabled", true);'.
						'$("#change").attr("disabled", true);'.
						'$("#check").attr("disabled", true);'.
					'</script>';
 			echo "<input type='text' name='source' style='width:360px;' placeholder='Rechercher ...' onFocus='$(\"input[name]=source\").autocomplete(";
			echo   get_Sources_list();	//Dotted notation doesn't concatenate the json return values.
			echo ")' autocomplete='off' onBlur='javascript:selectValueSource(\"selectsource\",this.value)';/>";
		}
		break;
	case "change" :
		// ici on remplis le <select id="select"> avec tous les host qui appartiennent à la source concernée
		if ($_POST['valeur'] == "true"){
			echo "<select size='1' name='equip[]' id='select' style='width:360px;' onChange='javascript:selectValue(\"select\",this.value);'>";
					$results=mysql_evaluate_array($_POST["choosenSource"]);
					foreach ($results as $result){
						echo "<option value='$result[host_name]'>$result[host_name]</option>";
					}
			echo "</select>";
		}
		else { // si on décoche la checkbox, on obtient un champs text
			echo "<script type=\"text/javascript\">$(\"#change\").attr(\"disabled\", true);</script>";
			echo "<input type='text' name='equip' style='width:360px;' placeholder='Rechercher ...' onFocus='$(\"input[name]=equip\").autocomplete(";
			echo	get_host_list();	//Dotted notation doesn't concatenate the json return values.
			echo ")' autocomplete='off' onBlur='javascript:selectValue(\"select\",this.value);'/>";
		}
		break;
	case "delete" :
		switch($_POST['val']){
			case "serv":
				$vals = explode(";",$_POST['name']);
				$host_parts = explode("::", $vals[0]);
				$result = sqlrequest($_POST["source"],"DELETE FROM bp_services WHERE `bp_name`='$_POST[bp]' AND `host`='$host_parts[1]' AND `service`='$vals[1]' ");
				break;
			case "proc":
				$proc_parts = explode("::", $_POST["name"]);
				$proc = $proc_parts[1];
				$result = sqlrequest($_POST["source"],"DELETE FROM bp_links WHERE `bp_name`='$_POST[bp]' AND `bp_link`='".$proc."'");
				break;
		}
		if ( $result ) {
			$type = mysql_fetch_assoc(sqlrequest($_POST["source"],"SELECT type,min_value FROM bp WHERE name='$_POST[bp]'"));
			if ( $type['type'] == "MIN") {
				$return = sqlArrayVanillaBP("SELECT COUNT(bp_name) as nbr FROM bp_services WHERE bp_name='$_POST[bp]' UNION select COUNT(bp_name) FROM bp_links WHERE bp_name='$_POST[bp]'");
				if ( ($return[0]['nbr']+$return[1]['nbr']) < $type['min_value']) $result = sqlrequest($_POST["source"],"UPDATE bp SET `is_define`='0' WHERE `name`='$_POST[bp]'");
			}
			else {
				$return = sqlrequest($_POST["source"],"SELECT bp_name as name FROM bp_services WHERE bp_name='$_POST[bp]' UNION select bp_name FROM bp_links WHERE bp_name='$_POST[bp]'");
				if ( !mysql_num_rows($return)) $result = sqlrequest($_POST["source"],"UPDATE bp SET `is_define`='0' WHERE `name`='$_POST[bp]'");
			}
		}
		else message(0,": Could not update Database","critical");
		if ( !$result )  message(0,": Could not update Database","critical");
		else message(6," : Value deleted","ok");
		break ;
	case "update" :
		switch( $_POST['val']){
			case "serv":
				$vals = explode(";",$_POST['name']);
				echo $_POST["source"]." - INSERT INTO bp_services VALUES('','$_POST[bp]','$vals[0]','$vals[1]')";
				$result = sqlrequest($_POST["source"],"INSERT INTO bp_services VALUES('','$_POST[bp]','$vals[0]','$vals[1]')");
				break;
			case "proc":
				if ( $_POST["source"] == "global_nagiosbp" ) {
					$chosen_source = str_replace("_nagiosbp","",$_POST["choosenSource"]);
					$result = sqlrequest($_POST["source"],"INSERT INTO bp_links (bp_name, bp_link, bp_source) VALUES('$_POST[bp]','$_POST[name]', '$chosen_source')");
				}
				else {
					$result = sqlrequest($_POST["source"],"INSERT INTO bp_links (bp_name, bp_link) VALUES('$_POST[bp]','$_POST[name]')");
				}
				break;
		}
		if ( $result ) {
			$type = mysql_fetch_assoc(sqlrequest($_POST["source"],"SELECT type,min_value FROM bp WHERE name='$_POST[bp]'"));
			if ( $type['type'] == "MIN") {
				$return = sqlArrayDatabase($_POST["source"], "SELECT COUNT(bp_name) as nbr FROM bp_services WHERE bp_name='$_POST[bp]' UNION select COUNT(bp_name) FROM bp_links WHERE bp_name='$_POST[bp]'");
				if ( ($return[0]['nbr']+$return[1]['nbr']) >= $type['min_value']) $result = sqlrequest($_POST["source"],"UPDATE bp SET `is_define`='1' WHERE `name`='$_POST[bp]'");
				else { $result = sqlrequest($_POST["source"],"UPDATE bp SET `is_define`='0' WHERE `name`='$_POST[bp]'"); }
			}
			else $result = sqlrequest($_POST["source"],"UPDATE bp SET `is_define`='1' WHERE `name`='$_POST[bp]'");
		}
		else message(0,": Could not update Ze Database","critical");
		if ( !$result ) message(0,": Could not update Database".$_POST["source"]." ","critical");
		else message(6," : Value added","ok");
		break ;
	case "survey" :
		echo file_get_contents($path_nagiosbpcfg_bu.$_POST['valeur']);
		break;
	case "getBP" :
		// on obtient le thruk_idx de la source concernée
		$id = getThrukId($defined_source);
		
		// on construit la requete SQL en fonction du display choisit
		if( $_POST["display"] != "all" ){
			$sql = "SELECT * from bp WHERE priority='".$_POST["display"]."' AND is_define=1";
		}
		else{
			$sql = "SELECT * from bp WHERE is_define=1";
		}
		$results = sqlrequest($defined_source, $sql);
		
		// et on remplis le <select id="proc"> avec les bp obtenus
		while ($line = mysql_fetch_array($results)){
			$process=$line[0];
			echo "<option value='$process'>$process</option>";
		}
}
?>
