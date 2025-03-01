extends Node2D

@onready var state_label: AnimatedSprite2D = $State/Bars
@onready var state_label_outline: AnimatedSprite2D = $State/ActiveOutline
@onready var work_cat_animation: AnimatedSprite2D = $WorkCat

@onready var work_timer: Timer = $WorkTimer
var work_bar_max_frames = 20 # 21 total
var work_timer_ongoing = false
@onready var sleep_timer: Timer = $SleepTimer
var sleep_bar_max_frames = 18 # 19 total
var sleep_timer_ongoing = false
@onready var coffee_timer: Timer = $CoffeeTimer
var coffee_bar_max_frames = 18 # 19 total
var coffee_timer_ongoing = false

@onready var clock: AnimatedSprite2D = $Clock

#dictionary
var State = { "Work": 0, "Coffee": 1, "Sleep": 2 }
var StateValue = { "Work": 0, "Energy": 0, "Health": 0 } # value = frame of animation

var current_state
var current_selection_state

func _ready():
	current_state = State["Work"]
	current_selection_state = State["Work"]

func _process(_delta) -> void:
	player_input()
	update_bar_progress()

	# animate based on state
	label_animation()
	cat_animation()

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
	if Input.is_action_just_pressed("interact"):
		current_state = current_selection_state

func update_bar_progress():
	if current_state == State.Work:
		#pause all other bar timers
		coffee_timer.paused = true
		sleep_timer.paused = true
		work_timer.paused = false
		if work_timer_ongoing == false:
			#get timer and start it
			work_timer_ongoing = true

			work_timer.start(work_timer.wait_time)
	if current_state == State.Coffee:
		work_timer.paused = true
		sleep_timer.paused = true
		coffee_timer.paused = false
		if coffee_timer_ongoing == false:
			#get timer and start it
			coffee_timer_ongoing = true
			coffee_timer.start(coffee_timer.wait_time)
	if current_state == State.Sleep:
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
	if StateValue["Energy"] < coffee_bar_max_frames:
		StateValue["Energy"] += 1
	else:
		StateValue["Energy"] = coffee_bar_max_frames

func _on_sleep_timer_timeout() -> void:
	sleep_timer_ongoing = false
	if StateValue["Energy"] < sleep_bar_max_frames:
		StateValue["Energy"] += 1
	else:
		StateValue["Energy"] = sleep_bar_max_frames
