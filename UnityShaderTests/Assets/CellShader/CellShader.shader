Shader "Custom/CellShader" {

	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_ObjPos("ObjPos", Vector) = (1,1,1,1)
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

	sampler2D _MainTex;
	uniform float4 _ObjPos;

	
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
		float2 normalizedCoords = i.vertex.xy / _ScreenParams.xy;
		// Takes care of a wider aspect ratio
		normalizedCoords.x *= _ScreenParams.x / _ScreenParams.y;
		float2 st = normalizedCoords * 3;
		// Init color
		half4 col = half4(0, 0, 0, 0);
		// Mouse input
		_ObjPos.x *= _ScreenParams.x / _ScreenParams.y;

		// Tile space
		float2 i_st = floor(st);
		float2 f_st = frac(st);

		float2 middle = random2(i_st);
		float2 diff = middle - f_st;
		float dist = length(diff);


		float minDist = 10;
		for (int y = -1; y <= 1; y++) 
		{
			for (int x = -1; x <= 1; x++) 
			{
				float2 neighbor = float2((float)x, (float)y);
				// Random position from current + neighbor place in the grid
				float2 neighborPoint = random2(i_st + neighbor);
				float2 diff = neighbor + neighborPoint - f_st;
				// Distance to the point
				float d = length(diff);
				// Keep the closer distance
				minDist = min(minDist, d);
			}
		}

		
		col += minDist;
		// Get the rgb value from the _MainTex
		//half4 col = tex2D(_MainTex, i.uv);

		// Draw cell center
		col += 1. - step(.02, dist);

		return col;
	}
		ENDCG
	}
	}
}