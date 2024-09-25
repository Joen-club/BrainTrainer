extends Node

var debug: bool = false

var database: Dictionary = {
	"Game_mode": null,
	"Score": null,
	"Date": null,
	"Time": null,
	"Accuracy": null,
	"Press_count": null
}

func gather_data(new_data: Dictionary):
	if debug: return
	for i in new_data.keys():
		if database[i] != null:
			breakpoint
			print_debug("Shoudn't have a value")
		database[i] = new_data[i]
	if database["Date"] == null:
		get_current_date_time()
	if database_ready():
		create_new_entry()

func get_current_date_time():
	var date_time = Time.get_datetime_dict_from_system()
	database["Date"] = str(date_time['year'])+ "-" + str(date_time['month']) +"-" + str(date_time['day'])
	database["Time"] = str(date_time['hour'])+":"+str(date_time['minute'])

func database_ready() -> bool:
	for i in database:
		if database[i] == null:
			return false
	return true

func create_new_entry():
	var file_path = "user://week1.csv"
	var is_new_file = not FileAccess.file_exists(file_path)
	var file: FileAccess

	if is_new_file:
	# The file doesn't exist; create it and write the header
		file = FileAccess.open(file_path, FileAccess.ModeFlags.WRITE)
		if not file:
			breakpoint
			print("Failed to create file for writing.")
			return
		# Write the header row
		file.store_line("Game_Mode,Score,Date,Time,Accuracy,Press_count")
		file.close()

	# Open/Re-open the existing file in READ_WRITE mode
	file = FileAccess.open(file_path, FileAccess.ModeFlags.READ_WRITE)
	if not file:
		breakpoint
		print("Failed to open file for appending.")
		return

	# Seek to the end of the file to append data
	file.seek_end()

	# Write the session data
	var data_line = "%s,%d,%s,%s,%.2f,%d" % [database["Game_mode"], database["Score"],
	database["Date"], database["Time"], database["Accuracy"], database["Press_count"]]
	file.store_line(data_line)

	file.close()
	
	clear_database()

func clear_database():
	for i in database:
		database[i] = null
	print(database)
