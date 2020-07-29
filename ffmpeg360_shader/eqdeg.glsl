#version 330

in mediump vec2 ex_uv; // absolute u,v
flat in mediump vec2 wh;
flat in mediump vec2 corner;

out mediump float out_Color;
uniform sampler2D textureSampler;

const mediump float PI = 3.14159265359;
const mediump float PI_2 = 1.57079632679;
const mediump float PI_4 = 0.78539816339;

void main(void)
{
    mediump vec2 uv;
    mediump vec2 ratio;
    ratio = (ex_uv - corner - wh / 2.0) / (wh / 2.0);
    ratio /= 1.01;
    uv = corner + tan(ratio * PI_4) * (wh / 2.0) + wh / 2.0;
    out_Color = texture(textureSampler, uv).r;
}
