<?php 
include("../../header.php");
include("../../side.php");
?>



<div id="page-wrapper">
	<div class="row">
		<div class="col-md-12">
			<h1 class="page-header"><?php echo getLabel("label.manage_contracts.step_group_title"); ?></h1>
		</div>
	</div>
	<div class="col-md-12" id="global_form"></div>
	<form class="form-horizontal col-md-7" >
		<div class="form-group has-feedback">
			<label style="font-weight:normal;" for="name" class="col-md-3 control-label"><?php echo getLabel("label.contracts_menu.seuils_create_name"); ?> : </label>
			<div class="col-md-8">
				<input type="text" class="form-control" id="name" onkeyup="this.value=this.value.replace(/[^éèàêâç0-9a-zA-Z-_ \/\*]/g,'')">
			</div>
		</div>	
		<div class="form-group has-feedback">
			<label style="font-weight:normal;" for="name_kpi" class="col-md-3 control-label"><?php echo getLabel("label.contracts_menu.seuils_create_indicator"); ?> : </label>
			<div class="col-md-8">
				<button class="btn btn-default btn-block dropdown-toggle" type="button" data-toggle="dropdown" id="name_kpi"><?php echo getLabel("label.contracts_menu.context_contract_create_indicator_value_default"); ?>
				<span class="caret"></span></button>
				<ul class="dropdown-menu btn-block" id="ul_kpi"></ul>
			</div>
		</div>
		<div class="form-group has-feedback" id="display_unit_checkbox" style="display:none">
			<label style="font-weight:normal;" class="col-md-3 control-label"><?php echo getLabel("label.contracts_menu.seuils_create_type"); ?> : </label>
			<label style="font-weight:normal;" class="col-md-4 radio-inline" id="label_unit_kpi" for="unit_kpi"><input type="radio" name="optradio" id="unit_kpi" onchange="CheckRadioButton(id)"></label>
			<label style="font-weight:normal;" class="col-md-4 radio-inline" id="label_unit_ratio" for="unit_ratio"><input type="radio" name="optradio" id="unit_ratio" onchange="CheckRadioButton(id)">Ratio (%) </label>
		</div>
		<div class="form-group has-feedback" style="display:none" id="display_interval">
			<label style="font-weight:normal;" class="col-md-3 control-label"><?php echo getLabel("label.contracts_menu.seuils_create_minimum"); ?></label>
			<div class="col-md-3">
				<input type="text" class="form-control" id="interval_min" onkeyup="this.value=this.value.replace(/[^0-9.]/g,'')">
			</div>

			<label style="font-weight:normal;" class="col-md-3 control-label"><?php echo getLabel("label.contracts_menu.seuils_create_maximum"); ?></label>
			<div class="col-md-3">
				<input type="text" class="form-control" id="interval_max" onkeyup="this.value=this.value.replace(/[^0-9.]/g,'')">
			</div>
		</div>
			<button class="btn btn-primary" type="submit" id="submit_interval" style="display: none;"><?php echo getLabel("label.contracts_menu.seuils_create_btn_add"); ?>
			</button>
		
		<input type="text" class="form-control" id="id_kpi" style="display:none">
		
		<div class="form-group" style="display:none" id="text_entry">
			<h2 class="page-header"><?php echo getLabel("label.contracts_menu.seuils_create_title_list"); ?></h2>
		</div>

		<div class="col-md-12">
		<table class="table" style="display:none" id="container_interval">
		    <thead>
			    <tr>
			        <th><?php echo getLabel("label.contracts_menu.seuils_create_list_sla"); ?></th>
					<th><?php echo getLabel("label.contracts_menu.seuils_create_minimum"); ?></th>
					<th><?php echo getLabel("label.contracts_menu.seuils_create_maximum"); ?></th>
					<th><?php echo getLabel("label.suppress"); ?></th>
			    </tr>
		    </thead>
			<tbody id="body_table">
			</tbody>
		</table>
		</div>

		<div class="col-md-12">
			<button class="form-group btn btn-primary" type="submit" id="submit"><?php echo getLabel("action.submit"); ?>
			</button>
		</div>
	</form>
</div>

<script src="../../bower_components/jquery/dist/jquery.min.js"></script>
<script src="./js/library.js"></script>

