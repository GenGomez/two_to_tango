extends Node2D

# ──────────────────────────────
# VARIABLES
# ──────────────────────────────
var lobby_id = 0
var peer: SteamMultiplayerPeer
var is_host = false
var is_joining = false

@export var start_button: Button
@export var host_button: Button
@export var join_button: Button
@export var id_prompt: LineEdit
@export var player_list: VBoxContainer
@export var game_scene: PackedScene

# PeerID → username
var usernames := {}


# ──────────────────────────────
# INPUT (ESC to quit)
# ──────────────────────────────
func _input(event):
	if event.is_action_pressed("esc"):
		get_tree().quit()


# ──────────────────────────────
# READY
# ──────────────────────────────
func _ready():
	print("Steam Initialized: ", Steam.steamInit(480, true))
	Steam.initRelayNetworkAccess()

	Steam.lobby_created.connect(_on_lobby_created)
	Steam.lobby_joined.connect(_on_lobby_joined)

	start_button.disabled = true


# ──────────────────────────────
# HOSTING
# ──────────────────────────────
func _on_host_button_pressed():
	is_host = true
	Steam.createLobby(Steam.LobbyType.LOBBY_TYPE_PUBLIC, 16)
	host_button.disabled = true


func _on_lobby_created(result: int, id: int):
	if result != Steam.Result.RESULT_OK:
		print("Lobby creation failed!")
		return

	lobby_id = id
	print("Lobby created:", lobby_id)

	# Copy lobby ID to clipboard (you asked for this)
	DisplayServer.clipboard_set(str(lobby_id))

	start_button.disabled = false

	# Setup host network
	peer = SteamMultiplayerPeer.new()
	peer.server_relay = true
	peer.create_host()
	multiplayer.multiplayer_peer = peer

	multiplayer.peer_connected.connect(_player_connected)
	multiplayer.peer_disconnected.connect(_player_disconnected)

	_register_my_steam_info()


# ──────────────────────────────
# JOINING
# ──────────────────────────────
func _on_join_button_pressed():
	var id = id_prompt.text.to_int()
	is_joining = true
	Steam.joinLobby(id)


func _on_lobby_joined(id, permissions, locked, response):
	if !is_joining:
		return

	lobby_id = id

	peer = SteamMultiplayerPeer.new()
	peer.server_relay = true
	peer.create_client(Steam.getLobbyOwner(id))
	multiplayer.multiplayer_peer = peer

	multiplayer.peer_connected.connect(_player_connected)
	multiplayer.peer_disconnected.connect(_player_disconnected)

	_register_my_steam_info()

	is_joining = false


# ──────────────────────────────
# PLAYER SYNCING (SteamID → username)
# ──────────────────────────────
func _player_connected(peer_id):
	print("Peer connected:", peer_id)


func _player_disconnected(peer_id):
	if usernames.has(peer_id):
		usernames.erase(peer_id)
	_refresh_player_list()


@rpc("any_peer", "reliable")
func register_username(steam_id: int, name: String):
	var peer_id = multiplayer.get_remote_sender_id()
	usernames[peer_id] = name
	_refresh_player_list()


# Send OUR username to the host
func _register_my_steam_info():
	var my_id = Steam.getSteamID()
	var my_name = Steam.getFriendPersonaName(my_id)

	if multiplayer.is_server():
		register_username(my_id, my_name)
	else:
		rpc_id(1, "register_username", my_id, my_name) # host is peer 1


# Update the UI lobby list
func _refresh_player_list():
	for c in player_list.get_children():
		c.queue_free()

	for id in usernames.keys():
		var label = Label.new()
		label.text = usernames[id]
		player_list.add_child(label)


# ──────────────────────────────
# START GAME
# ──────────────────────────────
func _on_start_button_pressed():
	if !multiplayer.is_server():
		return

	start_game.rpc()


@rpc("reliable")
func start_game():
	print("START GAME RECEIVED. Disconnecting Steam Peer.")

	# Stop networking cleanly (required for SteamMultiplayerPeer)
	if multiplayer.multiplayer_peer:
		multiplayer.multiplayer_peer = null

	if peer:
		peer.close()

	# Now switch scenes safely
	call_deferred("_switch_to_game_scene")


func _switch_to_game_scene():
	print("Switching to game scene…")
	get_tree().change_scene_to_packed(game_scene)
