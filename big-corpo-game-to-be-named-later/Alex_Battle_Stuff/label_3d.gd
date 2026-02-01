extends Label3D

func Update(hp: float) -> void:
	self.text = "HP: " + String.num(round(hp * 10)/10)
