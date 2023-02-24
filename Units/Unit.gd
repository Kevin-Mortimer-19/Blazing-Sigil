## Represents a unit checked the game board.
## The board manages its position inside the game grid.
## The unit itself holds stats and a visual representation that moves smoothly in the game world.
@tool
class_name Unit
extends Path2D

## Emitted when the unit reached the end of a path along which it was walking.
signal walk_finished

enum TYPE_UNIT { INFANTRY, ARMORED, CAVALRY, FLIER }

## Shared resource of type Grid, used to calculate map coordinates.
@export var grid: Resource
## Texture2D representing the unit.
@export var skin: Texture2D : set = set_skin
## Distance to which the unit can walk in cells.
@export var move_range := 6
## Offset to apply to the `skin` sprite in pixels.
@export var skin_offset := Vector2.ZERO : set = set_skin_offset
## The unit's move speed when it's moving along a path.
@export var move_speed := 600.0

@export var unit_type: TYPE_UNIT

## Coordinates of the current cell the cursor moved to.
var cell := Vector2.ZERO : set = set_cell
## Toggles the "selected" animation checked the unit.
var is_selected := false : set = set_is_selected

var _is_walking := false : set = _set_is_walking

@onready var _sprite: Sprite2D = $PathFollow2D/Sprite2D
@onready var _anim_player: AnimationPlayer = $AnimationPlayer
@onready var _path_follow: PathFollow2D = $PathFollow2D


func _ready() -> void:
	set_process(false)
	
	self.cell = grid.calculate_grid_coordinates(position)
	position = grid.calculate_map_position(cell)


func _process(delta: float) -> void:
	_path_follow.progress += move_speed * delta
	
	if _path_follow.progress >= curve.get_baked_length():
		self._is_walking = false
		position = grid.calculate_map_position(cell)
		_path_follow.progress = 0.0
		curve.clear_points()
		emit_signal("walk_finished")


## Starts walking along the `path`.
## `path` is an array of grid coordinates that the function converts to map coordinates.
func walk_along(path: PackedVector2Array) -> void:
	if path.is_empty():
		return
	
	curve.add_point(Vector2.ZERO)
	for point in path:
		curve.add_point(grid.calculate_map_position(point) - position)
	cell = path[-1]
	self._is_walking = true


func set_cell(value: Vector2) -> void:
	cell = grid.clamp(value)


func set_is_selected(value: bool) -> void:
	is_selected = value
	if is_selected:
		_anim_player.play("selected")
	else:
		_anim_player.play("idle")


func set_skin(value: Texture2D) -> void:
	skin = value
	if not _sprite:
		await self.ready
	_sprite.texture = value


func set_skin_offset(value: Vector2) -> void:
	skin_offset = value
	if not _sprite:
		await self.ready
	_sprite.position = value


func _set_is_walking(value: bool) -> void:
	_is_walking = value
	set_process(_is_walking)
