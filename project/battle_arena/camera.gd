extends Camera2D

const SECONDS: float = 0.5

@export var max_offset = Vector2(100, 75)
@export var max_roll = 0.1

var trauma = 0.1
var trauma_power = 2
var _shake_active: bool = false
var _event: CritEvent


func _process(_delta) -> void:
	if not _shake_active:
		return

	_shake()


func handle_event(event: Event) -> void:
	if not event is CritEvent:
		return
	
	_event = event
	_handle_crit_event(event)


func _handle_crit_event(event: CritEvent) -> void:
	var _timer = get_tree().create_timer(SECONDS)
	_shake_active = true

	_timer.timeout.connect(_stop_shake)
	event.start(self)


func _shake() -> void:
	var amount = pow(trauma, trauma_power)
	rotation = max_roll * amount * randf_range(-1, 1)
	offset.x = max_offset.x * amount * randf_range(-1, 1)
	offset.y = max_offset.y * amount * randf_range(-1, 1)


func _stop_shake() -> void:
	_shake_active = false
	_event.complete.call_deferred(self)
	rotation = 0
	offset.x = 0
	offset.y = 0
