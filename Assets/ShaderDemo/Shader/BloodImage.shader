Shader "Unlit/BloodImage"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_ShieldTex("Shield Texture", 2D) = "white"{}
		_BloodFillAmount("Blood Fill Amount", Float) = 1.0
		_ShieldFillAmount("Shield Fill Amount", Float) = 0.0
		_UVCount("UV Count", Float) = 1.0

		//MASK SUPPORT ADD
		[HideInInspector]_StencilComp ("Stencil Comparison", Float) = 8
		[HideInInspector]_Stencil ("Stencil ID", Float) = 0
		[HideInInspector]_StencilOp ("Stencil Operation", Float) = 0
		[HideInInspector]_StencilWriteMask ("Stencil Write Mask", Float) = 255
		[HideInInspector]_StencilReadMask ("Stencil Read Mask", Float) = 255
		[HideInInspector]_ColorMask ("Color Mask", Float) = 15
		//MASK SUPPORT END
	}
	SubShader
	{
		Tags
		{
			"Queue" = "Transparent"
			"RenderType" = "Transparent"
			"CanUseSpriteAtlas" = "True"
		}
		Blend SrcAlpha OneMinusSrcAlpha
		//MASK SUPPORT ADD
		Stencil
		{
			Ref [_Stencil]
			Comp [_StencilComp]
			Pass [_StencilOp] 
			ReadMask [_StencilReadMask]
			WriteMask [_StencilWriteMask]
		}
		ColorMask [_ColorMask]
		//MASK SUPPORT END

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct a2v
			{
				float4 vertex : POSITION;
				float4 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			fixed4 _MainTex_ST;
			sampler2D _ShieldTex;
			fixed4 _ShieldTex_ST;
			float _BloodFillAmount;
			float _ShieldFillAmount;
			float _UVCount;
			
			v2f vert (a2v v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv.xy = TRANSFORM_TEX(v.uv.xy, _MainTex);
				o.uv.zw = TRANSFORM_TEX(v.uv.xy, _ShieldTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col;
				i.uv.x = i.uv.x * _UVCount;
				i.uv.z = i.uv.z * _UVCount;
				fixed4 colBlood = tex2D(_MainTex, i.uv.xy);
				fixed4 colShield = tex2D(_ShieldTex, i.uv.zw);
				//盾
				if(i.uv.x > _BloodFillAmount * _UVCount && i.uv.x < (_ShieldFillAmount + _BloodFillAmount) * _UVCount && _ShieldFillAmount != 0)
				{
					col = colShield;
				}
				//血
				else if(i.uv.x < _BloodFillAmount * _UVCount)
				{
					col = colBlood;
				}
				else
				{
					col.a = 0;
				}
				return col;
			}
			ENDCG
		}
	}
}
