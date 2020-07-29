#version 330

in mediump vec2 ex_uv;
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

// vec2(2880.0, 1440.0)
// vec2(2880.0, 1600.0)
// vec2(2880.0, 1680.0)
const mediump vec2 i_wh = vec2(2880.0, 1440.0);
const mediump float M_PI = 3.141592653589793238462643;
const mediump float TWO_PI = 6.283185307179586476925286;

out mediump float out_Color;

uniform sampler2D textureSampler;

mediump mat3 rotationMatrix(mediump vec3 euler)
{
    mediump vec3 se = sin(euler);
    mediump vec3 ce = cos(euler);
    return mat3(ce.y, 0, -se.y, 0, 1, 0, se.y, 0, ce.y) * mat3(1, 0, 0, 0, ce.x, se.x, 0, -se.x, ce.x) * mat3(ce.z,  se.z, 0,-se.z, ce.z, 0, 0, 0, 1);
}

mediump vec3 toCartesian(mediump vec2 st)
{
    return normalize(vec3(st.x, st.y, 0.5 / tan(0.5 * radians(fov))));
}

mediump vec2 toSpherical(mediump vec3 cartesianCoord)
{
    mediump vec2 st = vec2(
        atan(cartesianCoord.x, cartesianCoord.z),
        acos(cartesianCoord.y)
        );
    if (st.x < 0.0)
        st.x += TWO_PI;
    return st;
}

mediump vec2 toBaseball(mediump vec3 ps, mediump float sp)
{
    mediump vec3 ps_rotate = rotationMatrix(radians(vec3(-pitch, yaw + 180.0, roll))) * ps;
    mediump vec2 st = toSpherical(ps_rotate);
    if (st.x >= TWO_PI * 0.125 && st.x <= TWO_PI * 0.875 && st.y >= M_PI * 0.25 && st.y <= M_PI * 0.75) {
        st.x = (st.x - TWO_PI * 0.125) / (TWO_PI * 0.75);
        st.y = ((st.y - M_PI * 0.25) / M_PI) * sp * 2.0;
        return st;
    }
    st = toSpherical(rotationMatrix(radians(vec3(0.0, 180.0, 90.0))) * ps_rotate);
    if (st.x >= TWO_PI * 0.125 && st.x <= TWO_PI * 0.875 && st.y >= M_PI * 0.25 && st.y <= M_PI * 0.75) {
        st.x = (st.x - TWO_PI * 0.125) / (TWO_PI * 0.75);
        st.y = (((st.y - M_PI * 0.25) / M_PI) * (1.0 - sp) * 2.0) + sp;
        return st;
    }
    return vec2(0.0);
}

void main(void)
{
    mediump vec2 sphericalCoord = gl_FragCoord.xy / resolution - vec2(0.5);
    sphericalCoord.y *= -resolution.y / resolution.x;
    mediump vec2 textureCoord = toBaseball(toCartesian(sphericalCoord), (i_wh.x * 0.33333333333333333333) / i_wh.y);
    out_Color = texture(textureSampler, textureCoord).r;
}
