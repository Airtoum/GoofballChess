extends PieceComponent

class_name PC_MovesOrthogonally


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func when_get_moves(piece: Piece, list_of_moves: Array[Move]):
	if piece.has_component("CanMoveToSpaces") and piece.has_component("InhabitsSpaces"):
		var inhabits_spaces = piece.get_component("InhabitsSpaces") as PC_InhabitsSpaces
		var originating_space: Space = inhabits_spaces.inhabiting_space
		for facet_direction in originating_space.facets:
			var data = TraversalData.new()
			traverse_spaces(piece, facet_direction, inhabits_spaces.inhabiting_space, data, list_of_moves)
	if piece.has_component("CanMoveOverNothing"):
		pass

class TraversalData:
	var past_spaces: Array[Space]
	var past_dirs: Array[int]
	var involves_loop: bool
	func _init():
		past_spaces = []
		past_dirs = []
		involves_loop = false
	func copy():
		var data: TraversalData = TraversalData.new()
		data.past_spaces = self.past_spaces.duplicate()
		data.past_dirs = self.past_dirs.duplicate()
		data.involves_loop = self.involves_loop
		return data
	func count_states(space: Space, dir: int):
		var count = 0
		for i in range(past_spaces.size()):
			if past_spaces[i] == space and past_dirs[i] == dir:
				count += 1
		return count

func traverse_spaces(piece:Piece, direction: int, space: Space, data: TraversalData, list_of_moves: Array[Move]):
	#space.modulate = Color.RED
	for neighbor in space.traverse(direction):
		direction = space.traverse_dir(direction)
		var in_loop = data.involves_loop
		var loop_count = data.count_states(neighbor, direction)
		if loop_count == 1:
			in_loop = true
		if loop_count >= 2:
			return
		var next_data = data.copy()
		next_data.past_spaces.append(neighbor)
		next_data.past_dirs.append(direction)
		next_data.involves_loop = in_loop
		var move = MoveThroughSpaces.new(piece, next_data.past_spaces.duplicate())
		move.in_loop = in_loop
		list_of_moves.append(move)
		traverse_spaces(piece, direction, neighbor, next_data, list_of_moves)
		
