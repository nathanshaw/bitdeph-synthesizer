
varying lowp vec4 colorVarying;
varying lowp vec2 texcoord;

uniform sampler2D tex;

void main()
{
    gl_FragColor = colorVarying*texture2D(tex, texcoord);
}
