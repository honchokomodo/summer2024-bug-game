extends Node2D

@export var cardPlayed: OptionButton
@export var card_container: Node2D

signal cardPlayedSignal(int)

# Plots line that cards propogate on
# FIXME: messes up if you resize window before pushing the start game button
@onready var CardOval_centerPos = Vector2(get_viewport().size) * Vector2(0.5, 1.4)
@onready var H_radius = get_viewport().size.x * 0.45
@onready var V_radius = get_viewport().size.y * 0.4
@onready var angle = deg_to_rad(90) - 0.62
@onready var OvalAngleVector = Vector2.ZERO
#FIXME: needs to be dynamic and adjust numbers according to number of cards and size of texture


# zoinks we need the card object
func getIndexRelativeCard(selected_item: int):
	print("Meowmeowmeomeowmoewmoew    ", selected_item)
	cardPlayedSignal.emit(Player.cardsArray[selected_item])

# Function to add cards to the HBoxContainer
func add_cards(cards: Array[Card]):
	var card_display_scene = preload("res://scenes/card_node2D.tscn")
	for card_index in cards.size():
		var card_entry = cards[card_index]
		var card_display = card_display_scene.instantiate()
		card_display.set_card(card_entry, card_index)
		card_container.add_child(card_display)
		set_hand_position(card_display)
		angle += 0.25 #changes angle FIXME: again, dynamic

func set_hand_position(card: Node2D):
	# Positions card along plotted angle
		var card_tex_size = Vector2(120, 195) #FIXME: figure out a way to dynamically check size of card texture
		OvalAngleVector = Vector2(H_radius * cos(angle), -(V_radius * sin(angle))) # calculates where a point would be on a curve, based on angle
		
		# sets card position to a OvalAngleVector curve based on CardOval_centerPOS and offsets it based on card size
		card.position = CardOval_centerPos + OvalAngleVector - card_tex_size / 2
		card.rotation = card.position.angle_to(CardOval_centerPos) # rotates card to point at centerPOS

# Called when the node enters the scene tree for the first time.
func _ready():
	# DON'T GET RID OF THIS SIGNAL!!
	cardPlayed.item_selected.connect(getIndexRelativeCard)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_dev_card_action_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed:
			#print(event) # Replace with function body.
			getIndexRelativeCard(2)
