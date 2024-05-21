extends Button

var original_scale: Vector2
@export var chip_prefab: Control
@export var texture_container: Control
@export_range(-1,1) var rotation_speed: float = 1.0
var rotate_texture: bool = false
var can_resize: bool = true

func _ready():
	original_scale = chip_prefab.scale

func _process(delta):
	rotation(delta)

func _on_mouse_entered():
	if can_resize:
		chip_prefab.scale = original_scale * 1.2
	rotate_texture = true

func _on_mouse_exited():
	if can_resize:
		chip_prefab.scale = original_scale
		rotate_texture = false

func _on_pressed():
	chip_prefab.scale = original_scale * 1.3
	can_resize = false
	rotate_texture = true

func rotation(delta):
	if rotate_texture:
		texture_container.rotation += rotation_speed * delta
	else:
		texture_container.rotation = lerp(float(texture_container.rotation), 0.0, 5 * rotation_speed * delta)
		if abs(texture_container.rotation) < 0.01:
			texture_container.rotation = 0.0


func _on_chip_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		var mouse_pos = event.position
		var button_rect = Rect2(global_position, self.position)

		if not button_rect.has_point(mouse_pos):
			can_resize = false
			chip_prefab.scale = original_scale
			print("Hola")
