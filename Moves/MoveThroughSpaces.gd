extends Move

class_name MoveThroughSpaces

var spaces: Array[Space]
var in_loop: bool

func _init(p_piece: Piece, p_spaces: Array[Space], p_in_loop = false):
	self.piece = p_piece
	self.spaces = p_spaces
	self.in_loop = p_in_loop

func final_space() -> Space:
	return spaces.back()
	
func setup_listeners():
	final_space().link_move(self)
	
func remove_listeners():
	final_space().unlink_move(self)
	
func make():
	piece.move_to(final_space().position)
