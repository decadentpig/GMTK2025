extends Node

const DEFAULT_MONEY = 15
const DEFAULT_CONTRACTS_COMPLETE = 0
const DEFAULT_NUM_CARRIAGES = 0
const DEFAULT_AVAILABLE_CARRIAGES = 0
const DEFAULT_LOOPS = 0

var money = DEFAULT_MONEY
var contracts_complete = 0
var num_carriages = 0
var available_carriages = 0
var total_loops = DEFAULT_LOOPS
var previous_game_loops = DEFAULT_LOOPS

func apply_defaults():
	money = DEFAULT_MONEY
	contracts_complete = DEFAULT_CONTRACTS_COMPLETE
	num_carriages = DEFAULT_NUM_CARRIAGES
	available_carriages = DEFAULT_AVAILABLE_CARRIAGES
	total_loops = DEFAULT_LOOPS
