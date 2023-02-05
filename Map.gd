extends TileMap

func get_cell_movement_data_infantry(x: int, y: int) -> int:
	return get_cell_tile_data(0, Vector2(x, y)).get_custom_data("Infantry Movement Data")

func get_cell_movement_data_armored(x: int, y: int) -> int:
	return get_cell_tile_data(0, Vector2(x, y)).get_custom_data("Armored Movement Data")

func get_cell_movement_data_cavalry(x: int, y: int) -> int:
	return get_cell_tile_data(0, Vector2(x, y)).get_custom_data("Cavalry Movement Data")

func get_cell_movement_data_flier(x: int, y: int) -> int:
	return get_cell_tile_data(0, Vector2(x, y)).get_custom_data("Flier Movement Data")




func get_movement_costs(grid: Grid, movement_type: Unit.TYPE_UNIT = Unit.TYPE_UNIT.INFANTRY) -> Array:
	var movement_costs = []
	
	for y in range(grid.size.y):
		movement_costs.append([])
		for x in range(grid.size.x):
			var tile_cost
			match movement_type:
				Unit.TYPE_UNIT.INFANTRY: 
					tile_cost = get_cell_movement_data_infantry(x, y)
				Unit.TYPE_UNIT.ARMORED: 
					tile_cost = get_cell_movement_data_armored(x, y)
				Unit.TYPE_UNIT.CAVALRY: 
					tile_cost = get_cell_movement_data_cavalry(x, y)
				Unit.TYPE_UNIT.FLIER: 
					tile_cost = get_cell_movement_data_flier(x, y)
			
			movement_costs[y].append(tile_cost)
			
	return movement_costs


