Shader "HG/Jittering"
{
	Properties
	{
		_ColorA("Color", Color) = (1,1,1,1)
		_ColorB("Color", Color) = (1,1,1,1)
		_LightDirection ("Light Direction", Vector) = (0,1,1,1)
		_Intensity ("Jitter Intensity", Float) = 0.02
		_Speed ("Jitter Speed", Float) = 1
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
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float light : TEXCOORD1;
			};

			float _Speed;
			float _Intensity;
			float3 _LightDirection;

			float4 Jitter(float4 vertex)
			{
				float t = _Time[1] * _Speed;
				return vertex + (float4(sin(t + cos(t + vertex.x + vertex.y * 7) * 3), sin(t + 31 + vertex.x * 2 + vertex.y * 5), sin(t + 3 + vertex.x * 9 + vertex.y), 0) * _Intensity);
			}

			v2f vert (appdata v)
			{
				v2f o;
				v.vertex = Jitter(v.vertex);
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;

				float3 normal = UnityObjectToWorldNormal(v.normal);
				o.light = -dot(normalize(_LightDirection), normal);

				return o;
			}

			fixed4 _ColorA, _ColorB;
			
			fixed4 frag (v2f i) : SV_Target
			{
				i.light = clamp(i.light, 0, 1);
				fixed4 col = lerp(_ColorA, _ColorB, i.light);
				return col;
			}
			ENDCG
		}
	}
}
