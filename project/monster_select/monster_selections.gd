extends Node

var self_breed: Breed = null
var opponent_breed: Breed = null


func is_set() -> bool:
	return self_breed and opponent_breed


func reset() -> void:
	self_breed = null
	opponent_breed = null
