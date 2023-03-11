extends Move

class_name MoveThroughSpaces

var spaces: Array[Space]
var num_loops: int

func _init(piece: Piece, spaces: Array[Space], num_loops = 0):
	self.piece = piece
	self.spaces = spaces
	self.num_loops = num_loops

func final_space() -> Space:
	return spaces.back()
	
func setup_listeners():
	final_space().link_move(self)
	
