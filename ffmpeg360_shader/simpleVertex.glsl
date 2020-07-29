#version 330

layout(location = 0) in highp vec4 in_Position;
layout(location = 1) in highp vec2 in_uv;
layout(location = 2) in highp vec4 in_uvr; // corner coordinates and width and height

out highp vec2 ex_uv;
flat out highp vec2 corner;
flat out highp vec2 wh;

const mat4 view = mat4(
    1.0, 0.0, 0.0, 0.0,
    0.0, 1.0, 0.0, 0.0,
    0.0, 0.0, 1.0, 0.0,
    0.0, 0.0, 0.0, 1.0
    );

void main(void)
{
    gl_Position = in_Position;
    ex_uv = in_uv;
    wh = in_uvr.zw;
    corner = in_uvr.xy;
}
