shader_type canvas_item;

//Check if sprite is behind something
uniform sampler2D screen_texture: hint_screen_texture;

//Silhouette Color
uniform vec4 silhouette_color: source_color = vec4(0.0,0.0,0.0,0.5);
uniform bool active = true;

void fragment() {
	//Get Screen Color
	vec4 screen_color = texture(screen_texture,SCREEN_UV);
	//Sample Sprite Color
	vec4 sprite_color = texture(TEXTURE,UV);
	//Check if sprite and screen match colors
	if (active == true)
	{
		if(all(lessThan(abs(sprite_color - screen_color), vec4(0.01))))
		{
			COLOR = sprite_color;
		}
		else
		{
			COLOR = vec4(silhouette_color.rgb,silhouette_color.a * sprite_color.a);
		}
	}
	else
	{
		COLOR = vec4(silhouette_color.rgb,0.0);
	}
}


