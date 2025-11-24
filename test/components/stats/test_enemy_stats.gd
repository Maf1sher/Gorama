extends GutTest

var _stats: EnemyStats

func before_each():
	_stats = EnemyStats.new()

func test_default_values():
	assert_eq(_stats.damage, 10)
	assert_eq(_stats.damage_percent, 0)

func test_inherited_defaults():
	assert_eq(_stats.hp, 100)
	assert_eq(_stats.max_hp, 0)
	assert_eq(_stats.crit_chance_percent, 0)
	assert_eq(_stats.crit_damage_percent, 0)

func test_damage_setter_emits_signal():
	var emitted = {}
	_stats.connect("stats_changed", func(n,v): emitted[n]=v)
	_stats.damage = 20
	_stats.damage_percent = 15
	assert_eq(emitted["damage"], 20)
	assert_eq(emitted["damage_percent"], 15)

func test_no_signal_when_value_unchanged():
	var counter = [0]
	_stats.connect("stats_changed", func(a,b): counter[0]+=1)
	_stats.damage = 5
	_stats.damage = 5
	assert_eq(counter[0], 1)

func test_calculate_damage_no_crit():
	_stats.damage = 20
	_stats.damage_percent = 50
	_stats.crit_chance_percent = 0
	_stats.crit_damage_percent = 200
	var result = _stats.calculate_damage()
	assert_eq(result, 30)

func test_calculate_damage_with_crit():
	_stats.damage = 20
	_stats.damage_percent = 50
	_stats.crit_chance_percent = 100
	_stats.crit_damage_percent = 200
	var result = _stats.calculate_damage()
	assert_eq(result, 60)

func test_calculate_damage_with_zero_damage_percent():
	_stats.damage = 10
	_stats.damage_percent = 0
	_stats.crit_chance_percent = 0
	_stats.crit_damage_percent = 200
	var result = _stats.calculate_damage()
	assert_eq(result, 10)
