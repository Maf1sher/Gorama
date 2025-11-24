extends GutTest

var _stats: EntityStats

func before_each():
	_stats = EntityStats.new()

func test_default_hp_is_100():
	assert_eq(_stats.hp, 100)

func test_hp_setter_clamps_to_max_hp():
	_stats.max_hp = 50
	_stats.hp = 200
	assert_eq(_stats.hp, 50)

func test_hp_setter_allows_any_value_if_max_hp_zero():
	_stats.max_hp = 0
	_stats.hp = 500
	assert_eq(_stats.hp, 500)

func test_hp_setter_emits_signal():
	var emitted = {}
	_stats.connect("stats_changed", func(n,v): emitted[n]=v)
	_stats.hp = 80
	assert_eq(emitted["hp"], 80)

func test_hp_setter_no_signal_when_unchanged():
	var counter = [0]
	_stats.connect("stats_changed", func(a,b): counter[0]+=1)
	_stats.hp = 50
	_stats.hp = 50
	assert_eq(counter[0], 1)

func test_health_depleted_reduces_hp_and_returns_damage_taken():
	_stats.hp = 100
	_stats.armor = 0
	var dmg = _stats.health_depleted(30)
	assert_eq(dmg, 30)
	assert_eq(_stats.hp, 70)

func test_health_depleted_with_armor_reduces_damage():
	_stats.hp = 100
	_stats.armor = 70
	var dmg = _stats.health_depleted(100)
	assert_true(dmg < 100)
	assert_eq(_stats.hp, 100 - dmg)

func test_health_depleted_hp_never_below_zero():
	_stats.hp = 10
	_stats.armor = 0
	var dmg = _stats.health_depleted(999)
	assert_eq(_stats.hp, 0)
	assert_true(dmg >= 10)

func test_apply_life_steal_accumulates_fractional():
	_stats.hp = 50
	_stats.life_steal_percent = 10
	_stats.apply_life_steal(5)
	assert_eq(_stats.life_steal_counter, 0.5)
	assert_eq(_stats.hp, 50)

func test_apply_life_steal_applies_when_counter_reaches_one():
	_stats.hp = 50
	_stats.life_steal_percent = 50
	_stats.apply_life_steal(2)
	assert_eq(_stats.hp, 51)
	assert_eq(_stats.life_steal_counter, 0.0)

func test_apply_life_steal_multiple_points():
	_stats.hp = 50
	_stats.life_steal_percent = 100
	_stats.apply_life_steal(3)
	assert_eq(_stats.hp, 53)
	assert_eq(_stats.life_steal_counter, 0.0)