<script>
$(document).ready(function() {
	$counter = 0;
	$global_array = {};
	$radio_value = "";
	$short_name = "";

	if (UrlParam('id_number') != false){
		$('#display_unit_checkbox').css("display", "inline");
		$('#display_interval').css("display", "inline");
    $('#submit_interval').css("display", "block");
		$('#text_entry').css("display", "inline");
		$('#container_interval').css("display", "inline");

		$.get(
			'./php/view_entry.php',
			{
				table_name: 'step_group',
				id_number: UrlParam('id_number')
			},
			function return_values(values){
				$('#name').val(values['NAME']);
				$('#id_kpi').val(values['ID_KPI']);
				$radio_value = values['TYPE'];
				$step_number = values['STEP_NUMBER'];

				for (var i = 0; i < $step_number; i++){
					$counter = $counter +1;
					$step_min = values['STEP_' +$counter+ '_MIN'];
					$step_max = values['STEP_' +$counter+ '_MAX'];

					// On camoufle le bouton de suppression de l'interval du dessus
                        		$previous_id_button = $counter -1 +'id';
                        		$current_id_button = $counter +'id';

                        		$('#' + $previous_id_button).css('display','none');

					$('#container_interval').append('<tr id="'+$counter+'"><td style="text-align:center">n°' + $counter + '</td><td style="text-align:center">' + $step_min + $radio_value + '</td><td style="text-align:center">' + $step_max + $radio_value + '</td><td style="text-align:center"><button type="button" class="btn btn-danger" id="'+$current_id_button+'" onclick=RemoveInterval(id)><span class="glyphicon glyphicon-remove"></span></button></td></tr>');

					var arr = [$step_min, $step_max];
					$global_array[$counter] = arr;
				}

				$('#interval_min').val($step_max);
                                                                        
				$.get(
					'./php/select_name_by_id.php',
					{
						table_name: 'kpi',
						id_number: values['ID_KPI']
					},
					function return_name(name){
						$id_number_kpi = name['NAME'] + "_" + values['ID_KPI'];
						ChangeValueSelected($id_number_kpi);
					},
					'json'
				);
			},
			'json'
		);
	}

	$.get(
		'./php/get_name_id.php',
		{
			table_name:'kpi',
			id: 'ID_KPI'
		},
		function ReturnName(values){
			if(values.length == 0){
				DisplayAlertMissing("Vous devez créer un Indicateur avant de pouvoir créer un groupe de seuils");
			}

			else{
				$('#global_form').css("display", "inline");
				$.each(values, function(v, k){
					$name = k['NAME'];
					$id = k['ID_KPI'];
					$('#ul_kpi').append('<li><a class="dropdown-item" id="'+$name+'_'+$id+'" href="javascript:void(0);" onclick="ChangeValueSelected(id);">' + $name + '</a></li>');
				});
			}
		},
		'json'
	);

	$('#submit').click(function(event){
		event.preventDefault();
		if (UrlParam('id_number') != false){
			$.get(
				'./php/update_entry.php',
				{
					table_name: 'step_group',
					name: $("#name").val(),
					id_kpi: $("#id_kpi").val(),
					id_number: UrlParam('id_number'),
					type: $radio_value,
					values_step: $global_array
				},
				function ShowMsg(value){
					if (value == "true"){
						DisplayAlertSuccess('Groupe de seuils sauvegardé', "step_group_view.php");
					}
					else if (value == "false"){
						DisplayAlertWarning('Veuillez saisir les champs obligatoire');
					}
					else {
						DisplayAlertWarning('Impossible de se connecter à la base de données');
					}
				}
			);
		}

		else{
			$.get(
				'./php/new_entry.php',
				{
					table_name: 'step_group',
					name: $("#name").val(),
					id_kpi: $("#id_kpi").val(),
					type: $radio_value,
					values_step: $global_array
					
				},
				function GotoContextView(value){
					if (value == "true"){
						DisplayAlertSuccess('Groupe de seuils sauvegardé', "step_group_view.php");
					}
					else if (value == "false"){
						DisplayAlertWarning('Veuillez saisir les champs obligatoire');
					}
					else {
						DisplayAlertWarning('Impossible de se connecter à la base de données');
					}
				}
			);
		}
	});

	$('#submit_interval').click(function(event){
		event.preventDefault();
		if($('#interval_min').val() == "" || $('#interval_max').val() == "" || $radio_value == ""){
			return false;
		}

		else{
			$counter = $counter +1;

			if($counter > 4){
				return false;
			}

			$interval_min = parseFloat($('#interval_min').val());
			$interval_max = parseFloat($('#interval_max').val());

			if($interval_min >= $interval_max){
				DisplayAlertWarning('Le seuil minimum est supérieur ou égale au seuil maximum');
				return false;
			}

			if($radio_value == '%' && $interval_max > 100){
				DisplayAlertWarning('Le seuil maximum ne peut excéder les 100%');
				return false;
			}

			if($counter == 1){
				$('#name_kpi').prop('disabled', true);
				$('#interval_min').prop('readonly', true);
				if($radio_value == '%'){
					$('#unit_kpi').prop('disabled', true);
				}
				else{
					$('#unit_ratio').prop('disabled', true);
				}
			}

			if($('#container_interval').is(':hidden')){
				$('#container_interval').css('display', 'inline');
			}

			// On camoufle le bouton de suppression de l'interval du dessus
			$previous_id_button = $counter -1 +'id';
			$current_id_button = $counter +'id';

			$('#' + $previous_id_button).css('display','none');

			$('#container_interval').append('<tr id="'+$counter+'"><td style="text-align:center">n°' + $counter + '</td><td style="text-align:center">' + $interval_min + $radio_value + '</td><td style="text-align:center">' + $interval_max + $radio_value + '</td><td style="text-align:center"><button type="button" class="btn btn-danger" id="'+$current_id_button+'" onclick=RemoveInterval(id)><span class="glyphicon glyphicon-remove"></span></button></td></tr>');

			var arr = [$interval_min, $interval_max];

			$global_array[$counter] = arr;

			$('#interval_min').val($('#interval_max').val());
		}
	});

});

