#version 330

in mediump vec2 ex_uv; // absolute u,v
flat in mediump vec2 wh;
flat in mediump vec2 corner;

uniform mediump mat4 ModelMatrix;
uniform mediump mat4 ViewMatrix;
uniform mediump mat4 ProjectionMatrix;

uniform mediump vec2 resolution;
uniform mediump float fov;
uniform mediump float yaw;
uniform mediump float pitch;
uniform mediump float roll;

const mediump float M_PI = 3.141592653589793;
const mediump float TWO_PI = 6.283185307179586;
const mediump float recoef = 0.9900990099009901;
const mediump vec3 offset = vec3(0.0, 0.0, 0.425);

out mediump float out_Color;

uniform sampler2D textureSampler;

mediump mat3 rotationMatrix(mediump vec3 euler)
{
    mediump vec3 se = sin(euler);
    mediump vec3 ce = cos(euler);
    return mat3(ce.y, 0, -se.y, 0, 1, 0, se.y, 0, ce.y) * mat3(1, 0, 0, 0, ce.x, se.x, 0, -se.x, ce.x) * mat3(ce.z, se.z, 0, -se.z, ce.z, 0, 0, 0, 1);
}

mediump vec3 toCartesian(mediump vec2 st)
{
    return normalize(vec3(st.x, st.y, 0.5 / tan(0.5 * radians(fov))));
}

mediump vec2 toFaces(mediump vec3 cartesianCoord)
{
    mediump vec2 st;
    if (abs(cartesianCoord.x) >= abs(cartesianCoord.y) && abs(cartesianCoord.x) >= abs(cartesianCoord.z)) {
        mediump float u = recoef * cartesianCoord.z / cartesianCoord.x;
        mediump float v = recoef * cartesianCoord.y / cartesianCoord.x;
        if (cartesianCoord.x < 0.0) {
            u = (5.0f - u) / 6.0f;
            v = (1.0f + v) / 4.0f;
            st = vec2(u, v);
        } else {
            u = (1.0f - u) / 6.0f;
            v = (1.0f - v) / 4.0f;
            st = vec2(u, v);
        }
    } else if (abs(cartesianCoord.y) >= abs(cartesianCoord.x) && abs(cartesianCoord.y) >= abs(cartesianCoord.z)) {
        mediump float u = recoef * cartesianCoord.x / cartesianCoord.y;
        mediump float v = recoef * cartesianCoord.z / cartesianCoord.y;
        if (cartesianCoord.y < 0.0) {
            mediump float x = (1.0f - v) / 6.0f;
            mediump float y = (3.0f - u) / 4.0f;
            st = vec2(x, y);
        } else {
            mediump float x = (5.0f - v) / 6.0f;
            mediump float y = (3.0f + u) / 4.0f;
            st = vec2(x, y);
        }
    } else if (abs(cartesianCoord.z) >= abs(cartesianCoord.x) && abs(cartesianCoord.z) >= abs(cartesianCoord.y)) {
        mediump float u = recoef * cartesianCoord.x / cartesianCoord.z;
        mediump float v = recoef * cartesianCoord.y / cartesianCoord.z;
        if (cartesianCoord.z < 0.0) {
            u = (3.0f + u) / 6.0f;
            v = (1.0f + v) / 4.0f;
            st = vec2(u, v);
        } else {
            mediump float x = (3.0f + v) / 6.0f;
            mediump float y = (3.0f + u) / 4.0f;
            st = vec2(x, y);
        }
    }
    return st;
}

void main(void)
{
    mediump vec2 sphericalCoord = gl_FragCoord.xy / resolution - vec2(0.5);
    sphericalCoord.y *= -1.0;
    mediump vec3 cartesianCoord = rotationMatrix(radians(vec3(-pitch, yaw + 180.0, roll))) * toCartesian(sphericalCoord) + offset;
    out_Color = texture(textureSampler, toFaces(cartesianCoord)).r;
}
