# GateMonitor

Aplicație mobilă de monitorizare a porților industriale și a celor șase motoare asociate, realizată în Qt 6 / QML pentru Qt Design Studio.

## Funcționalități

- vizualizare radială pentru o poartă și exact șase motoare;
- stări GREEN, YELLOW, RED și BLUE;
- navigare între locații, porți, motoare, alarme și meniu;
- detalii tehnice pentru motoare;
- istoric global și jurnal de audit;
- profil editabil;
- roluri Admin și Utilizator cu permisiuni diferite;
- interfață mobilă dark, optimizată pentru ecrane portrait;
- build desktop și Android ARM64.

## Cerințe

- Qt 6.4 sau mai nou;
- Qt Quick;
- CMake 3.16 sau mai nou;
- pentru Android: Qt Android ARM64, Android SDK și NDK.

## Deschidere în Qt Design Studio

Deschide fișierul `GateMonitor.qmlproject`, selectează kitul Qt și rulează proiectul.

## Build desktop

```bash
qt-cmake -S . -B build
cmake --build build
./build/GateMonitorApp
```

## Android

APK-ul demonstrativ este disponibil în secțiunea **Releases** a repository-ului.

Datele tehnice din această versiune sunt simulate. Conectarea la senzori, autentificarea reală și persistența logurilor necesită un backend/API.
