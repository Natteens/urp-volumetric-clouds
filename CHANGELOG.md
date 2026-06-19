# [0.3.0](https://github.com/Natteens/urp-volumetric-clouds/compare/v0.2.1...v0.3.0) (2026-06-19)


### Features

* Add optional depth-aware cloud edge softness ([ec76b51](https://github.com/Natteens/urp-volumetric-clouds/commit/ec76b519bc1a540c16a7767eb53ecb24000afd8e))

## [0.2.1](https://github.com/Natteens/urp-volumetric-clouds/compare/v0.2.0...v0.2.1) (2026-06-19)


### Bug Fixes

* Guard null render passes; add sample material ([8f4cebd](https://github.com/Natteens/urp-volumetric-clouds/commit/8f4cebdf8523f5e8aeb8d0e1ada78e1984bb1cba))

# [0.2.0](https://github.com/Natteens/urp-volumetric-clouds/compare/v0.1.2...v0.2.0) (2026-06-19)


### Features

* Add renderer/volume quality presets and fixes ([8683e9b](https://github.com/Natteens/urp-volumetric-clouds/commit/8683e9b9a9049092556940dba0659a938dc987e9))

## [0.1.2](https://github.com/Natteens/urp-volumetric-clouds/compare/v0.1.1...v0.1.2) (2026-02-07)


### Bug Fixes

* Expose cloud shader and add sample material meta ([70af0db](https://github.com/Natteens/urp-volumetric-clouds/commit/70af0db961524ce7aee79f5304a85ef562a4e050))

## [0.1.1](https://github.com/Natteens/urp-volumetric-clouds/compare/v0.1.0...v0.1.1) (2026-02-06)


### Bug Fixes

* Unhide VolumetricClouds shader ([22ffff4](https://github.com/Natteens/urp-volumetric-clouds/commit/22ffff4a8f9b165c29be5530cf324c109b005d1e))

# 📝 Changelog

Todas as mudanças notáveis neste projeto serão documentadas neste arquivo.

O formato é baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/),
e este projeto adere ao [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Não Lançado] / [Unreleased]

### Changed
- Unity 6.5 compile compatibility: guarded out the removed non-RenderGraph `OnCameraSetup`/`Execute` overrides for Unity 6.5+; RenderGraph is the active path.
- Shader precision cleanup: `_NumPrimarySteps`, `_NumLightSteps`, and `_MaxStepSize` changed from `half` to `float`.
- Cached local material keyword toggles so they are not reapplied every frame when inputs are unchanged.

### Fixed
- Removed per-frame weather-preset reapplication that overwrote runtime/Volume-blended values.
- Gated the custom LUT rebuild/upload so it only runs when the relevant curves change.
- Added null guards for the main light under physical-light integration and for the `CloudsMaterial` setter.

### Added
- Renderer Feature quality presets (Manual/Low/Medium/High/Cinematic) controlling resolution scale and upscale mode; applied only when changed.
- Volume quality presets (Manual/Low/Medium/High/Cinematic) controlling primary steps, light steps, temporal accumulation, and perceptual blending; applied only when changed and separate from the weather presets.
- Optional depth-aware `cloudEdgeSoftness` Renderer Feature control to reduce low-resolution silhouette halo artifacts on the Bilateral upscale path; disabled by default (`0`).

Note: changes are prepared and tested against Unity 6.3 LTS+/6.5 but not yet fully validated across all project configurations.

## [0.1.0] - 2025-12-09

### Adicionado
- ✨ Estrutura inicial do pacote Unity
- 📦 Configuração do Package Manager
- 📚 Documentação básica
- 🧪 Estrutura de testes
- 📋 Exemplos e amostras

### Mudado
- Nada ainda

### Removido
- Nada ainda

### Corrigido
- Nada ainda

---

Os tipos de mudanças são:
- **Adicionado** para novas funcionalidades
- **Mudado** para mudanças em funcionalidades existentes
- **Depreciado** para funcionalidades que serão removidas em breve
- **Removido** para funcionalidades removidas
- **Corrigido** para correções de bugs
- **Segurança** para vulnerabilidades
