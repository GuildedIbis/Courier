shader_type canvas_item;

//uniform sampler2D screen_texture: hint_screen_texture;
uniform vec4 hurt_color: source_color = vec4(0.6,0.2,0.2,1.0);
uniform vec4 inv_color: source_color = vec4(0.67,0.59,0.16,1.0);
uniform vec4 shield_color: source_color = vec4(0.8,0.8,1.0,1.0);
uniform float blink_intensity = 0;
uniform bool is_hurt = false;
uniform bool is_invincible = false;
uniform bool is_shielded = false;


void fragment() {
	//Get Screen Color
	//vec4 screen_color = texture(screen_texture,SCREEN_UV);
	//Sample Sprite Color
	if (is_hurt == true){
		vec4 sprite_color = texture(TEXTURE,UV);
		sprite_color = mix(sprite_color,hurt_color,blink_intensity * sprite_color.a);
		COLOR = sprite_color;
	}
	if (is_invincible == true){
		vec4 sprite_color = texture(TEXTURE,UV);
		sprite_color = mix(sprite_color,inv_color,blink_intensity * sprite_color.a);
		COLOR = sprite_color;
	}
	if (is_shielded == true){
		vec4 sprite_color = texture(TEXTURE,UV);
		sprite_color = mix(sprite_color,shield_color,blink_intensity * sprite_color.a);
		COLOR = sprite_color;
	}
}
