shader_type canvas_item;

uniform float glow_strength : hint_range(0.0, 3.0) = 10.0;

void fragment() {
    COLOR = texture(TEXTURE, UV);
    COLOR.rgb += glow_strength * (1.0 - COLOR.a); // brilho suave
}