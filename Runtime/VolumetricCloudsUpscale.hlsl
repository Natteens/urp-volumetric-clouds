#ifndef URP_VOLUMETRIC_CLOUDS_UPSCALE_HLSL
#define URP_VOLUMETRIC_CLOUDS_UPSCALE_HLSL

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareDepthTexture.hlsl"

// Bilateral kernel size
#define KERNEL_SIZE 3

// Avoid division by zero
#define _UpsampleTolerance 1e-5
//#define _NoiseFilterStrength 0.99999999

float _CloudEdgeSoftness;

half Weight(half distance)
{
    return exp(-distance * distance);
}

// Scene-depth-aware tap rejection: when enabled, taps whose scene depth differs from the center
// (i.e. across an opaque/sky silhouette) are down-weighted, reducing sky leak around object edges.
half DepthEdgeWeight(float centerDepth, float2 tapUV)
{
    if (_CloudEdgeSoftness <= 0.0)
        return 1.0;
    float tapDepth = LinearEyeDepth(SampleSceneDepth(tapUV), _ZBufferParams);
    float relDiff = abs(centerDepth - tapDepth) * rcp(max(max(centerDepth, tapDepth), 1e-5));
    return exp(-relDiff * _CloudEdgeSoftness);
}

half4 BilateralUpscale(float2 screenUV)
{
    // Calculate the current screenUV in a low resolution texture.
    float2 offsetUV = (floor(screenUV * _VolumetricCloudsLightingTexture_TexelSize.zw) + 0.5) * _VolumetricCloudsLightingTexture_TexelSize.xy;
    half4 centerColor = SAMPLE_TEXTURE2D_X_LOD(_VolumetricCloudsLightingTexture, s_linear_clamp_sampler, screenUV, 0).rgba;
    float centerDepth = _CloudEdgeSoftness > 0.0 ? LinearEyeDepth(SampleSceneDepth(screenUV), _ZBufferParams) : 0.0;

    half4 resultColor = half4(0.0, 0.0, 0.0, 0.0);
    half normalization = 0.0;

    for (int i = -KERNEL_SIZE; i <= KERNEL_SIZE; i++)
    {
        for (int j = -KERNEL_SIZE; j <= KERNEL_SIZE; j++)
        {
            float2 tapUV = offsetUV + float2(i, j) * _VolumetricCloudsLightingTexture_TexelSize.xy;
            half4 neighborColor = SAMPLE_TEXTURE2D_X_LOD(_VolumetricCloudsLightingTexture, s_linear_clamp_sampler, tapUV, 0).rgba;

            half2 distance = (screenUV - offsetUV) * _ScreenParams.xy;

            half colorDiff = length(centerColor.rgba - neighborColor.rgba);

            half weight = Weight(length(distance)) * rcp(colorDiff + _UpsampleTolerance) * DepthEdgeWeight(centerDepth, tapUV);

            resultColor += neighborColor * weight;
            normalization += weight;
        }
    }
    
    resultColor *= rcp(normalization);

    return resultColor;
}

half BilateralUpscaleTransmittance(float2 screenUV)
{
    // Calculate the current screenUV in a low resolution texture.
    float2 offsetUV = (floor(screenUV * _VolumetricCloudsLightingTexture_TexelSize.zw) + 0.5) * _VolumetricCloudsLightingTexture_TexelSize.xy;
    half centerTransmittance = SAMPLE_TEXTURE2D_X_LOD(_VolumetricCloudsLightingTexture, s_linear_clamp_sampler, screenUV, 0).a;
    float centerDepth = _CloudEdgeSoftness > 0.0 ? LinearEyeDepth(SampleSceneDepth(screenUV), _ZBufferParams) : 0.0;

    half resultTransmittance = 0.0;
    half normalization = 0.0;

    for (int i = -KERNEL_SIZE; i <= KERNEL_SIZE; i++)
    {
        for (int j = -KERNEL_SIZE; j <= KERNEL_SIZE; j++)
        {
            float2 tapUV = offsetUV + float2(i, j) * _VolumetricCloudsLightingTexture_TexelSize.xy;
            half neighborTransmittance = SAMPLE_TEXTURE2D_X_LOD(_VolumetricCloudsLightingTexture, s_linear_clamp_sampler, tapUV, 0).a;

            half2 distance = (screenUV - offsetUV) * _ScreenParams.xy;

            half transmittanceDiff = abs(centerTransmittance - neighborTransmittance);

            half weight = Weight(length(distance)) * rcp(transmittanceDiff + _UpsampleTolerance) * DepthEdgeWeight(centerDepth, tapUV);

            resultTransmittance += neighborTransmittance * weight;
            normalization += weight;
        }
    }

    resultTransmittance *= rcp(normalization);

    return resultTransmittance;
}

#endif