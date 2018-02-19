<?php
/*
#########################################
#
# Copyright (C) 2018 EyesOfNetwork Team
# DEV NAME : Michael Aubertin
# VERSION 4.2
# APPLICATION : eorweb for eyesofreport project
#
# LICENCE :
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
#########################################
*/
?>

<?php
  include("../../include/include_module.php");  
  global $database_vanillabp;
  global $database_host;
  global $database_username;
  global $database_password;
   
  $db = new mysqli($database_host, $database_username, $database_password, $database_vanillabp);

  if($db->connect_errno > 0){
    die('Unable to connect to database [' . $db->connect_error . ']');
  }  
?>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta http-equiv="refresh" content="10800">
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="Michael Aubertin">
    <link rel="icon" href="../../favicon.ico">

    <title>Category  Administration</title>

    <!-- Core CSS -->
    <link href="../../bower_components/bootstrap/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="./css/message.css" rel="stylesheet">
    <link href="./css/jquerysctipttop.css" rel="stylesheet" type="text/css">
    <link href="./css/mysortable.css" rel="stylesheet" type="text/css">
  </head>

  <body onload="InitLoad()">
    <div class="container">    
          <h2 class="form-signin-heading">Category Core Infrastructure</h2>
          <h5 style="color:#FFA500"> <p class="glyphicon glyphicon-info-sign" style='font-size: 1.2em'> </p> Only business processes used by at least one global business process can be set as category.</h5>
          <button class="btn btn-md btn-primary btn-block disabled" id="StoreButton">Apply this configuration</button>
          &nbsp;
          <div class="well well-sm">
             <div style="overflow-y: scroll; overflow-x: hidden; height: 800px;"> 
              <div class="row">
                  <div class="col-xs-6">
                  <div style="overflow-y: scroll; overflow-x: hidden; height: 800px;">
                      <?php
                            $sql = "
                                SELECT db_names 
                                FROM bp_sources;
                            ";
      
                            if(!$result = $db->query($sql)){
                                die('There was an error running the query [' . $db->error . ']');
                            }
                            while($row = $result->fetch_assoc()){ 
                              $bp_source_uniq=substr($row['db_names'], 0, -9); // remove _nagiosbp to the name
                              echo "
                                      <h4>Business Process available from source:".$bp_source_uniq."</h4> 
                                          <div class=\"well well-sm\" id=\"".$bp_source_uniq."\">
                                              <div style=\"overflow-y: scroll; overflow-x: hidden; height: 200px;\">                          
                                                  <ul class=\"source connected\" id=\"ul_".$bp_source_uniq."\">";
                                                                                                                                                                                                                   $sql_bp = "
                                                              SELECT DISTINCT bp_link 
                                                              FROM bp_links  
                                                              WHERE bp_source = '".$bp_source_uniq."' 
							      AND (bp_link like '%_ci' OR bp_link like '%_CI' )
                                                              AND bp_link NOT IN 
                                                                (SELECT bp_name 
                                                                  FROM bp_category 
                                                                  WHERE category = 'Core Infrastructure' 
                                                                  AND bp_source =  '".$bp_source_uniq."' )  
                                                              ORDER BY bp_link
                                                          ";
                                                          
                                                     if(!$result_bp = $db->query($sql_bp)){
                                                          die('There was an error running the query [' . $db->error . ']');
                                                      }
                                                      while($row_bp = $result_bp->fetch_assoc()){ 
                                                        echo "<li>";  
                                                        echo $bp_source_uniq."-->".$row_bp['bp_link'];
                                                        echo "</li>";
                                                      } 
                                                       
                                                      $result_bp->free();

                               echo "            </ul>
                                              </div>
                                          </div>                              
                              ";
                            } 
      
                          $result->free();
                        ?>
      
                  </div>
                  </div>
                  <div class="col-xs-6">
                    <h4>Business process set to Category Core Infrastructure</h4>
                    <ul class="target connected">
                        &nbsp;
                        <?php
                            $sql = "
                                SELECT *
                                FROM bp_category WHERE category = 'Core Infrastructure' ORDER BY bp_source
                            ";
      
                            if(!$result = $db->query($sql)){
                                die('There was an error running the query [' . $db->error . ']');
                            }
                            while($row = $result->fetch_assoc()){ 
                            
                              echo "<li>\n".$row['bp_source']."-->".$row['bp_name']."</li>";
                            } 
      
                          $result->free();
                        ?>
                    </ul>
                    <h4>Drop zone</h4>
                      <ul class="source connected">
                           &nbsp;
                      </ul>
                  </div>
               </div> 
           </div>
  </div> <!-- /container -->
</body>

<!-- Bootstrap core JavaScript
================================================== -->
<!-- Placed at the end of the document so the pages load faster -->
<script src="../../bower_components/jquery/dist/jquery.min.js"></script>
<script src="../../bower_components/bootstrap/dist/js/bootstrap.min.js"></script>
<script src="../../bower_components/jqueryui/jquery-ui.min.js"></script>

<script type="text/javascript">
  $(function () {
    $(".source, .target").sortable({
      connectWith: ".connected"
    });
    $(".source, .target").bind('sortstop', function(e, ui) {
      $('.btn-primary').removeClass('disabled')
    });
  });
</script>
  
<script type="text/javascript">  
  $('#StoreButton').on('click', function (StoreMessage) {

      var cat = "Core Infrastructure";
 
      var datamessage = "";
      $("ul.target").children().each(function() {
          datamessage = datamessage + $(this).text();
          datamessage = datamessage + "|";
      });

      // jQuery ajax post data to php script http://api.jquery.com/jQuery.ajax/
      $.ajax({
        url: "setCategorie.php",
        type : 'POST',
        dataType:'json',
        data: {
            "cat" : cat,
            "message" : datamessage
           },
    })
    .done (function(data) { 
      //alert("Return: " + data.status); 
      if(data.status == 'success'){
          $('.btn-primary').addClass('disabled');
          location.reload();
      }else if(data.status == 'error'){
          alert("Error on query!");
      }
    })
    .fail   (function()     { alert("Impossible to reach or execution failed of setCategorie.php")   ; });
  });
</script>
</html>

<?php
  
  $db->close();
?>
