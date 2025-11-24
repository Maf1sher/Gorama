extends GutTest

var _stats: GearStats

func before_each():
	_stats = GearStats.new()

func test_default_values():
	assert_eq(_stats.physical_damage, 0)
	assert_eq(_stats.magic_damage, 0)
	assert_eq(_stats.physical_damage_percent, 0)
	assert_eq(_stats.magic_damage_percent, 0)

func test_inherited_defaults_are_zero():
	assert_eq(_stats.max_hp, 0)
	assert_eq(_stats.hp_regeneration, 0)
	assert_eq(_stats.attack_speed_percent, 0)
	assert_eq(_stats.crit_chance_percent, 0)
	assert_eq(_stats.crit_damage_percent, 0)
	assert_eq(_stats.armor, 0)
	assert_eq(_stats.movement_speed, 0)
	assert_eq(_stats.life_steal_percent, 0)

func test_gear_stat_setters_emit_signal():
	var emitted = {}
	_stats.connect("stats_changed", func(n,v): emitted[n] = v)
	_stats.physical_damage = 10
	_stats.magic_damage = 5
	_stats.physical_damage_percent = 12
	_stats.magic_damage_percent = 25
	assert_eq(emitted["physical_damage"], 10)
	assert_eq(emitted["magic_damage"], 5)
	assert_eq(emitted["physical_damage_percent"], 12)
	assert_eq(emitted["magic_damage_percent"], 25)

func test_no_signal_when_value_unchanged():
	var counter = [0]
	_stats.connect("stats_changed", func(a,b): counter[0] += 1)
	_stats.physical_damage = 10
	_stats.physical_damage = 10
	assert_eq(counter[0], 1)

func test_get_stat_names_contains_all():
	var names = _stats.get_stat_names()
	assert_true("physical_damage" in names)
	assert_true("magic_damage" in names)
	assert_true("physical_damage_percent" in names)
	assert_true("magic_damage_percent" in names)
	assert_true("max_hp" in names)
	assert_eq(names.size(), 12)
