//-----------------------------------------------------------------------------
// File: SkyBox11.hlsl
//
// Desc: 
// 
// Copyright (c) Microsoft Corporation. All rights reserved.
//-----------------------------------------------------------------------------

#define M_PI  (3.141592653589)
#define M_TAU (2.*M_PI)

cbuffer cbPerObject : register( b0 )
{
    row_major matrix    g_mWorldViewProjection	: packoffset( c0 );
}

Texture2D	g_EnvironmentTexture : register( t0 );
SamplerState g_sam : register( s0 );

struct SkyboxVS_Input
{
    float4 Pos : POSITION;
};

struct SkyboxVS_Output
{
    float4 Pos : SV_POSITION;
    float3 Tex : TEXCOORD0;
};

SkyboxVS_Output SkyboxVS( SkyboxVS_Input Input )
{
    SkyboxVS_Output Output;
    
    Output.Pos = Input.Pos;
    Output.Tex = normalize( mul(Input.Pos, g_mWorldViewProjection) );
    
    return Output;
}

float4 SkyboxPS( SkyboxVS_Output Input ) : SV_TARGET
{
	float th = atan2(Input.Tex.z, Input.Tex.x) / M_TAU;
	float r2 = length(float2(Input.Tex.z, Input.Tex.x));
	float2 tex;
	tex.x = th;
	tex.y = atan2(-Input.Tex.y,r2) / M_PI + .5;

	float4 color = g_EnvironmentTexture.Sample(g_sam, tex);
	return color;
}
