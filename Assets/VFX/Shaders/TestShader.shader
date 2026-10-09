// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/TestShader" {
    Properties {
        _Tint ("Tint", Color) = (1, 1, 1, 1)
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader {
        Pass{
            CGPROGRAM

            #pragma vertex MyVertexProgram
			#pragma fragment MyFragmentProgram

            #include "UnityCG.cginc"

            float4 _Tint;
            sampler2D _MainTex;
            float4 _MainTex_ST;

            struct Interpolators {
				float4 position : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

            struct VertexData {
				float4 position : POSITION;
				float2 uv : TEXCOORD0;
			};

            //--Tidied up idea--

			Interpolators MyVertexProgram (VertexData v) {
				Interpolators i;
				i.uv = TRANSFORM_TEX(v.uv, _MainTex);
				i.position = UnityObjectToClipPos(v.position);
				return i;
            }

            float4 MyFragmentProgram (Interpolators i) : SV_TARGET {
				return tex2D(_MainTex, i.uv) * _Tint;
			}

            //--General idea--

            // float4 MyVertexProgram (
            //     float4 position : POSITION,
            //     out float3 localPosition : TEXCOORD0
            //     ) 
            // : SV_POSITION {
            //     localPosition = position.xyz;
            //     return UnityObjectToClipPos(position);
			// }

			// float4 MyFragmentProgram (
            //     float4 position : SV_POSITION,
            //     float3 localPosition : TEXCOORD0
            //     ) 
            //     : SV_Target {
            //     return float4(localPosition, 1);
			// }

            ENDCG
        }

    }
}
