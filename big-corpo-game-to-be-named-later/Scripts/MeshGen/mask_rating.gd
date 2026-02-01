extends Node

class_name MaskRating

var mask_ref1:Image = Image.new()
var mask_ref2:Image = Image.new()
var mask_ref3:Image = Image.new()
var mask_ref4:Image = Image.new()
var mask_ref5:Image = Image.new()
var mask_ref6:Image = Image.new()
var mask_ref7:Image = Image.new()
var mask_ref8:Image = Image.new()
var mask_ref9:Image = Image.new()
var mask_ref10:Image = Image.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mask_ref1.load("res://Textures/GMaks.png")
	mask_ref2.load("res://Textures/masks/mask1.png")
	mask_ref3.load("res://Textures/masks/mask2.png")
	mask_ref4.load("res://Textures/masks/mask3.png")
	mask_ref5.load("res://Textures/masks/mask4.png")
	mask_ref6.load("res://Textures/masks/mask5.png")
	mask_ref7.load("res://Textures/masks/mask6.png")
	mask_ref8.load("res://Textures/masks/mask7.png")
	mask_ref9.load("res://Textures/masks/mask8.png")
	mask_ref10.load("res://Textures/masks/mask9.png")

	
	pass # Replace with function body.

func rate_textures(mask:Image, depth:Image, color:Image) -> Array[float]:
	var metric:Array[float] = []
	#print(mask.compute_image_metrics(mask_ref,true)["peak_snr"])
	metric.append(mask.compute_image_metrics(mask_ref1,true)["mean"])
	metric.append(mask.compute_image_metrics(mask_ref2,true)["mean"])
	metric.append(mask.compute_image_metrics(mask_ref3,true)["mean"])
	metric.append(mask.compute_image_metrics(mask_ref4,true)["mean"])
	metric.append(mask.compute_image_metrics(mask_ref5,true)["mean"])
	metric.append(mask.compute_image_metrics(mask_ref6,true)["mean"])
	metric.append(mask.compute_image_metrics(mask_ref7,true)["mean"])
	metric.append(mask.compute_image_metrics(mask_ref8,true)["mean"])
	metric.append(mask.compute_image_metrics(mask_ref9,true)["mean"])
	metric.append(mask.compute_image_metrics(mask_ref10,true)["mean"])
	
	var red_amount:float = 20.0
	
	for x in range(255):
		for y in range(255):
			var p := color.get_pixel(x,y)
			if(p.r8 > 150 and p.g8 < 150 and p.b8 < 150):
				red_amount -= 20.0/(255*255)
	
	metric.append(red_amount)
	
	for i in range(metric.size()):
		metric[i] = absf(20.0-metric[i])
	print(metric)
	return metric;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
