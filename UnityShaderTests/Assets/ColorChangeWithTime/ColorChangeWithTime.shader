﻿Shader "Custom/ColorChangeWithTime" {

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

	half4 frag(vertOutput output) : COLOR{
		return half4(abs(sin(_Time[0])), 0.0, 0.0, 1.0);
	}
		ENDCG
	}
	}
}