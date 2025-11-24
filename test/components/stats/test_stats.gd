extends GutTest

var _stats: Stats

func before_each():
	_stats = Stats.new()

func test_default_values_are_zero():
	assert_eq(_stats.max_hp, 0, "Default Max HP should be 0")
	assert_eq(_stats.attack_speed_percent, 0, "Default Attack Speed should be 0")
	assert_eq(_stats.crit_chance_percent, 0, "Default Crit Chance should be 0")

func test_setting_stat_changes_value():
	_stats.max_hp = 100
	assert_eq(_stats.max_hp, 100, "Max HP property should update correctly")

func test_signal_is_emitted_on_change():
	watch_signals(_stats)
	
	_stats.armor = 50
	
	assert_signal_emitted(_stats, "stats_changed", "Signal 'stats_changed' should be emitted")
	
	var expected_args = ["armor", 50]
	assert_signal_emitted_with_parameters(_stats, "stats_changed", expected_args)

func test_crit_chance_is_capped_at_100():
	_stats.crit_chance_percent = 150
	
	assert_eq(_stats.crit_chance_percent, 100, "Crit chance should be capped at 100%")
	
	_stats.crit_chance_percent = 50
	assert_eq(_stats.crit_chance_percent, 50, "Crit chance under 100% should be set correctly")

func test_add_stats_sums_values_correctly():
	var sword_stats = Stats.new()
	sword_stats.max_hp = 20
	sword_stats.attack_speed_percent = 10
	
	_stats.max_hp = 100
	_stats.attack_speed_percent = 5
	
	_stats.add_stats(sword_stats)
	
	assert_eq(_stats.max_hp, 120, "Max HP should be the sum of base and added stats (100 + 20)")
	assert_eq(_stats.attack_speed_percent, 15, "Attack Speed should sum up correctly (5 + 10)")
	assert_eq(_stats.armor, 0, "Armor should remain 0 as added stats had no armor")

func test_remove_stats_subtracts_values_correctly():
	_stats.max_hp = 100
	_stats.movement_speed = 300
	
	var boots_stats = Stats.new()
	boots_stats.movement_speed = 50
	
	_stats.remove_stats(boots_stats)
	
	assert_eq(_stats.movement_speed, 250, "Movement speed should decrease after removal (300 - 50)")
	assert_eq(_stats.max_hp, 100, "Max HP should remain unchanged")

func test_get_modified_stats_returns_only_non_zero():
	_stats.max_hp = 500
	_stats.life_steal_percent = 10
	
	var result_dict = _stats.get_modified_stats()
	
	assert_eq(result_dict.size(), 2, "Dictionary should only contain stats with non-zero values")
	assert_true(result_dict.has("max_hp"), "Dictionary should contain 'max_hp'")
	assert_true(result_dict.has("life_steal_percent"), "Dictionary should contain 'life_steal_percent'")
	assert_false(result_dict.has("armor"), "Dictionary should NOT contain zero-value stats (armor)")
	
	assert_eq(result_dict["max_hp"], 500, "Dictionary value for 'max_hp' is incorrect")

func test_add_stats_triggers_signals():
	watch_signals(_stats)
	
	var buff = Stats.new()
	buff.armor = 10
	
	_stats.add_stats(buff)
	
	assert_signal_emitted_with_parameters(_stats, "stats_changed", ["armor", 10])
