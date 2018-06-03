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
		// Mouse input
		_ObjPos.x *= _ScreenParams.x / _ScreenParams.y;

		half4 col = half4(0, 0, 0, 0);

		// Cell positions
		float2 points[5];
		points[0] = float2(0.83, 0.75);
		points[1] = float2(0.60, 0.07);
		points[2] = float2(0.28, 0.64);
		points[3] = float2(0.31, 0.26);
		points[4] = _ObjPos.xy / _ScreenParams.xy;

		// Minimum distance
		float minDist = 1;

		for (int i = 0; i < 5; i++) 
		{
			float dist = distance(normalizedCoords, points[i]);
			// Keep the closer distance
			minDist = min(minDist, dist);
		}
		col += minDist;
		// Get the rgb value from the _MainTex
		//half4 col = tex2D(_MainTex, i.uv);

		return col;
	}
		ENDCG
	}
	}
}