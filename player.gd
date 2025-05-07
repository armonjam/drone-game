extends CharacterBody3D

const MOVE_ACCEL: float = 8
const MAX_MOVE_VEL: float = 12

var camera_sens: float = 1
var look_dir: Vector2
var move_dir: Vector2
var move_vel: Vector3 = Vector3.ZERO

const TILT_ACCEL: float = 2 * PI
const TILT_MAX: float = PI/24
var tilt: float = 0

@onready var camera: Camera3D = $Camera3D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(_delta) -> void:
	move_dir = Input.get_vector('move_left', 'move_right', 'move_backward', 'move_forward')

func _physics_process(delta: float) -> void:
	_tilt_view(delta)
	# move player
	var move_dir_global = camera.basis.x * move_dir.x + -camera.basis.z * move_dir.y
	move_vel = move_vel.lerp(move_dir_global * MAX_MOVE_VEL, delta * MOVE_ACCEL)
	self.translate(move_vel * delta)
	
func _tilt_view(delta: float) -> void:
	tilt = lerpf(tilt, -move_dir.x * TILT_MAX, delta * TILT_ACCEL)
	camera.rotation.z = tilt

func _rotate_camera(sens_mod: float = 1.0) -> void:
	camera.rotation.y -= look_dir.x * camera_sens * sens_mod
	camera.rotation.x = clamp(camera.rotation.x - look_dir.y * camera_sens * sens_mod, -1.5, 1.5)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		look_dir = event.relative * 0.001
		_rotate_camera()
