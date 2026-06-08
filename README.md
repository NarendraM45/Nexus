<!-- Place assets/banner.svg at the root of your repo in an assets/ folder -->

<p align="center">
  <img src="assets/banner.svg" alt="Nexus — Connect. Create. Conquer." width="100%">
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter&logoColor=white" alt="Flutter">
  &nbsp;
  <img src="https://img.shields.io/badge/Dart-3.2+-0175C2?style=flat-square&logo=dart&logoColor=white" alt="Dart">
  &nbsp;
  <img src="https://img.shields.io/badge/Riverpod-2.5.1-7C3AED?style=flat-square" alt="Riverpod">
  &nbsp;
  <img src="https://img.shields.io/badge/GoRouter-14.2-00BCD4?style=flat-square" alt="GoRouter">
  &nbsp;
  <img src="https://img.shields.io/badge/version-1.0.0-F43F8A?style=flat-square" alt="Version">
  &nbsp;
  <img src="https://img.shields.io/badge/license-MIT-22C55E?style=flat-square" alt="License">
  &nbsp;
  <img src="https://img.shields.io/badge/Android-SDK%2021+-3DDC84?style=flat-square&logo=android&logoColor=white" alt="Android">
</p>

<br>

A cinematic Flutter productivity suite — glassmorphic dark UI, a hand-crafted 3D compass navigator, and Lottie · Rive · `flutter_animate` breathing life into every screen.

<br>

---

## 📥 Download

<p>
  <a href="https://github.com/NarendraM45/Nexus/releases/download/v1.0.0/nexus-final.apk">
    <img src="https://img.shields.io/badge/⬇%20Download%20APK-v1.0.0-7C3AED?style=for-the-badge&labelColor=060810" alt="Download APK">
  </a>
</p>

> Android 5.0+ (API 21) · Release-mode build · ARMv7 + ARM64 universal APK

---

## 🎬 Demo

<!-- Drag and drop a screen recording GIF into this edit view on GitHub, or paste a YouTube embed -->

| | |
|:---:|:---:|
| [▶ Watch demo](#) | [📱 Download APK](https://github.com/NarendraM45/Nexus/releases/download/v1.0.0/nexus-final.apk) |

<details>
<summary>How to embed a demo GIF</summary>

1. Record your screen (Android screen recorder, or `scrcpy --record demo.mp4`)
2. Convert to GIF: `ffmpeg -i demo.mp4 -vf "fps=15,scale=320:-1" demo.gif`
3. Open this `README.md` for editing on GitHub, drag the `.gif` directly into the editor
4. Replace the table above with the embedded image GitHub generates

</details>

---

## ✨ Features

| | Feature | Details |
|:---:|---|---|
| 🧭 | **3D Compass navigation** | Hand-crafted animated bottom nav with arc-precision icon math across 10 dynamic routes. Hides itself cleanly when overlays open via `navVisibleProvider` |
| ✨ | **Cinematic animations** | Lottie · Rive · `flutter_animate` on every screen — including a Lottie hamburger in every `AppBar` leading slot |
| 🪟 | **Glassmorphism** | Consistent dark glass cards, modals, and text fields with `BackdropFilter`, blur, and layered opacity |
| 📅 | **Calendar & tasks** | `table_calendar` with date-aware task creation sheets and `useRootNavigator: true` throughout all overlays |
| 👥 | **Team management** | Member cards with `CachedNetworkImage`, role editing, and a live avatar picker — camera · gallery · remove — with haptic feedback |
| 📊 | **Analytics** | `fl_chart` multi-chart dashboards with animated data entry transitions |
| 🗒️ | **Notes** | Masonry staggered grid via `flutter_staggered_grid_view` |
| 🔍 | **Explore** | Animated expanding search bar — 60% → 100% width on focus |
| 🎉 | **Confetti** | Burst effect on key milestone completions |
| 🔔 | **Notifications** | Local push notifications with runtime permission handling via `permission_handler` |

---

## 🛠 Tech stack

| Layer | Package | Version |
|---|---|---|
| Framework | `flutter` · Dart | `3.x` / `3.2+` |
| State management | `flutter_riverpod` | `2.5.1` |
| Navigation | `go_router` | `14.2.0` |
| Animations | `lottie` · `rive` · `flutter_animate` · `animations` | — |
| Charts | `fl_chart` | `0.69.2` |
| UI effects | `glassmorphism` · `blur` · `particle_field` · `shimmer` | — |
| Fonts | `google_fonts` (Orbitron) | `6.2.1` |
| Images | `cached_network_image` | `3.3.1` |
| Forms | `flutter_form_builder` + validators | `10.3.0` |
| Calendar | `table_calendar` | `3.1.2` |
| Storage | `shared_preferences` | `2.3.2` |
| Notifications | `flutter_local_notifications` | `17.2.2` |

---

## 🏗 Architecture

```
lib/
├── core/
│   ├── constants/     AppColors · AppTypography · AppStyles
│   ├── providers/     authProvider · taskProvider · notesProvider · avatarProvider
│   ├── router/        GoRouter declarative route config
│   ├── theme/         Light & dark theme data
│   └── utils/         AppLogger
├── features/
│   ├── splash/        Cinematic 8s animated splash
│   ├── onboarding/    3-slide swipeable feature walkthrough
│   ├── auth/          Glassmorphic Login · Signup with form_builder
│   ├── loading/       Post-auth rocket transition screen
│   ├── home/          Personalized greeting · activity summary
│   ├── calendar/      table_calendar + date-aware task sheets
│   ├── tasks/         Task CRUD + priority scheduling
│   ├── projects/      Project cards + staggered grid
│   ├── team/          Member cards + avatar picker + CachedNetworkImage
│   ├── analytics/     fl_chart multi-chart dashboards
│   ├── notes/         Masonry staggered grid notes
│   ├── activity/      Activity log feed
│   ├── explore/       Discover feed + animated expanding search
│   ├── profile/       Profile + photo editor
│   └── settings/      User preferences + app version
└── shared/
    ├── layouts/       CompassNavWidget · DrawerLayout · MainShell · RadialNavMenu
    └── widgets/
        ├── custom/    SafeLottie · RiveRefreshIndicator
        ├── buttons/   PrimaryButton · GradientButton
        ├── cards/     MediaCard · GlassCard
        ├── inputs/    GlassTextField · SearchBarWidget
        ├── breathing_list_item.dart
        └── lottie_hamburger.dart
```

State follows a strict **state class → notifier class → provider declaration** separation throughout. All navigation goes through `context.go()` / `context.push()` — no raw `Navigator` calls except inside `useRootNavigator: true` sheets.

---

## 🚀 Getting started

**Requirements** — Flutter 3.x · Dart 3.2+ · Android SDK 21+

```bash
# Clone
git clone https://github.com/NarendraM45/Nexus.git
cd Nexus

# Install dependencies
flutter pub get

# Run in debug mode
flutter run

# Build release APK
flutter build apk --release
# → build/app/outputs/flutter-apk/nexus-v1.0.0.apk
```

<details>
<summary>Generating launcher icons</summary>

Drop your icon at `assets/icon/icon.png` (1024×1024 recommended), then run:

```bash
dart run flutter_launcher_icons
```

</details>

---

## 📄 License

MIT © 2026 [Narendra M](https://github.com/NarendraM45)

---

<p align="center">
  <sub>built with Flutter · powered by an unreasonable number of Lottie files · if this helped, drop a ⭐</sub>
</p>
