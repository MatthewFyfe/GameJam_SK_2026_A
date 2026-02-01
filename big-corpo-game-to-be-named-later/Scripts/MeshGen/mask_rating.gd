extends Node

class_name MaskRating

var masks: Array[Image] = []

func _ready() -> void:
	var paths := [
		"res://Textures/GMaks.png",
		"res://Textures/masks/mask1.png",
		"res://Textures/masks/mask2.png",
		"res://Textures/masks/mask3.png",
		"res://Textures/masks/mask4.png",
		"res://Textures/masks/mask5.png",
		"res://Textures/masks/mask6.png",
		"res://Textures/masks/mask7.png",
		"res://Textures/masks/mask8.png",
		"res://Textures/masks/mask9.png",
	]

	for path in paths:
		var tex := load(path) as Texture2D
		if tex:
			masks.append(tex.get_image())

	
	pass # Replace with function body.

func rate_textures(mask:Image, depth:Image, color:Image) -> Array[float]:
	var metric:Array[float] = []
	#print(mask.compute_image_metrics(mask_ref,true)["peak_snr"])
	metric.append(mask.compute_image_metrics(masks[0],true)["mean"])
	metric.append(mask.compute_image_metrics(masks[1],true)["mean"])
	metric.append(mask.compute_image_metrics(masks[2],true)["mean"])
	metric.append(mask.compute_image_metrics(masks[3],true)["mean"])
	metric.append(mask.compute_image_metrics(masks[4],true)["mean"])
	metric.append(mask.compute_image_metrics(masks[5],true)["mean"])
	metric.append(mask.compute_image_metrics(masks[6],true)["mean"])
	metric.append(mask.compute_image_metrics(masks[7],true)["mean"])
	metric.append(mask.compute_image_metrics(masks[8],true)["mean"])
	metric.append(mask.compute_image_metrics(masks[9],true)["mean"])
	
	
	var red_amount:float = 20.0
	
	for x in range(255):
		for y in range(255):
			var p := color.get_pixel(x,y)
			if(p.r8 > 150 and p.g8 < 150 and p.b8 < 150):
				red_amount -= 20.0/(255*255)
	
	metric.append(red_amount)
	
	for i in range(metric.size()):
		metric[i] = absf(20.0-metric[i])/20.0
	print(metric)
	return metric;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
