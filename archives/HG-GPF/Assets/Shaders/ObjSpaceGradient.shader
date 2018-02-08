Shader "HG/Object Space Gradient"
{
	Properties
	{
		_ColorA ("Color", Color) = (1,1,1,1)
		_ColorB ("Color", Color) = (1,1,1,1)
		_Scale ("Scale", Float) = 2
		_Offset ("Offset", Float) = -1
	}
	SubShader
	{
		Tags {
			"RenderType" = "Opaque"
			"DisableBatching" = "True"
		}

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
				float height : TEXCOORD1;
			};
			
			float _Scale;
			float _Offset;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;

				o.height = v.vertex.y;
				o.height = (o.height - _Offset) * _Scale;

				return o;
			}

			fixed4 _ColorA;
			fixed4 _ColorB;
			
			fixed4 frag (v2f i) : SV_Target
			{
				i.height = clamp(i.height, 0, 1);
				fixed4 col = lerp(_ColorA, _ColorB, i.height);
				return col;
			}
			ENDCG
		}
	}
}
