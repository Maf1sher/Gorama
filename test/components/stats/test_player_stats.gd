extends GutTest

var _stats: PlayerStats
var _gear: GearStats

func before_each():
	_stats = PlayerStats.new()
	_gear = GearStats.new()

func test_default_values():
	assert_eq(_stats.physical_damage, 10)
	assert_eq(_stats.magic_damage, 10)
	assert_eq(_stats.physical_damage_percent, 0)
	assert_eq(_stats.magic_damage_percent, 0)
	assert_eq(_stats.hp, 100)

func test_inherited_defaults():
	assert_eq(_stats.max_hp, 0)
	assert_eq(_stats.crit_chance_percent, 0)
	assert_eq(_stats.crit_damage_percent, 0)

func test_stat_setters_emit_signal():
	var emitted = {}
	_stats.connect("stats_changed", func(n,v): emitted[n]=v)
	_stats.physical_damage = 20
	_stats.magic_damage = 30
	_stats.physical_damage_percent = 50
	_stats.magic_damage_percent = 25
	assert_eq(emitted["physical_damage"], 20)
	assert_eq(emitted["magic_damage"], 30)
	assert_eq(emitted["physical_damage_percent"], 50)
	assert_eq(emitted["magic_damage_percent"], 25)

func test_no_signal_when_value_unchanged():
	var counter = [0]
	_stats.connect("stats_changed", func(a,b): counter[0]+=1)
	_stats.physical_damage = 5
	_stats.physical_damage = 5
	assert_eq(counter[0], 1)

func test_calculate_physical_damage_no_crit():
	_stats.physical_damage = 20
	_stats.physical_damage_percent = 50
	_stats.crit_chance_percent = 0
	_stats.crit_damage_percent = 200
	var result = _stats.calculate_physical_damage()
	assert_eq(result, 30)

func test_calculate_physical_damage_with_crit():
	_stats.physical_damage = 20
	_stats.physical_damage_percent = 50
	_stats.crit_chance_percent = 100
	_stats.crit_damage_percent = 200
	var result = _stats.calculate_physical_damage()
	assert_eq(result, 60)

func test_calculate_magic_damage_no_crit():
	_stats.magic_damage = 20
	_stats.magic_damage_percent = 50
	_stats.crit_chance_percent = 0
	_stats.crit_damage_percent = 200
	var result = _stats.calculate_magic_damage()
	assert_eq(result, 30)

func test_calculate_magic_damage_with_crit():
	_stats.magic_damage = 20
	_stats.magic_damage_percent = 50
	_stats.crit_chance_percent = 100
	_stats.crit_damage_percent = 200
	var result = _stats.calculate_magic_damage()
	assert_eq(result, 60)

func test_set_max_hp_sets_hp_to_max_hp():
	_stats.max_hp = 150
	_stats.set_max_hp()
	assert_eq(_stats.hp, 150)

func test_add_gear_stats_adds_values():
	_gear.physical_damage = 5
	_gear.magic_damage = 10
	_gear.physical_damage_percent = 50
	_gear.magic_damage_percent = 25
	_stats.add_gear_stats(_gear)
	assert_eq(_stats.physical_damage, 15)
	assert_eq(_stats.magic_damage, 20)
	assert_eq(_stats.physical_damage_percent, 50)
	assert_eq(_stats.magic_damage_percent, 25)

func test_remove_gear_stats_subtracts_values():
	_gear.physical_damage = 5
	_gear.magic_damage = 10
	_gear.physical_damage_percent = 50
	_gear.magic_damage_percent = 25
	_stats.add_gear_stats(_gear)
	_stats.remove_gear_stats(_gear)
	assert_eq(_stats.physical_damage, 10)
	assert_eq(_stats.magic_damage, 10)
	assert_eq(_stats.physical_damage_percent, 0)
	assert_eq(_stats.magic_damage_percent, 0)
