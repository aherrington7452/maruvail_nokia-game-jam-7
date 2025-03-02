extends Node2D

#region Set Up Variables

@onready var state_label: AnimatedSprite2D = $State/Bars
@onready var state_label_outline: AnimatedSprite2D = $State/ActiveOutline
@onready var work_cat_animation: AnimatedSprite2D = $WorkCat

@onready var work_timer: Timer = $WorkTimer
var work_bar_max_frames = 20 # 21 total
var work_timer_ongoing = false

@onready var sleep_timer: Timer = $SleepTimer
var sleep_bar_min_frames = 0
var sleep_timer_ongoing = false
var player_sleeping : bool  = false # Player forced to sleep until energy full

@onready var coffee_timer: Timer = $CoffeeTimer
var coffee_bar_min_frames = 0
var coffee_timer_ongoing = false

@onready var drain_energy_timer: Timer = $DrainEnergyTimer
var energy_max_frames = 18 # 19 total
var drain_energy_timer_ongoing : bool = false
var energy_drain_rate = 1 # must divide evenly into 18

@onready var drain_health_timer: Timer = $DrainHealthTimer
@onready var gain_health_timer: Timer = $GainHealthTimer
@onready var health_inner: AnimatedSprite2D = $HealthOutline/HealthInner
var health_max_frames = 11 # 12 total
var drain_health_timer_ongoing : bool = false
var health_drain_rate = 1 # must divide evenly into 11, so only 1 is viable
var gain_health_timer_ongoing : bool = false
var health_gain_rate = 1 # must divide evenly into 11, so only 1 is viable

@onready var clock: AnimatedSprite2D = $Clock

#dictionaries
var State = { "Work": 0, "Coffee": 1, "Sleep": 2 }
var StateValue = { "Work": 0, "Energy": 0, "Health": 0 } # value = frame of animation

var current_state
var current_selection_state 
#endregion

func _ready():
	current_state = State["Work"]
	current_selection_state = State["Work"]

func _process(_delta) -> void:
	player_input()
	gain_health()
	drain_health()
	drain_energy()
	update_bar_progress()

	# animate based on state
	health_animation()
	label_animation()
	cat_animation()

func gain_health():
	if current_state == State.Sleep:
		if gain_health_timer_ongoing == false:
			gain_health_timer_ongoing = true
			gain_health_timer.start(gain_health_timer.wait_time)

func drain_health():
	if current_state == State.Work:
		if drain_health_timer_ongoing == false:
			drain_health_timer_ongoing = true
			drain_health_timer.start(drain_health_timer.wait_time)
	elif current_state == State.Coffee:
		if drain_health_timer_ongoing == false:
			drain_health_timer_ongoing = true
			drain_health_timer.start(drain_health_timer.wait_time)

func health_animation():
	health_inner.frame = StateValue["Health"]
	if StateValue["Health"] == health_max_frames:
		pass #TODO end game by BURNOUT

func drain_energy():
	if current_state == State.Work:
		if drain_energy_timer_ongoing == false:
			drain_energy_timer_ongoing = true
			drain_energy_timer.start(drain_energy_timer.wait_time)

func player_input():
	# cycle through states
	if Input.is_action_just_pressed("move_up"):
		if current_selection_state < 2:
			current_selection_state += 1
		elif current_selection_state == 2:
			current_selection_state = 0
	if Input.is_action_just_pressed("move_down"):
		if current_selection_state > 0:
			current_selection_state -= 1
		elif current_selection_state == 0:
			current_selection_state = 2
	if player_sleeping == false:
		if Input.is_action_just_pressed("interact"):
			current_state = current_selection_state
			if current_state == State.Sleep:
				player_sleeping = true
	else: #if player is sleeping
		current_state = State.Sleep

