extends Node

# Variables para el control del sonido
var mixer_master: int
var max_presses: int = 3
var sound_button_press_count: int = max_presses
var volume_levels: Array = [-80, -40, -20, 0] # Niveles de volumen fijos

# Variables para el control de la imagen del botón
@export var button_icon_atlas: AtlasTexture
var button_icons: Array = [
	Rect2(350, 330, 200, 200), # Imagen cuatro Mute
	Rect2(64, 330, 200, 200),  # Imagen tres Low
	Rect2(350, 72, 200, 200),  # Imagen dos Medium
	Rect2(72, 72, 200, 200)    # Imagen uno High
]

func _ready():
	mixer_master = AudioServer.get_bus_index("Master")

	update_sound_and_image()

# Función para actualizar la imagen del botón
func set_button_image(index: int):
	if button_icon_atlas:
		button_icon_atlas.region = button_icons[index]
	else:
		print_debug("Error: AtlasTexture del botón no definido.")

# Función para subir el volumen
func increase_sound():
	sound_button_press_count = sound_button_press_count % (max_presses + 1)
	var target_volume = volume_levels[sound_button_press_count]
	AudioServer.set_bus_volume_db(mixer_master, target_volume)

# Función para actualizar el sonido y la imagen del botón
func update_sound_and_image():
	increase_sound()
	set_button_image(sound_button_press_count)

func _on_button_sounds_pressed():
	sound_button_press_count += 1
	update_sound_and_image()
