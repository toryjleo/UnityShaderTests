﻿Shader "Custom/AnimatedCellShader" {

	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_MousePos("MousePos", Vector) = (1,1,1,1)
		_Color("Color", Color) = (0.2, 0.90980, 0.83529, 1)
		_Scale("Scale", Float) = 6
	}
		SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
	{
		CGPROGRAM
#pragma vertex vert
#pragma fragment frag

#include "UnityCG.cginc"

		struct appdata
	{
		float4 vertex : POSITION;
		float2 uv : TEXCOORD0;
	};

	struct v2f
	{
		float2 uv : TEXCOORD0;
		float4 vertex : SV_POSITION;
	};

	// Uniforms
	sampler2D _MainTex;
	float4 _MousePos;
	float4 _Color;
	float _Scale;

	
	float2 random2( float2 p) 
	{
		return frac(sin(float2(dot(p, float2(127.1, 311.7)), dot(p, float2(269.5, 183.3))))*43758.5453);
	}


	v2f vert(appdata v)
	{
		v2f o;
		o.vertex = UnityObjectToClipPos(v.vertex);
		o.uv = v.uv;
		return o;
	}

	half4 frag(v2f i) : SV_Target
	{
		// Initialize the color
		float3 color = _Color;
		// Normalize the coordinates
		float2 normalizedCoords = i.vertex.xy / _ScreenParams.xy;
		// Takes care of a wider aspect ratio
		normalizedCoords.x *= _ScreenParams.x / _ScreenParams.y;
		// Scale
		float2 st = _Scale * normalizedCoords;
		// Mouse input
		_MousePos.xy /= _ScreenParams.xy;
		_MousePos.x *= _ScreenParams.x / _ScreenParams.y;
		_MousePos.xy = _MousePos.xy * _Scale;
		float2 i_mst = floor(_MousePos.xy);
		float2 f_mst = frac(_MousePos.xy);

		// Tile space
		float2 i_st = floor(st);
		float2 f_st = frac(st);

		float minDist = 1;
		// Go through all neighboring sections
		for (int y = -1; y <= 1; y++)
		{
			for (int x = -1; x <= 1; x++) 
			{
				// Relative neighbor location in grid
				float2 neighbor = float2((float)x, (float)y);
				// Random position from current + neighbor place in the grid
				float2 neighborPoint = random2(i_st + neighbor);
				// Animate the point
				neighborPoint = 0.5 + 0.5*sin(_Time[1] + 6.2831*neighborPoint);
				// Vector between the pixel and the point
				float2 diff = neighbor.xy + neighborPoint - f_st;
				// Distance from neighborPoint
				float dist = length(diff);
				// Update the minimum distance
				minDist = min(minDist, dist);
			}
		}

		// Make another cell for the mouse
		float2 diff = (i_mst + f_mst) - (i_st + f_st);
		float dist = length(diff);
		minDist = min(minDist, dist);
		/*if(dist < minDist)
		{
			color = float3(1, 0, 0);
			return float4(color.rgb, 1);
		}*/
		

		// Draw the min distance (distance field)
		color *= minDist;

		// Make center
		// color += 1 - step(.02, m_dist);
		/*
		if (_MousePos.x < .7) 
		{
			color = float3(1, 0, 0);
		}*/


		return float4(color.rgb, 1);
	}
		ENDCG
	}
	}
}