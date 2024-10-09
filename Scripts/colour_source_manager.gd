extends Node3D

@export var _colour_sources: Array[ColourSource]

func _process(_delta: float) -> void:
	var num_colour_sources: int = _colour_sources.size()
	RenderingServer.global_shader_parameter_set("num_colour_sources", num_colour_sources)

	for i in range(0, num_colour_sources):
		var colour_source: ColourSource = _colour_sources[i]
		RenderingServer.global_shader_parameter_set("colour_sources_" + str(i), colour_source.packed())
		
