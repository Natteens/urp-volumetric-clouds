# URP Volumetric Clouds

Volumetric clouds for the Universal Render Pipeline (URP), driven by a Renderer Feature and a Volume override.

## Overview

- URP volumetric clouds package.
- Requires Unity 6.x (package manifest baseline 6000.0); Unity 6.3 LTS or newer recommended.
- Currently prepared and tested against Unity 6.5+.
- URP RenderGraph is the primary supported path.
- Built-in Render Pipeline and HDRP are not supported.

## Installation

Via Package Manager (recommended):

1. Open `Window > Package Manager`.
2. Click `+` > `Add package from git URL...`.
3. Enter: `https://github.com/Natteens/urp-volumetric-clouds.git`
4. Click `Add`.

Via `manifest.json`:

```json
{
  "dependencies": {
    "com.natteens.urpvolumetricclouds": "https://github.com/Natteens/urp-volumetric-clouds.git"
  }
}
```

## Setup

Exact menu/field names can vary slightly depending on your project setup and Unity version.

1. Add the Renderer Feature: select your URP Renderer asset, `Add Renderer Feature > Volumetric Clouds URP`.
2. Assign the clouds material: set the Renderer Feature `Material` field to the provided sample material (shader `Sky/VolumetricClouds`) found under the package `Samples`. The effect will not render without a valid material.
3. Depth texture: the feature requests the camera depth texture automatically. If clouds do not appear, enable `Depth Texture` on the URP Renderer/asset (depending on your project setup).
4. Add a Volume: create a `Global Volume` in your scene with a Volume Profile.
5. Add the override: on the profile, `Add Override > Sky > Volumetric Clouds (URP)`.
6. Enable the effect: turn on the `State` toggle on the override.
7. Set the Renderer Feature `Quality Preset` (render-side cost; see below).
8. Set the Volume `Quality Preset` (raymarch quality; see below).
9. Choose a weather/look separately via the `Cloud Preset` on the override.

## The two preset systems

There are two independent quality controls plus a separate weather/look control. Do not confuse them.

### Renderer Feature Quality Preset

- Lives on the Renderer Feature.
- Controls render-side cost/scale.
- Values: Manual, Low, Medium, High, Cinematic.
- Affects `Resolution Scale` and `Upscale Mode`.
- Manual preserves your existing authored values.
- Presets apply once when changed, not every frame.

### Volume Quality Preset

- Lives on the Volumetric Clouds override.
- Controls raymarch quality.
- Values: Manual, Low, Medium, High, Cinematic.
- Affects primary steps, light steps, temporal accumulation, and perceptual blending.
- Manual preserves your existing authored values.
- Presets apply once when changed, not every frame.

### Weather / Cloud Preset

- Separate from both quality presets.
- Controls the cloud look/weather (Sparse, Cloudy, Overcast, Stormy, Custom).
- This is not a performance control.

## Recommended starting setups

Gameplay / default:

- Renderer Feature: Medium
- Volume Quality: Medium
- Weather: Cloudy or Custom

Low-end / performance:

- Renderer Feature: Low
- Volume Quality: Low

Screenshots / cinematics:

- Renderer Feature: Cinematic
- Volume Quality: Cinematic

Low and Medium presets render below full resolution and use bilateral upscale where applicable to reduce noise.

## Performance notes

- Lower resolution scale is the largest performance lever.
- Bilateral upscale is recommended whenever rendering below full resolution; bilinear is acceptable at full resolution.
- Primary steps and light steps are the main Volume-side cost knobs.
- Temporal accumulation reduces noise but can increase ghosting during motion.
- Cinematic is not intended as a default gameplay preset.
- Cloud shadows can be expensive when enabled.
- `cloudEdgeSoftness` (Renderer Feature) reduces the skybox halo around opaque object edges. It only affects the low-resolution Bilateral upscale path (resolution scale below full with Upscale Mode = Bilateral) and does nothing at full resolution or with Bilinear upscale. Default `0` disables it. Start around `2`–`4` only if an object-edge halo is visible. Higher values add some GPU cost and can introduce blocky edges along silhouettes. It reduces, but does not fully remove, edge artifacts.

## Known limitations

- URP only. Built-in and HDRP are not supported.
- Requires Unity 6.x (manifest baseline 6000.0); Unity 6.3 LTS or newer recommended.
- The RenderGraph path is the supported Unity 6 path; on Unity 6.5+ the legacy non-RenderGraph (Compatibility) pass path is compiled out.
- The non-RenderGraph Compatibility path remains only for Unity versions below 6.5.
- Multiple simultaneous real rendering cameras are not fully solved; temporal history is shared and may need additional per-camera work. Cinemachine virtual cameras driving a single Main Camera do not count as multiple real cameras.
- When cloud shadows are enabled, the effect may take ownership of the main directional light's cookie.
- If the package exposes experimental depth output, use it with care.

## Troubleshooting

- Clouds not visible: confirm the Renderer Feature is added and enabled, a valid material is assigned, the Volume override `State` is on, the Volume affects the camera, and the depth texture is available.
- Clouds too heavy/dense: lower density on the weather/look settings or pick a lighter weather preset; verify the Volume Quality preset is not unintentionally Manual with high authored values.
- Shimmering at low resolution: use the Bilateral upscale mode, or raise the resolution scale (Low/Medium presets already prefer bilateral below full resolution).
- Blue/gray halo around object edges at low resolution: with Bilateral upscale, raise `cloudEdgeSoftness` (start `2`–`4`); or render at full resolution. It only applies to the low-resolution Bilateral path and does not fully remove sub-pixel edge fringing.
- Ghosting during fast camera movement: lower the temporal accumulation factor (or use a lower Volume Quality preset).
- Cloud shadows not working: ensure light cookies are supported/enabled in the active URP asset and a main directional light is present and active.
- Scene/Game view mismatch: minor differences are expected because wind animation uses editor vs play time; both should animate.
- No main directional light / sun assigned: assign a directional light (or set the scene Sun) so lighting and shadows have a source; without one, lighting falls back safely but shadows will not render.

## License

MIT. See [LICENSE.md](LICENSE.md).
