Shader "Custom/FragCoords" {

		SubShader{
		Pass{
		CGPROGRAM

#pragma vertex vert             
#pragma fragment frag

	struct vertInput {
		float4 pos : POSITION;
	};

	struct vertOutput {
		float4 pos : SV_POSITION;
	};

	vertOutput vert(vertInput input) {
		vertOutput o;
		o.pos = UnityObjectToClipPos(input.pos);
		return o;
	}

	half4 frag(vertOutput output) : COLOR {
		// _ScreenParams stores the width/height of the camera
		half2 normalizedcoords = half2(output.pos.x / _ScreenParams.x, output.pos.y / _ScreenParams.y);
		return half4(normalizedcoords.x, normalizedcoords.y,  0.0, 1.0);
	}
		ENDCG
	}
	}
}