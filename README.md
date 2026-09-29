# Katalog

App de catálogo de productos

## Cómo correr el proyecto

- Requisitos: Xcode 26.x, simulador iOS 17+.
- Abrir `Katalog.xcodeproj`, seleccionar el scheme `Katalog` y correr (⌘R).
- Tests: ⌘U (o `xcodebuild test -project Katalog.xcodeproj -scheme Katalog -destination 'platform=iOS Simulator,name=iPhone 16'`).
- Lint: `swiftlint lint` (usa el plugin de `SwiftLintPlugins`, ya integrado en el build).
- API: [dummyjson.com](https://dummyjson.com) (pública, sin API key).

## Arquitectura

Clean Architecture y MVVM

Por qué: separa lógica de negocio de UI y de detalles de red/persistencia, permite testear ViewModels con fakes del protocolo del use case sin tocar red ni disco, y facilita agregar features sin acoplarlas entre sí. Para el alcance del proyecto Clean Arquitecture agrega solo complejidad, sin embargo, decidí tomar ésta arquitectura ya que proyectos en el mercado siguien ésta solución.

## Supuestos

- Favoritos son solo locales (SwiftData), no se sincronizan con backend.
- "Offline" se detecta con `NWPathMonitor`; el banner es informativo y no bloquea la navegación sobre datos cacheados.
- Un solo idioma de UI (inglés) y una sola plataforma (iPhone, portrait/landscape).
- No debe haber paginación.

## Trade-offs

- "Sin paginación: se trae la lista completa" → gana simplicidad de código, pierde escalabilidad/performance si el catálogo crece.
- "Cache-first con revalidación en background" → gana UI instantánea y funciona offline, pierde mostrar datos potencialmente desactualizados por un instante.
- "Favoritos solo locales (SwiftData)" → gana simplicidad (no hay backend que mantener), pierde que no se sincronizan entre dispositivos.

## Con más tiempo
- Pruebas unitarias a más archivos. Se decidió solo hacerlas en ViewModels y ya que contienen más la lógica de interaccción con el usuario y el negocio.
- Paginación para aumentar une mejor experiencia de usuario.
- Manejo de errores más específico (sin conexión vs. error de servidor vs. datos corruptos).
- `.swiftlint.yml` con reglas propias del equipo.
