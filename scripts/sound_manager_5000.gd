extends Node


var basic_button_sfx: FmodEventEmitter3D = null
var menu_open_sfx: FmodEventEmitter3D = null
var menu_close_sfx: FmodEventEmitter3D = null
var laser_basic_sfx: FmodEventEmitter3D = null
var laser_triple_sfx: FmodEventEmitter3D = null
var asteroid_hit_sfx: FmodEventEmitter3D = null
var asteroid_destroyed_sfx: FmodEventEmitter3D = null
var shield_static_sfx: FmodEventEmitter3D = null
var shield_crack_sfx: FmodEventEmitter3D = null
var shield_dest_sfx: FmodEventEmitter3D = null
var railgun_sfx: FmodEventEmitter3D = null
var ship_dest_sfx: FmodEventEmitter3D = null
var buy_button_sfx: FmodEventEmitter3D = null
var error_button: FmodEventEmitter3D = null
var mission_accept_sfx: FmodEventEmitter3D = null
var mission_complete_sfx: FmodEventEmitter3D = null
var news_jingle_short: FmodEventEmitter3D = null
var news_jingle_long: FmodEventEmitter3D = null
@onready var railgun_charge_sfx: FmodEventEmitter3D = $RailGunCharge
@onready var railgun_shot_sfx: FmodEventEmitter3D = $RailGunShot
@onready var active_shield_sfx: FmodEventEmitter3D = $ActiveShield
@onready var realgun_charge_sfx: FmodEventEmitter3D = $DieEchteCharge
@onready var realgun_shot_sfx: FmodEventEmitter3D = $DieEchteShot

@onready var music_ocean_planet: FmodEventEmitter3D = $OceanMusic
@onready var music_ant_planet: FmodEventEmitter3D = $AntMusic
@onready var music_crystal_planet: FmodEventEmitter3D = $CrystalMusic
@onready var music_station: FmodEventEmitter3D = $StationMusic
@onready var music_gamestart: FmodEventEmitter3D = $StartScreenMusic
@onready var music_gameend: FmodEventEmitter3D = $DeathMusic
@onready var music_contract: FmodEventEmitter3D = $ContractMusic
@onready var music_ambience: FmodEventEmitter3D = $SpaceAmbience

func _ready():
	init()
	
	
func init():
	basic_button_sfx = $BasicButton
	menu_open_sfx = $OpenMenuButton
	menu_close_sfx = $CloseMenuButton
	laser_basic_sfx = $LaserBasic
	laser_triple_sfx = $LaserTriple
	asteroid_hit_sfx = $AsteroidHit
	asteroid_destroyed_sfx = $AsteroidDestroyed
	shield_static_sfx = $ShieldStatic
	shield_crack_sfx = $ShieldCrack
	shield_dest_sfx = $ShieldDestroyed
	ship_dest_sfx = $ShipDestroyed
	buy_button_sfx = $BuyButton
	error_button = $ErrorButton
	mission_accept_sfx = $MissionAccept
	mission_complete_sfx = $MissionComplete
	news_jingle_short = $NewsJingleShort
	news_jingle_long = $NewsJingleLong
	

	
func play_sound(sound: FmodEventEmitter3D):
	sound.play()
	
func play_sound_pos(node: Node, sound: FmodEventEmitter3D):
	sound.global_position = node.global_position
	sound.play()
