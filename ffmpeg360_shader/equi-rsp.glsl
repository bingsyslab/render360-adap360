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

const mediump float M_PI = 3.141592653589793238462643;
const mediump float TWO_PI = 6.283185307179586476925286;

out mediump float out_Color;

uniform sampler2D textureSampler;

mediump mat3 rotationMatrix(mediump vec3 euler)
{
    mediump vec3 se = sin(euler);
    mediump vec3 ce = cos(euler);
    return mat3(ce.y, 0, -se.y, 0, 1, 0, se.y, 0, ce.y) * mat3(1, 0, 0, 0, ce.x, se.x, 0, -se.x, ce.x) * mat3(ce.z, se.z, 0, -se.z, ce.z, 0, 0, 0, 1);
}

mediump vec3 toCartesian(mediump vec2 st, mediump float flag)
{
    mediump vec3 ps = rotationMatrix(vec3(st.y, st.x, 0.0)) * vec3(0.0, 0.0, -1.0);
    if (flag == 1.0) return rotationMatrix(radians(vec3(pitch, yaw, -roll))) * ps;
    return rotationMatrix(radians(vec3(-pitch, yaw + 180.0, 90.0 + roll))) * ps;
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

void main(void)
{
    mediump float sp = (resolution.x / 3.0) / resolution.y;
    mediump vec2 sphericalCoord = gl_FragCoord.xy / resolution;
    mediump vec2 textureCoord;
    if (sphericalCoord.y < sp) {
        textureCoord.x = (sphericalCoord.x + 1.0 / 6.0) * 3.0 / 4.0 - 0.5;
        textureCoord.y = ((sp / 2.0) - sphericalCoord.y) / (sp * 2.0);
        textureCoord *= vec2(TWO_PI, M_PI);
        textureCoord = toSpherical(toCartesian(textureCoord, 1.0)) / vec2(TWO_PI, M_PI);
    }
    if (sphericalCoord.y >= sp) {
        sphericalCoord.x = (sphericalCoord.x + 1.0 / 6.0) * 3.0 / 4.0 - 0.5;
        sphericalCoord.y = ((sp + 1.0) / 2.0 - sphericalCoord.y) / ((1.0 - sp) * 2.0);
        sphericalCoord *= vec2(TWO_PI, M_PI);
        textureCoord = toSpherical(toCartesian(sphericalCoord, 0.0)) / vec2(TWO_PI, M_PI);
    }
    out_Color = texture(textureSampler, textureCoord).r;
}
