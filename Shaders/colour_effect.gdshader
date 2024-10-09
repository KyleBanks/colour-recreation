shader_type spatial;

uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color, filter_linear_mipmap, repeat_enable;

// The number of active colour sources in the scene
global uniform int num_colour_sources;

// The maximum number of colour sources possible to have in a scene 
const int MAX_COLOUR_SOURCES = 5;

// For each colour_sources_*, xyz represents its position in global space and w represents its radius.
// Ideally these would be provided as a single array, however godot doesn't support global arrays :/ 
global uniform vec4 colour_sources_0; 
global uniform vec4 colour_sources_1; 
global uniform vec4 colour_sources_2; 
global uniform vec4 colour_sources_3; 
global uniform vec4 colour_sources_4; 

// The width of the edge effect, beyond the radius of colour sources
const float EDGE_WIDTH = 0.1;

// Returns the signed distance to a sphere.
// A sphere is defined as: xyz=position, w=radius
float sphere_sd(vec3 pos, vec4 sphere)
{
	return distance(pos, sphere.xyz) - sphere.w;
}

// Returns the signed distance of the nearest colour source
float colour_sd(vec3 pos)
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
		nearest_sd = min(nearest_sd, sphere_sd(pos, colour_sources_0));
	return nearest_sd;
}

varying vec3 position_global;

void vertex() 
{
	position_global = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
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
	float colour_sd = colour_sd(position_global);
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
