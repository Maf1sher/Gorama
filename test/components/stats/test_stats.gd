extends GutTest

var _stats: Stats

func before_each():
	_stats = Stats.new()

func test_default_values_are_zero():
	assert_eq(_stats.max_hp, 0)
	assert_eq(_stats.hp_regeneration, 0)
	assert_eq(_stats.attack_speed_percent, 0)
	assert_eq(_stats.crit_chance_percent, 0)
	assert_eq(_stats.crit_damage_percent, 0)
	assert_eq(_stats.armor, 0)
	assert_eq(_stats.movement_speed, 0)
	assert_eq(_stats.life_steal_percent, 0)

func test_setting_stat_changes_value():
	_stats.max_hp = 100
	assert_eq(_stats.max_hp, 100)

func test_signal_is_emitted_on_change():
	watch_signals(_stats)
	
	_stats.armor = 50
	
	assert_signal_emitted(_stats, "stats_changed")
	
	var expected_args = ["armor", 50]
	assert_signal_emitted_with_parameters(_stats, "stats_changed", expected_args)

func test_crit_chance_is_capped_at_100():
	_stats.crit_chance_percent = 150
	
	assert_eq(_stats.crit_chance_percent, 100)
	
	_stats.crit_chance_percent = 50
	assert_eq(_stats.crit_chance_percent, 50)

func test_add_stats_sums_values_correctly():
	var sword_stats = Stats.new()
	sword_stats.max_hp = 20
	sword_stats.attack_speed_percent = 10
	
	_stats.max_hp = 100
	_stats.attack_speed_percent = 5
	
	_stats.add_stats(sword_stats)
	
	assert_eq(_stats.max_hp, 120)
	assert_eq(_stats.attack_speed_percent, 15)
	assert_eq(_stats.armor, 0)

func test_remove_stats_subtracts_values_correctly():
	_stats.max_hp = 100
	_stats.movement_speed = 300
	
	var boots_stats = Stats.new()
	boots_stats.movement_speed = 50
	
	_stats.remove_stats(boots_stats)
	
	assert_eq(_stats.movement_speed, 250)
	assert_eq(_stats.max_hp, 100)

func test_get_modified_stats_returns_only_non_zero():
	_stats.max_hp = 500
	_stats.life_steal_percent = 10
	
	var result_dict = _stats.get_modified_stats()
	
	assert_eq(result_dict.size(), 2)
	assert_true(result_dict.has("max_hp"))
	assert_true(result_dict.has("life_steal_percent"))
	assert_false(result_dict.has("armor"))
	
	assert_eq(result_dict["max_hp"], 500)

func test_add_stats_triggers_signals():
	watch_signals(_stats)
	
	var buff = Stats.new()
	buff.armor = 10
	
	_stats.add_stats(buff)
	
	assert_signal_emitted_with_parameters(_stats, "stats_changed", ["armor", 10])
	
func test_setters_emit_signal():
	var emitted = {}
	_stats.connect("stats_changed", func(n,v): emitted[n]=v)
	_stats.max_hp = 10
	_stats.hp_regeneration = 5
	_stats.attack_speed_percent = 3
	_stats.crit_chance_percent = 20
	_stats.crit_damage_percent = 40
	_stats.armor = 2
	_stats.movement_speed = 8
	_stats.life_steal_percent = 1
	assert_eq(emitted["max_hp"], 10)
	assert_eq(emitted["hp_regeneration"], 5)
	assert_eq(emitted["attack_speed_percent"], 3)
	assert_eq(emitted["crit_chance_percent"], 20)
	assert_eq(emitted["crit_damage_percent"], 40)
	assert_eq(emitted["armor"], 2)
	assert_eq(emitted["movement_speed"], 8)
	assert_eq(emitted["life_steal_percent"], 1)

func test_no_signal_when_value_unchanged():
	var counter = [0]
	_stats.connect("stats_changed", func(a,b): counter[0] += 1)
	_stats.max_hp = 5
	_stats.max_hp = 5
	assert_eq(counter[0], 1)

func test_crit_chance_clamped():
	_stats.crit_chance_percent = 200
	assert_eq(_stats.crit_chance_percent, 100)

func test_get_stat_names():
	assert_true("max_hp" in _stats.get_stat_names())
	assert_eq(_stats.get_stat_names().size(), 8)

func test_add_stats():
	var other = Stats.new()
	_stats.max_hp = 10
	_stats.attack_speed_percent = 5
	other.max_hp = 3
	other.attack_speed_percent = 2
	_stats.add_stats(other)
	assert_eq(_stats.max_hp, 13)
	assert_eq(_stats.attack_speed_percent, 7)

func test_add_stats_ignores_zero():
	var other = Stats.new()
	_stats.max_hp = 10
	_stats.attack_speed_percent = 5
	other.max_hp = 0
	other.attack_speed_percent = 0
	_stats.add_stats(other)
	assert_eq(_stats.max_hp, 10)
	assert_eq(_stats.attack_speed_percent, 5)

func test_remove_stats():
	var other = Stats.new()
	_stats.max_hp = 10
	_stats.attack_speed_percent = 5
	other.max_hp = 3
	other.attack_speed_percent = 2
	_stats.remove_stats(other)
	assert_eq(_stats.max_hp, 7)
	assert_eq(_stats.attack_speed_percent, 3)

func test_remove_stats_ignores_zero():
	var other = Stats.new()
	_stats.max_hp = 10
	_stats.attack_speed_percent = 5
	other.max_hp = 0
	other.attack_speed_percent = 0
	_stats.remove_stats(other)
	assert_eq(_stats.max_hp, 10)
	assert_eq(_stats.attack_speed_percent, 5)

func test_get_modified_stats():
	_stats.max_hp = 10
	_stats.armor = 0
	_stats.crit_chance_percent = 5
	var result = _stats.get_modified_stats()
	assert_eq(result["max_hp"], 10)
	assert_eq(result["crit_chance_percent"], 5)
	assert_false("armor" in result)
