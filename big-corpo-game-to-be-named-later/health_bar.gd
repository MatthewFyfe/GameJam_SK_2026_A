extends TextureProgressBar

func set_max_health(mix: float) -> void:
	self.max_value = mix

func health_changed(change: float) -> void:
	self.value = change
