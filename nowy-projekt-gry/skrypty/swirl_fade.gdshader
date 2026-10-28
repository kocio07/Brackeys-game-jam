shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform float spiral_strength : hint_range(0.0, 50.0) = 15.0;
uniform vec4 cover_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
	vec2 uv = SCREEN_UV - vec2(0.5);
	
	float dist = length(uv);
	float angle = atan(uv.y, uv.x);
	
	float swirl = (1.0 - dist) * progress * spiral_strength;
	angle += swirl;
	
	vec2 rotated_uv = vec2(cos(angle), sin(angle)) * dist + vec2(0.5);
	
	vec4 screen_color = texture(SCREEN_TEXTURE, rotated_uv);
	
	float radius = (1.0 - progress) * 0.8;
	float circle = step(radius, dist);
	
	COLOR = mix(screen_color, cover_color, clamp(circle + progress * 0.5, 0.0, 1.0));
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
