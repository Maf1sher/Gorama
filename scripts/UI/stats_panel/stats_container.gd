extends VBoxContainer

@onready var physical_damage = $PhysicalDamage
@onready var magic_damage =$MagicDamage
@onready var physical_damage_percent =$PhysicalDamagePercent
@onready var magic_damage_percent = $MagicDamagePercent
@onready var max_hp = $MaxHP
@onready var hp_regeneration = $HPRegeneration
@onready var attack_speed_percent = $AttackSpeedPercent
@onready var crit_chance_percent = $CritChancePercent
@onready var crit_damage_percent = $CritDamagePercent
@onready var armor = $Armor
@onready var movement_speed = $MovmentSpeed
@onready var life_steal_percent = $LifeStealPercent

func change_stats(stats: PlayerStats) -> void:
	physical_damage.set_value(stats.physical_damage)
	magic_damage.set_value(stats.magic_damage)
	physical_damage_percent.set_value(stats.physical_damage_percent)
	magic_damage_percent.set_value(stats.magic_damage_percent)
	max_hp.set_value(stats.max_hp)
	hp_regeneration.set_value(stats.hp_regeneration)
	attack_speed_percent.set_value(stats.attack_speed_percent)
	crit_chance_percent.set_value(stats.crit_chance_percent)
	crit_damage_percent.set_value(stats.crit_damage_percent)
	armor.set_value(stats.armor)
	movement_speed.set_value(stats.movement_speed)
	life_steal_percent.set_value(stats.life_steal_percent)
	
