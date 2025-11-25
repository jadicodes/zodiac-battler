extends Control

@export var _monster_opponent: Monster
@export var _monster_self: Monster

var _game_active := true

@onready var _message_queue: MessageQueue = %MessageQueue
@onready var _move_buttons: Array[Button] = [%Move1, %Move2, %Move3, %Move4]


func _ready() -> void:
	_monster_opponent.initialize()
	_monster_self.initialize()
	_monster_opponent.fainted.connect(_win)
	_monster_self.fainted.connect(_lose)
	_monster_self.damage_taken.connect(_self_decrease_health)
	_monster_opponent.damage_taken.connect(_opponent_decrease_health)
	%SelfHealthBar.on_game_start(_monster_self.get_total_health_points())
	%OpponentHealthBar.on_game_start(_monster_opponent.get_total_health_points())
	_message_queue.queue_depleted.connect(_reenable_move_buttons)

	for monster in [_monster_opponent, _monster_self]:
		monster.move_used.connect(_add_move_used_message.bind(monster))
		monster.move_missed.connect(_add_move_missed_message.bind(monster))
		monster.damage_taken.connect(_add_damage_taken_message.bind(monster))
		monster.fainted.connect(_add_fainted_message.bind(monster))

	var moves := _monster_self.get_moves()
	for i in len(_move_buttons):
		_move_buttons[i].text = moves[i].get_move_name()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("advance_text"):
		_message_queue.advance()


func _process_turn(monsters: Array[Monster], self_move_index: int) -> void:
	var turn_order := Monster.order_by_speed(monsters)
	
	for button in _move_buttons:
		button.disabled = true

	for i in len(turn_order):
		if not _game_active:
			return

		if turn_order[i].get_belongs_to_player():
			turn_order[i].use_move(turn_order[1-i], self_move_index)
		else:
			turn_order[i].use_move(turn_order[1-i], randi_range(0,3))


func _win() -> void:
	_game_active = false
	print("YOU WIN!!!")


func _lose() -> void:
	_game_active = false
	print("YOU LOSE :'(")


func _on_move_button_pressed(move_index: int) -> void:
	_process_turn([_monster_opponent, _monster_self], move_index)


func _reenable_move_buttons() -> void:
	for button in _move_buttons:
		button.disabled = false


func _self_decrease_health(damage_amount: int) -> void:
	%SelfHealthBar.subtract_health(damage_amount)


func _opponent_decrease_health(damage_amount: int) -> void:
	%OpponentHealthBar.subtract_health(damage_amount)


func _add_move_used_message(target: Monster, move: Move, monster: Monster) -> void:
	var message := Message.new(tr("MOVE_USED") % [monster.get_monster_name(), move.get_move_name(), target.get_monster_name()])
	_message_queue.add_message(message)


func _add_move_missed_message(_target: Monster, _move: Move, monster: Monster) -> void:
	var message := Message.new(tr("MOVE_MISSED") % [monster.get_monster_name()])
	_message_queue.add_message(message)


func _add_damage_taken_message(damage_amount: int, monster: Monster) -> void:
	var message := Message.new(tr("DAMAGE_TAKEN") % [monster.get_monster_name(), damage_amount])
	_message_queue.add_message(message)


func _add_fainted_message(monster: Monster) -> void:
	var message := Message.new(tr("FAINTED") % monster.get_monster_name())
	_message_queue.add_message(message)
