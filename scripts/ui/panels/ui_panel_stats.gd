extends UISettingsPanel


func _process_overload(): 
	if is_instance_valid(Global.current_scenario): 
		$VBoxContainer/TimeLabel.text = Global.get_elapsed_time_str()
		

		var hits: float = Global.current_scenario.hits
		var misses: float = Global.current_scenario.misses 
		var total: float = hits + misses
		
		if hits != 0 and total != 0 : 
			
			var p = (hits / total) * 100
			%AccuracyLabel.text = "Accuracy: %.2f%%" %p
		else: 
			pass
			
		#var p = 100 if average == 0 else (10.0 / average) * 10.0
		%HitCountLabel.text = "Hits: " + str(Global.current_scenario.hits)
