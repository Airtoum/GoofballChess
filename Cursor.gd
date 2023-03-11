extends Node2D


@export var InfoBoxTitle: PackedScene
@export var InfoBoxText: PackedScene
@export var InfoBoxMargin: PackedScene

@onready var InfoBox = $InfoBox


var expanding_piece: Piece = null
var expand_timer = 0
var expand_delay = 0.8

var selected_piece: Piece = null

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = get_global_mouse_position()
	if expanding_piece:
		expand_timer += delta
	var progress = 1 if $ExpandTimer.is_stopped() else $ExpandTimer.time_left/$ExpandTimer.wait_time
	$TextureProgressBar.value = 100 * (1 - progress)
	if Cameranator.current:
		scale = Cameranator.current.zoom

func start_to_expand(piece):
	self.expanding_piece = piece
	$ExpandTimer.start()

func clear_expand(piece):
	self.expanding_piece = null
	$ExpandTimer.stop()
	$ColorRect.hide()
	$TextureProgressBar.show()
	for child in InfoBox.get_children():
		if not child is ColorRect:
			child.queue_free()


func _on_ExpandTimer_timeout():
	$TextureProgressBar.hide()
	$ColorRect.show()
	InfoBox.show()
	generate_info()
	
func generate_info():
	var elements = []
	
	add_title(elements, self.expanding_piece.piece_name)
	for component in self.expanding_piece.get_children():
		if component is PieceComponent:
			var desc = component.description
			var has_image = desc.find("<texture>")
			
			var result = search_regex("<priority:\\d+>", desc)
			var priority = null
			if result:
				priority = int(result[0].lstrip("<priority:").rstrip(">"))
			if has_image > -1:
				add_image(elements, component, priority if priority else 10)
			else:
				add_description(elements, component.description, priority if priority else 50)
	
	elements.sort_custom(Callable(self,"element_sort"))
	for element in elements:
		InfoBox.add_child(element[0])
	
	if InfoBox.get_child_count() > 0:
		var last_element = InfoBox.get_child(InfoBox.get_child_count() - 1)
		var top_margin = last_element.get("theme_override_constants/margin_top")
		last_element.set("theme_override_constants/margin_bottom", top_margin)
	
	call_deferred("update_background")

func update_background():
	$ColorRect.size = $InfoBox.size
	
func search_regex(pattern, string):
	var regex = RegEx.new()
	regex.compile(pattern)
	var results = regex.search_all(string)
	var arr = []
	for result in results:
		arr.append(result.get_string())
	return arr
	
func element_sort(a, b):
	if a[1] < b[1]:
		return true
	return false

func add_element(all_elements, element, priority=50):
	var margin = InfoBoxMargin.instantiate()
	margin.add_child(element)
	all_elements.append([margin, priority])

func add_description(all_elements, description, priority=50):
	if len(description) == 0:
		return
	var text = InfoBoxText.instantiate()
	text.text = description
	add_element(all_elements, text, priority)

func add_image(all_elements, component, priority=10):
	var image = component.duplicate()
	add_element(all_elements, image, priority)

func add_title(all_elements, title_text, priority=0):
	var title = InfoBoxTitle.instantiate()
	title.text = title_text
	add_element(all_elements, title, priority)
