extends Node

class_name Board

enum BoardGenerationType {NONE, STANDARD, FOURPLAYER}
@export var board_generation: BoardGenerationType
@export var WhiteSpace: PackedScene
@export var BlackSpace: PackedScene

var game = null
var pieces: Array[Piece] = []
var spaces: Array[Space] = []

var pieces_by_pos = {}
var spaces_by_pos = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	if board_generation:
		for i in range(8):
			for j in range(8):
				var new_space: Space
				if (i + j) % 2 == 0:
					new_space = WhiteSpace.instantiate()
				else:
					new_space = BlackSpace.instantiate()
				self.add_child(new_space)
				var pos = Vector2(100 * i, 100 * j)
				new_space.position = pos
				move_space(new_space, Vector2.ZERO, new_space.position)
				new_space.add_neighbor(Space.BACKWARD & Space.LEFT, spaces_by_pos[pos + Vector2(-100, -100)])
			

func add_to_game(new_game):
	if (game):
		game.board = null
	game = new_game


func add_thing(things, things_by_pos, thing):
	things.append(thing)
	if things_by_pos.has(thing.position):
		things_by_pos[thing.position].append(thing)
	else:
		things_by_pos[thing.position] = [thing]
		
func add_piece(piece):
	add_thing(pieces, pieces_by_pos, piece)
	
func add_space(space):
	add_thing(spaces, spaces_by_pos, space)


func remove_thing(things, things_by_pos, thing):
	things.erase(thing)
	if things_by_pos.has(thing.position):
		things_by_pos[thing.position].erase(thing)
	else:
		# we don't know where it is
		push_warning("Piece was lost track of: " + str(thing))
		
func remove_piece(piece):
	remove_thing(pieces, pieces_by_pos, piece)
	
func remove_space(space):
	remove_thing(spaces, spaces_by_pos, space)


func move_thing(things_by_pos, thing, old_pos, new_pos):
	if things_by_pos.has(old_pos):
		things_by_pos[old_pos].erase(thing)
	else:
		# we don't know where it is
		push_warning("Piece was lost track of: " + str(thing))
	if things_by_pos.has(new_pos):
		things_by_pos[new_pos].append(thing)
	else:
		things_by_pos[new_pos] = [thing]
		
func move_piece(piece, old_pos, new_pos):
	move_thing(pieces_by_pos, piece, old_pos, new_pos)
	
func move_space(space, old_pos, new_pos):
	move_thing(spaces_by_pos, space, old_pos, new_pos)


func get_things_at_pos(things_by_pos, pos):
	if not things_by_pos.has(pos):
		things_by_pos[pos] = Array([])
	return things_by_pos.get(pos)

func get_pieces_at_pos(pos):
	return get_things_at_pos(pieces_by_pos, pos)
	
func get_spaces_at_pos(pos):
	return get_things_at_pos(spaces_by_pos, pos)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
