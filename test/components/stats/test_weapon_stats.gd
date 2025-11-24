extends GutTest

var _stats: WeaponStats

func before_each():
	_stats = WeaponStats.new()

func test_default_values():
	assert_eq(_stats.damage, 1)
	assert_eq(_stats.damage_percent, 0)
	assert_eq(_stats.type, ItemTypes.Type.WEAPON)

func test_inherited_defaults():
	assert_eq(_stats.max_hp, 0)
	assert_eq(_stats.hp_regeneration, 0)
	assert_eq(_stats.attack_speed_percent, 0)
	assert_eq(_stats.crit_chance_percent, 0)
	assert_eq(_stats.crit_damage_percent, 0)
	assert_eq(_stats.armor, 0)
	assert_eq(_stats.movement_speed, 0)
	assert_eq(_stats.life_steal_percent, 0)

func test_weapon_stat_setters_emit_signal():
	var emitted = {}
	_stats.connect("stats_changed", func(n,v): emitted[n]=v)
	_stats.damage = 10
	_stats.damage_percent = 20
	assert_eq(emitted["damage"], 10)
	assert_eq(emitted["damage_percent"], 20)

func test_get_stat_names_contains_all():
	var names = _stats.get_stat_names()
	assert_true("damage" in names)
	assert_true("damage_percent" in names)
	assert_true("type" in names)
	assert_true("max_hp" in names)
	assert_eq(names.size(), 11)

func test_calculate_damage():
	_stats.damage = 100
	_stats.damage_percent = 50
	assert_eq(_stats.calculate_damage(), 150)

func test_calculate_damage_zero_percent():
	_stats.damage = 40
	_stats.damage_percent = 0
	assert_eq(_stats.calculate_damage(), 40)

func test_calculate_damage_negative_percent():
	_stats.damage = 100
	_stats.damage_percent = -20
	assert_eq(_stats.calculate_damage(), 80)
