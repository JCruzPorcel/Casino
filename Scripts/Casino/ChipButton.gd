extends Button

# Variables
#region Variables
var chip
var chip_controller: HBoxContainer

@export var chip_prefab: Control
@export var texture_container: Control
@export_range(-1, 1) var rotation_speed: float = 1.0
@export_range(0, 20) var scale_speed: float = 10.0

var original_scale: Vector2
var target_scale: Vector2
var rotate_texture: bool = false
var can_resize: bool = true
var is_selected: bool = false
#endregion

# Initialization
#region Initialization
func _ready():
	original_scale = chip_prefab.scale
	target_scale = original_scale
	chip = get_parent_control()
	chip_controller = get_parent().get_parent()
	chip_controller.selected_chip_changed.connect(is_chip_selected)
#endregion

# Process
#region Process
func _process(delta):
	animate_rotation(delta)
	animate_scale(delta)
#endregion

# Mouse Events
#region Mouse Events
func _on_mouse_entered():
	if not is_selected:
		if can_resize:
			target_scale = original_scale * 1.2
		rotate_texture = true

func _on_mouse_exited():
	if not is_selected:
		if can_resize:
			target_scale = original_scale
		rotate_texture = false

func _on_pressed():
	if not is_selected:
		update_selection_state(true)
		chip_controller.set_selected_chip(chip)
	else:
		update_selection_state(false)
#endregion

# Animations
#region Animations
func animate_rotation(delta):
	if rotate_texture:
		texture_container.rotation += rotation_speed * delta
	else:
		texture_container.rotation = lerp(float(texture_container.rotation), 0.0, 5 * rotation_speed * delta)
		if abs(texture_container.rotation) < 0.01:
			texture_container.rotation = 0.0

func animate_scale(delta):
	chip_prefab.scale = chip_prefab.scale.lerp(target_scale, scale_speed * delta)
#endregion

# Selection
#region Selection
func is_chip_selected(new_chip):
	if chip != new_chip:
		update_selection_state(false)
	else:
		update_selection_state(true)

func update_selection_state(selected: bool):
	is_selected = selected
	if selected:
		target_scale = original_scale * 1.4
		can_resize = false
		rotate_texture = true
	else:
		target_scale = original_scale
		can_resize = true
		rotate_texture = false
#endregion
