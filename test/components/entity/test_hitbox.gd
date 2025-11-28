extends GutTest

var _hitbox: HitBox

func before_each():
	_hitbox = HitBox.new()
	add_child_autofree(_hitbox)

func after_each():
	_hitbox = null

func test_initialization_defaults():
	assert_eq(_hitbox.damage, 1, "Default damage should be 1")

func test_set_get_damage():
	_hitbox.damage = 10
	assert_eq(_hitbox.damage, 10, "Damage property should be updated to 10")
	
	assert_eq(_hitbox.get_damage(), 10, "get_damage() should return 10")
	
	_hitbox.damage = 50
	assert_eq(_hitbox.damage, 50, "Damage should be updateable to 50")

func test_set_damage_negative():
	_hitbox.damage = -5
	assert_eq(_hitbox.damage, -5, "Damage should accept negative integers based on current logic")

func test_signal_defined():
	assert_has_signal(_hitbox, "hit_registered")

func test_signal_signature():
	watch_signals(_hitbox)
	
	_hitbox.hit_registered.emit(25)
	
	assert_signal_emitted_with_parameters(_hitbox, "hit_registered", [25])