function CheckRadioButton(id_radio){
	if(id_radio == 'unit_kpi'){
		$('#interval_min').prop('readonly', false);
		$('#interval_min').val("");
		$radio_value = $short_name;
	}
	else if(id_radio == 'unit_ratio'){
		$('#interval_min').val(0);
		$('#interval_min').prop('readonly', true);
		$radio_value = '%';
	}
}

function ChangeValueSelected(values){
	$array_name_id = values.split("_");
    $name = $array_name_id[0];
    $id = $array_name_id[1];
    $('#name_kpi').html($name+'  <span class="caret"></span></button>');
    $('#id_kpi').val($id);

	$.get(
		'./php/get_shortname_unit.php',
		{
			id_unit: $('#id_kpi').val()
		},
		function ReturnNameUnit(name){
			$short_name = name['SHORT_NAME'];
			$('#label_unit_kpi').html('<input type="radio" name="optradio" id="unit_kpi" onchange="CheckRadioButton(id)">Unité ('+$short_name+') ');

			if (UrlParam('id_number') != false){
				if($radio_value == '%'){
					CheckRadioButton('unit_ratio');
					$('#unit_ratio').prop( "checked", true );
					$('#name_kpi').prop('disabled', true);
					$('#unit_kpi').prop('disabled', true);
				}
				else{
					CheckRadioButton('unit_kpi');
					$('#unit_kpi').prop( "checked", true );
					$('#unit_ratio').prop('disabled', true);
					$('#name_kpi').prop('disabled', true);
				}
			}
		},
		'json'
	);

	if($('#display_unit_checkbox').is(':visible')){
		return false;
	}
	else{
		$('#display_unit_checkbox').css("display", "inline");
		$('#display_interval').css("display", "inline");
    $('#submit_interval').css("display", "block");
		$('#text_entry').css("display", "inline");
	}
}

function ChangeValue(values){
	var array_values = values.split("_");
	var object_name = array_values[0];
	var value = array_values[1];

	if(object_name == 'min'){
		$('#interval_min').val(value);
	}
	else if(object_name == 'max'){
		$('#interval_max').val(value);
	}
}

function RemoveInterval(value){
	$tr_id_value = value[0];
	$('tr[id="' + $tr_id_value +'"]').remove();

	// On rend visible le bouton de suppression de l'interval du dessus
        $previous_id_button = parseInt($tr_id_value) -1 +'id';
        $('#' + $previous_id_button).css('display','inline');

	$array = {};
  $index = 0;
  var count = $.map($global_array, function(n, i) { return i; }).length;

	$('tr[id="' + value +'"]').remove();

	for ($i = 1; $i <= count; $i++){
		if($i != parseInt(value)){
			$index++;
			$array[$index] = $global_array[$i];
    		}
  	}

	$global_array = $array;
	$counter = $index;

	if(Object.keys($global_array).length == 0){
		$('#container_interval').css('display', 'none');
                $('#name_kpi').prop('disabled', false);
                if($radio_value == '%'){
                        $('#unit_kpi').prop('disabled', false);
			$('#interval_min').val(0);
                }
                else{
                        $('#unit_ratio').prop('disabled', false);
			$('#interval_min').val('');
			$('#interval_min').prop('readonly', false);
                }

        	$('#interval_max').val('');
        }

	else{
		$('#interval_min').val($global_array[$counter][1]);
		$('#interval_max').val('');
	}
}

</script>

<?php
include("../../footer.php");
?>


