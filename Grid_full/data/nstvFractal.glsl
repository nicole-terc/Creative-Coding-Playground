
uniform vec3      iResolution;     // image/buffer    The viewport resolution (z is pixel aspect ratio, usually 1.0)
uniform float     iTime;           // image/sound/buffer        Current time in seconds

// Based on kishimisu shader: https://www.shadertoy.com/view/mtyGWy


//https://iquilezles.org/articles/palettes/
vec3 palette( float t ) {
    vec3 a = vec3(0.5, 0.5, 0.5);
    vec3 b = vec3(0.5, 0.5, 0.5);
    vec3 c = vec3(1.0, 1.0, 1.0);
    vec3 d = vec3(0.50, 0.20, 0.25);

    return a + b*cos( 6.28318*(c*t+d) );
}


float sdBox( in vec2 p, in vec2 b )
{
    vec2 d = abs(p)-b;
    return length(max(d,0.0)) + min(max(d.x,d.y),0.0);
}


vec4 mainImage(in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = (fragCoord * 2.0 - iResolution.xy) / iResolution.y;
    vec2 uv0 = uv;
    vec3 finalColor = vec3(0.0);
    
    for(float i = 0.0; i< 4.0; i++){
        uv = fract(uv*2.0) - 0.5;
        
        //*
        //Circle
        float d = length(uv)* exp(-length(uv0));
        /*/
        //Square
        vec2 square = vec2(0.9,0.6);
        float d = sdBox(uv, square);
        //*/
        vec3 color = palette(length(uv0) + i + iTime*0.2);

        
        d = sin(d*8.0 + iTime*0.5)/8.0;
        d = abs(d);
        
        d = pow(0.003/d, 1.2);
        
        
        
        finalColor += color*d;
    }

    // Output to screen
    vec4 fragColor = vec4(finalColor,1.0);
    return fragColor;
}

void main(void) {
        gl_FragColor = mainImage(gl_FragCoord.xy);
}
