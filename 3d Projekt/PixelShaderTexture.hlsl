cbuffer lightBuffer
{
	float4 lightPosition;
	float4 lightColor;
	float intensity;


};

SamplerState SampleType; //modifies how the pixels are written to the polygon face when shaded
Texture2D shaderTexture;


struct PS_IN
{
	float4 pos : SV_POSITION;
	float2 Texture : TEXCOORD0;
	float3 normal : NORMAL;
	float4 wPos: WORLDPOS;
	float3 camPos : CAMERAPOS;

};


float4 PS_main(PS_IN input) : SV_TARGET
{

 //The light ray from the vert position to the light
//normalized to be used as a direction vector
float3 vRay = normalize((float3)(lightPosition - input.wPos));

//create a ray from the vert pos to the camera.
float3 v = normalize(input.camPos - input.wPos.xyz);

//Reflect is used in the specular shading
float3 r = reflect(-vRay, normalize(input.normal));

//Calculate how much of the pixel is to be lit
float fDot = max(0.0f, dot(normalize(vRay), normalize(input.normal)));

float3 color = lightColor.xyz;

float3 lightColor = mul(color, intensity);

float shinyPower = 20.0f;

float3 specularLight = { lightColor.xyz * pow(max(dot(r,v),0.0),shinyPower) };

float3 textureSample = shaderTexture.Sample(SampleType, input.Texture).xyz;
float3 diffuse = textureSample * fDot;

float3 ambient = { 0.1f, 0.1f, 0.1f };

ambient = (color *ambient);
diffuse = diffuse * lightColor;

float x = input.Texture.x;
if (x < 0)
{
	x = x * -1;
}
float y = input.Texture.y;

if (y < 0)
{
	y = y * -1;
}
float4 col = {x,y,0.1,1.0 }; //{ (ambient + diffuse + specularLight),1.0 };

return col;
}