extends Control

@export var _monster_opponent: Monster
@export var _monster_self: Monster

var _game_active := true

@onready var _message_queue: MessageQueue = %MessageQueue
@onready var _move_buttons: MoveButtons = %MoveButtons


func _ready() -> void:
	_monster_opponent.initialize()
	_monster_self.initialize()
	_monster_self.set_belongs_to_player()
	_monster_opponent.fainted.connect(_win)
	_monster_self.fainted.connect(_lose)
	_monster_self.damage_taken.connect(_self_decrease_health)
	_monster_opponent.damage_taken.connect(_opponent_decrease_health)
	%OpponentPlayerInfo.set_player(_monster_opponent)
	%SelfPlayerInfo.set_player(_monster_self)
	_message_queue.queue_started.connect(_move_buttons.disable)
	_message_queue.queue_depleted.connect(_move_buttons.enable)
	_move_buttons.move_selected.connect(_on_move_selected)

	for monster in [_monster_opponent, _monster_self]:
		monster.move_used.connect(_add_move_used_message.bind(monster))
		monster.move_missed.connect(_add_move_missed_message.bind(monster))
		monster.damage_taken.connect(_add_damage_taken_message.bind(monster))
		monster.fainted.connect(_add_fainted_message.bind(monster))

	_move_buttons.set_moves(_monster_self.get_moves())

	_message_queue.add_message(Message.new(tr("AWAIT_CHOICE")))


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("advance_text"):
		_message_queue.advance()


func _process_turn(monsters: Array[Monster], self_move_index: int) -> void:
	var turn_order := Monster.order_by_speed(monsters)

	for i in len(turn_order):
		if not _game_active:
			return

		if turn_order[i].get_belongs_to_player():
			turn_order[i].use_move(turn_order[1-i], self_move_index)
		else:
			turn_order[i].use_move(turn_order[1-i], randi_range(0,3))

	_message_queue.add_message(Message.new(tr("AWAIT_CHOICE")))


func _win() -> void:
	_game_active = false
	print("YOU WIN!!!")


func _lose() -> void:
	_game_active = false
	print("YOU LOSE :'(")


func _on_move_selected(move_index: int) -> void:
	_process_turn([_monster_opponent, _monster_self], move_index)


func _self_decrease_health(damage_amount: int) -> void:
	%SelfPlayerInfo.subtract_health(damage_amount)


func _opponent_decrease_health(damage_amount: int) -> void:
	%OpponentPlayerInfo.subtract_health(damage_amount)


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
