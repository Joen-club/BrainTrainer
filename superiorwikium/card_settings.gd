extends Settings

var seeds: Dictionary = {
	0: "Random",
	1: 1,
	2: 2,
	3: 3
}

func _ready() -> void:
	setting_dicts = {"Seed": seeds}
	super._ready()