func update_bar_progress():
	if current_state == State.Work:
		#If energy is drained, can't work, forced to sleep
		if StateValue["Energy"] == energy_max_frames:
			player_sleeping = true
		else:
			#pause all other bar timers, resume draining energy
			drain_energy_timer.paused = false
			gain_health_timer.paused = true
			coffee_timer.paused = true
			sleep_timer.paused = true
			work_timer.paused = false
			if work_timer_ongoing == false:
				#get timer and start it
				work_timer_ongoing = true
				work_timer.start(work_timer.wait_time)
	if current_state == State.Coffee:
		drain_energy_timer.paused = true
		gain_health_timer.paused = true
		work_timer.paused = true
		sleep_timer.paused = true
		coffee_timer.paused = false
		if coffee_timer_ongoing == false:
			#get timer and start it
			coffee_timer_ongoing = true
			coffee_timer.start(coffee_timer.wait_time)
	if current_state == State.Sleep:
		# If energy is full, player is no longer forced to sleep
		if StateValue["Energy"] == sleep_bar_min_frames:
			player_sleeping = false
		drain_energy_timer.paused = true
		gain_health_timer.paused = false
		work_timer.paused = true
		coffee_timer.paused = true
		sleep_timer.paused = false
		if sleep_timer_ongoing == false:
			#get timer and start it
			sleep_timer_ongoing = true
			sleep_timer.start(sleep_timer.wait_time)

func label_animation():
	if current_selection_state == State.Work:
		state_label.play("work")
		state_label.frame = StateValue["Work"]
		if current_state == State.Work:
			state_label_outline.play("active")
		else:
			state_label_outline.play("inactive")
	elif current_selection_state == State.Coffee:
		state_label.play("coffee")
		state_label.frame = StateValue["Energy"]
		if current_state == State.Coffee:
			state_label_outline.play("active")
		else:
			state_label_outline.play("inactive")
	elif current_selection_state == State.Sleep:
		state_label.play("sleep")
		state_label.frame = StateValue["Energy"]
		if current_state == State.Sleep:
			state_label_outline.play("active")
		else:
			state_label_outline.play("inactive")

func cat_animation():
	if current_state == State.Work:
		work_cat_animation.play("work")
	elif current_state == State.Coffee:
		work_cat_animation.play("coffee")
	elif current_state == State.Sleep:
		work_cat_animation.play("sleep")

func _on_clock_timer_timeout() -> void:
	clock.frame += 1

func _on_work_timer_timeout() -> void:
	work_timer_ongoing = false
	if StateValue["Work"] < work_bar_max_frames:
		StateValue["Work"] += 1
	else:
		StateValue["Work"] = work_bar_max_frames

func _on_coffee_timer_timeout() -> void:
	coffee_timer_ongoing = false
	if StateValue["Energy"] > coffee_bar_min_frames:
		StateValue["Energy"] -= 1
	else:
		StateValue["Energy"] = coffee_bar_min_frames

func _on_sleep_timer_timeout() -> void:
	sleep_timer_ongoing = false
	if StateValue["Energy"] > sleep_bar_min_frames:
		StateValue["Energy"] -= 1
	else:
		StateValue["Energy"] = sleep_bar_min_frames

func _on_drain_energy_timer_timeout() -> void:
	drain_energy_timer_ongoing = false
	if StateValue["Energy"] < energy_max_frames:
		StateValue["Energy"] += energy_drain_rate

func _on_drain_health_timer_timeout() -> void:
	drain_health_timer_ongoing = false
	# The if-block is unnecessary but it leaves open the option to have
	#work and coffee drain health at different rates
	if current_state == State.Work:
		if StateValue["Health"] < health_max_frames:
			StateValue["Health"] += health_drain_rate
	elif current_state == State.Coffee:
		if StateValue["Health"] < health_max_frames:
			StateValue["Health"] += health_drain_rate

func _on_gain_health_timer_timeout() -> void:
	gain_health_timer_ongoing = false
	if StateValue["Health"] < health_max_frames:
			StateValue["Health"] -= health_drain_rate
