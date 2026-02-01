extends Sprite2D

@export var KingTextBox : Label
var data
var timePassed = 0

func _process(delta):
	timePassed += delta
		
	if(timePassed > 0):
		get_bark()
		timePassed = randf_range(-3.5, -3.0)

func get_bark():
	#skip Bark 0,1 it is the title, rest are fine
	var barkToGrab = (randi() % 100) + 2
	
	var attributeList = ["Mirth", "Perspicacity", "Historical Materialism", "Misanthropy", "Equine", "Green", "Kitsch", "Mercator", "Fatherhood", "Appropriation", "Intelligence", "Girth", "Chutzpah", "Marketability", "Misnomer"]
	
	var attribute = attributeList[randi() % 14]
	var attribute2 = attributeList[randi() % 14]
	
	#replace XXX with an attribute
	var finalString: String = data[barkToGrab][0]
	finalString = finalString.replace("XXX", attribute)
	finalString = finalString.replace("YYY", attribute2)
	
	#print(finalString)
	KingTextBox.text = finalString

func _ready():
	var file_path = "res://Text/GameJamTextSheet-KingMaskBarks.csv"  # Change to your CSV file path
	data = read_csv(file_path)
	
	if data.size() > 0:
		print("CSV Data Loaded:")
		for row in data:
			print(row)
	else:
		print("No data loaded or file not found.")
		
	get_bark()

# Reads a CSV file and returns an array of rows (each row is an array of strings)
func read_csv(path: String, delimiter: String = ",") -> Array:
	var result: Array = []
	var file: FileAccess

	# Try opening the file
	file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Failed to open file: %s" % path)
		return result

	# Read each line as CSV
	while not file.eof_reached():
		var row: Array = file.get_csv_line(delimiter)
		if row.size() > 0 and not (row.size() == 1 and row[0] == ""):
			result.append(row)

	file.close()
	return result
	
