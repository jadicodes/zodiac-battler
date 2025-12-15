extends Control

const DAMAGE_DIVIDER: float = 10
const DEFAULT_MULTIPLER: float = 1.0
const SUPER_EFFECTIVE_MULTIPLIER: float = 1.5
const NOT_EFFECTIVE_MULTIPLIER: float = 0.5
const STAB_MULTIPLIER: float = 1.5
const CRIT_MULTIPLIER: float = 2.0

var _game_active := true

@onready var _monster_opponent := Monster.new(MonsterSelections.opponent_breed)
@onready var _monster_self := Monster.new(MonsterSelections.self_breed)
@onready var _event_queue: EventQueue = %EventQueue
@onready var _move_animator: MoveAnimator = %MoveAnimator
@onready var _move_buttons: MoveButtons = %MoveButtons
@onready var _game_end_buttons: GameEndButtons = %GameEndButtons
@onready var _textbox: Textbox = %Textbox


func _ready() -> void:
	_monster_opponent.initialize()
	_monster_self.initialize()
	_monster_self.set_belongs_to_player()
	_move_animator.set_monsters(_monster_self, _monster_opponent)
	_monster_self.damage_taken.connect(_self_decrease_health)
	_monster_opponent.damage_taken.connect(_opponent_decrease_health)
	
	%OpponentPlayerInfo.set_player(_monster_opponent)
	%SelfPlayerInfo.set_player(_monster_self)
	%OpponentTexture.set_player(_monster_opponent)
	%SelfTexture.set_player(_monster_self)
	
	_event_queue.queue_started.connect(_move_buttons.disable)
	_event_queue.queue_depleted.connect(_move_buttons.enable)
	_event_queue.event_started.connect(self.handle_event)
	_event_queue.event_started.connect(_textbox.handle_event)
	_event_queue.event_started.connect(%Camera.handle_event)
	_event_queue.event_started.connect(_move_animator.handle_event)
	_event_queue.event_started.connect(%OpponentPlayerInfo.handle_event)
	_event_queue.event_started.connect(%SelfPlayerInfo.handle_event)
	_event_queue.event_started.connect(%OpponentTexture.handle_event)
	_event_queue.event_started.connect(%SelfTexture.handle_event)
	_move_buttons.move_selected.connect(_on_move_selected)
	_game_end_buttons.rematch_selected.connect(_rematch)
	_game_end_buttons.new_game_selected.connect(_start_new_game)

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


func handle_event(event: Event) -> void:
	if not event is GameEndEvent:
		return

	_move_buttons.visible = false
	_game_end_buttons.visible = true


func _rematch() -> void:
	get_tree().change_scene_to_file("res://battle_arena/battle_arena.tscn")


func _start_new_game() -> void:
	get_tree().change_scene_to_file("res://monster_select/monster_select.tscn")


func _on_move_selected(move_index: int) -> void:
	_process_turn([_monster_opponent, _monster_self], move_index)


func _self_decrease_health(damage_amount: int) -> void:
	_event_queue.add_event(HealthChangeEvent.new(_monster_self, damage_amount))


func _opponent_decrease_health(damage_amount: int) -> void:
	_event_queue.add_event(HealthChangeEvent.new(_monster_opponent, damage_amount))


func _on_move_used(target: Monster, move: Move, is_successful: bool, is_crit: bool, monster: Monster) -> void:
	var _damage_multiplier : float = DEFAULT_MULTIPLER
	var _effectiveness_message_event: MessageEvent
	var _message_event: MessageEvent
	_message_event = MessageEvent.new(tr("MOVE_USED") % [monster.get_monster_name(), move.get_move_name(), target.get_monster_name()])
	_event_queue.add_event(_message_event)

	if is_successful:
		_event_queue.add_event(MoveEvent.new(monster, move))
		@warning_ignore("integer_division")

		# Type Effectiveness
		if Types.is_super_effective(move.get_type(), target.get_type()):
			_damage_multiplier *= SUPER_EFFECTIVE_MULTIPLIER
			_effectiveness_message_event = MessageEvent.new(tr("SUPER_EFFECTIVE"))

		if Types.is_not_effective(move.get_type(), target.get_type()):
			_damage_multiplier *= NOT_EFFECTIVE_MULTIPLIER
			_effectiveness_message_event = MessageEvent.new(tr("NOT_EFFECTIVE"))

		# Same Type Attack Bonus (STAB)
		if monster.get_type() == move.get_type():
			_damage_multiplier *= STAB_MULTIPLIER

		# Critical Hit
		if is_crit:
			_damage_multiplier *= CRIT_MULTIPLIER
			_event_queue.add_event(CritEvent.new())
			_event_queue.add_event(MessageEvent.new(tr("CRITICAL_HIT")))

		@warning_ignore("narrowing_conversion", "integer_division")
		target.take_damage((move.get_attack_power()/DAMAGE_DIVIDER) * _damage_multiplier)
		if _effectiveness_message_event:
			_event_queue.add_event(_effectiveness_message_event)

	else:
		_message_event = MessageEvent.new(tr("MOVE_MISSED") % [monster.get_monster_name()])
		_event_queue.add_event(_message_event)


func _add_fainted_message(monster: Monster) -> void:
	var _message_event := MessageEvent.new(tr("FAINTED") % monster.get_monster_name())
	_event_queue.add_event(_message_event)
	_event_queue.add_event(GameEndEvent.new())
