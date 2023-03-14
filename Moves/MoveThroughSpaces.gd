extends Move

class_name MoveThroughSpaces

var spaces: Array[Space]
var in_loop: bool

func _init(piece: Piece, spaces: Array[Space], in_loop = false):
	self.piece = piece
	self.spaces = spaces
	self.in_loop = in_loop

func final_space() -> Space:
	return spaces.back()
	
func setup_listeners():
	final_space().link_move(self)
	
