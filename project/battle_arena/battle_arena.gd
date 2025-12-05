extends Control


var _game_active := true

@onready var _monster_opponent := Monster.new(MonsterSelections.opponent_breed)
@onready var _monster_self := Monster.new(MonsterSelections.self_breed)
@onready var _event_queue: EventQueue = %EventQueue
@onready var _move_buttons: MoveButtons = %MoveButtons
@onready var _textbox: Textbox = %Textbox


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
	
	%OpponentTexture.texture = _monster_opponent.get_texture()
	%SelfTexture.texture = _monster_self.get_texture()
	
	_event_queue.queue_started.connect(_move_buttons.disable)
	_event_queue.queue_depleted.connect(_move_buttons.enable)
	_event_queue.event_started.connect(_textbox.handle_event)
	_event_queue.event_started.connect(%OpponentPlayerInfo.handle_event)
	_event_queue.event_started.connect(%SelfPlayerInfo.handle_event)
	_move_buttons.move_selected.connect(_on_move_selected)

	for monster in [_monster_opponent, _monster_self]:
		monster.move_used.connect(_on_move_used.bind(monster))
		monster.fainted.connect(_add_fainted_message.bind(monster))

	_move_buttons.set_moves(_monster_self.get_moves())

	_event_queue.add_event(MessageEvent.new(tr("AWAIT_CHOICE")))


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("advance_text"):
		_textbox.reset()


func _process_turn(monsters: Array[Monster], self_move_index: int) -> void:
	_textbox.reset()
	var turn_order := Monster.order_by_speed(monsters)

	for i in len(turn_order):
		if not _game_active:
			return

		if turn_order[i].get_belongs_to_player():
			turn_order[i].use_move(turn_order[1-i], self_move_index)
		else:
			turn_order[i].use_move(turn_order[1-i], randi_range(0,3))

	_event_queue.add_event(MessageEvent.new(tr("AWAIT_CHOICE")))


func _win() -> void:
	_game_active = false
	print("YOU WIN!!!")


func _lose() -> void:
	_game_active = false
	print("YOU LOSE :'(")


func _on_move_selected(move_index: int) -> void:
	_process_turn([_monster_opponent, _monster_self], move_index)


func _self_decrease_health(damage_amount: int) -> void:
	_event_queue.add_event(HealthChangeEvent.new(_monster_self, damage_amount))


func _opponent_decrease_health(damage_amount: int) -> void:
	_event_queue.add_event(HealthChangeEvent.new(_monster_opponent, damage_amount))


func _on_move_used(target: Monster, move: Move, is_successful: bool, monster: Monster) -> void:
	var _message_event: MessageEvent
	_message_event = MessageEvent.new(tr("MOVE_USED") % [monster.get_monster_name(), move.get_move_name(), target.get_monster_name()])
	_event_queue.add_event(_message_event)

	if is_successful:
		@warning_ignore("integer_division")
		target.take_damage(move.get_attack_power()/10)
	else:
		_message_event = MessageEvent.new(tr("MOVE_MISSED") % [monster.get_monster_name()])
		_event_queue.add_event(_message_event)


func _add_fainted_message(monster: Monster) -> void:
	var _message_event := MessageEvent.new(tr("FAINTED") % monster.get_monster_name())
	_event_queue.add_event(_message_event)
