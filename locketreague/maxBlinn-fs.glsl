#version 300 es

precision highp float;

in vec4 texCoord;
in vec4 shadow;
in vec4 worldNormal;
in vec4 worldPosition;
in vec4 modelPosition;

uniform struct{
    mat4 viewProjMatrix;
    vec3 position;
} camera;

uniform struct {
    sampler2D colorTexture;
    samplerCube envTexture;
    vec3 lightPos;
} material;

out vec4 fragmentColor;

vec3 shade(vec3 normal, vec3 lightDir, vec3 viewDir, vec3 powerDensity,
vec3 materialColor, vec3 specularColor, float shininess) {

    float cosa = clamp(dot(lightDir, normal), 0.0, 1.0);
    float cosb = clamp(dot(viewDir, normal), 0.0, 1.0);

    vec3 halfway = normalize(viewDir + lightDir);
    float cosDelta = clamp(dot(halfway, normal), 0.0, 1.0);

    return
    powerDensity * materialColor * cosa
    + powerDensity * specularColor * pow(cosDelta, shininess)
    * cosa / max(cosb, cosa);
}


void main(void) {
    vec3 normal = normalize(worldNormal.xyz);
    vec3 viewDir = camera.position - worldPosition.xyz;

    vec3 lightDir = normalize(material.lightPos - worldPosition.xyz);
    float cosa = clamp(dot(normal, lightDir), 0.0, 1.0);
    vec3 shading = shade(normal, lightDir, viewDir, vec3(1.0,1.0,1.0), vec3(1.0,1.0,1.0), vec3(1.0,1.0,1.0), 0.1);
    vec3 radiance = texture(material.colorTexture, texCoord.xy/texCoord.w).rgb * cosa * shading;

    //    vec3 radiance = vec3(0, 0,0);
    //    for (int iLight = 0; iLight < lights.length(); iLight++){
    ////        vec3 lightDir
    //    }

    fragmentColor = vec4(radiance, 1.0) * shadow;

    //    This is the old way of having a fixed shadow without diffusion
    //    fragmentColor = vec4(radiance, 1.0) * shadow;


    //    fragmentColor = vec4(cosa, cosa, cosa, 1);
    //    fragmentColor = texture(material.envTexture, rayDir.xyz);
}