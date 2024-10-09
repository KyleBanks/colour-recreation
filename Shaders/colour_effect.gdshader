shader_type spatial;

uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color, filter_linear_mipmap, repeat_enable;

// The number of active colour sources in the scene
global uniform int num_colour_sources;

// For each colour_source_*, the xyz components represent its position and w represents its radius
// TODO: figure out how to declare and provide global arrays in godot
const int MAX_COLOUR_SOURCES = 5;
global uniform vec4 colour_sources_0; 
global uniform vec4 colour_sources_1; 
global uniform vec4 colour_sources_2; 
global uniform vec4 colour_sources_3; 
global uniform vec4 colour_sources_4; 

const float EDGE_WIDTH = 0.1;

// Returns the signed distance of a sphere
// sphere is defined as: xyz=position, w=radius
float sphere_sd(vec3 pos, vec4 sphere)
{
	return distance(pos, sphere.xyz) - sphere.w;
}

// Returns the signed distance of the nearest colour source
float colour_sd(vec3 position_ws)
{
	vec4[5] colour_sources =
	{
		colour_sources_0,
		colour_sources_1,
		colour_sources_2,
		colour_sources_3,
		colour_sources_4
	};

	float nearest_sd = 99999999.0; 
	for (int i = 0; i < num_colour_sources; i++)
		nearest_sd = min(nearest_sd, sphere_sd(position_ws, colour_sources_0));
	return nearest_sd;
}

varying vec3 position_ws;

void vertex() 
{
	position_ws = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment()
{
	// Coloured shading
	vec4 albedo_tex = texture(texture_albedo, UV);
	vec3 coloured = albedo.rgb * albedo_tex.rgb;
	
	// Uncoloured shading
	float desaturated = (coloured.r + coloured.g + coloured.b) / 3.0;
	vec3 uncoloured = vec3(desaturated, desaturated, desaturated);
	
	// Determine if we're in colour, edge, or uncoloured
	float colour_sd = colour_sd(position_ws);
	if (colour_sd < 0.0)
	{
		ALBEDO = coloured;
	}
	else if (colour_sd < EDGE_WIDTH)
	{
		ALBEDO = vec3(1, 1, 1);
	}
	else
	{
		ALBEDO = uncoloured;
	}
}
