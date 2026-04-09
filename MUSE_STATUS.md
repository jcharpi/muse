# Muse — Project Status

## What Muse Does

Muse lets you see what people near you are listening to on Spotify, and share music with them by holding your phones together (like NameDrop). You authenticate with Spotify, your current track is displayed in real time, and the Nearby tab shows other Muse users around you.

## Current State

**Working:**
- Spotify OAuth authentication (login/logout)
- Real-time Now Playing tracking with high-res album art from the Spotify SDK
- Tabbed UI: Now Playing + Nearby Listeners
- Listener detail modal with track display (single track or carousel if both a recommendation and a now-playing track exist)
- Button interaction state machine: Share your current track → they see "Listen" → they tap it → track plays
- Mock data for three test listeners with different states (no interaction, has recommendation, already shared)

**Not yet built:**
- Real proximity/peer discovery (the core feature) — no MultipeerConnectivity, NearbyInteraction, or backend
- Real MusicService implementation — currently backed by MockMusicService with hardcoded test data
- Error handling UI — errors are logged to console, no user-facing alerts
- Persistent session storage — token is lost on app restart
- Music playback through the real Spotify SDK `playTrack()` — the mock just prints to console

## File-by-File Summary

### App Entry
| File | Purpose |
|---|---|
| `MuseApp.swift` | Root. Owns `SpotifyController` and `MuseViewModel`. Routes to `SignInView` or `MuseHomeView` based on auth token. |

### Models
| File | Purpose |
|---|---|
| `User.swift` | Your Spotify profile + `listeningTo` track + `nowPlayingHeader` computed property. |
| `Listener.swift` | A nearby peer. Holds their track, any recommendation, and computed properties: `buttonToShow`, `tracks`, `showsCarousel`. |
| `SpotifyData.swift` | Plain data: `SpotifyTrack`, `SpotifyAlbum`, `SpotifyArtist`, `SpotifyImage`. |
| `Protocols.swift` | `SpotifyAccount` (shared shape for User/Listener) and `MusicDisplayable` (has `listeningTo`). |
| `ButtonData.swift` | `ButtonType` enum (listen/share/shared) with `statusText`, and `ButtonDisplayStyle` (icon vs text). |
| `MuseModel.swift` | Data brain. Calls `MusicService`, holds `user` and `listeners`, processes button actions. Defaults to `MockMusicService`. |
| `TestData.swift` | Hardcoded mock users/listeners for previews and on-device testing. |

### Services
| File | Purpose |
|---|---|
| `MusicService.swift` | Protocol defining the data layer: `fetchCurrentUser()`, `fetchNearbyListeners()`, `shareTrack()`, `playTrack()`. Plus `EmptyMusicService` (no-ops) and `MockMusicService` (test data). |
| `SpotifyController.swift` | Spotify SDK wrapper. Handles OAuth, app-remote connect/disconnect on foreground/background, live player state subscription, album art fetching. |

### ViewModels
| File | Purpose |
|---|---|
| `MuseViewModel.swift` | Bridge between model and views. Holds `selectedListener`, provides button colors/assets, syncs Spotify track updates via Combine. |

### Views
| File | Purpose |
|---|---|
| `SignInView.swift` | Login screen — "Connect with Spotify" button. |
| `MuseHomeView.swift` | Tab container with Now Playing (user's track + disconnect) and Nearby tabs. |
| `MuseNearbyView.swift` | Scrollable list of listeners. Tap opens detail sheet via `@Bindable` on `viewModel.selectedListener`. |

### Subviews
| File | Purpose |
|---|---|
| `MusicDisplayView.swift` | Switches between single `SongTabView` or a paginated carousel based on `listener.showsCarousel`. |
| `SongTabView.swift` | The track card: album art (SDK image, async URL, or placeholder) + title + artist. |
| `ListenerView.swift` | Row in the nearby list: profile icon + name + status text from `ButtonType.statusText`. |
| `ListenerModalView.swift` | Detail sheet: listener info + their music display + action button (or "sent recommendation" text). |
| `ButtonView.swift` | Adaptive button — text pill or icon circle based on `ButtonDisplayStyle`. Calls `viewModel.buttonTap()`. |
| `HeaderView.swift` | User's profile icon in the top-right corner. Tapping triggers the disconnect alert. |
| `ProfileIconView.swift` | Circular async image with person-icon fallback and a ring border. |

## Architecture

```
MuseApp
├── SpotifyController (@StateObject, ObservableObject)
│   └── Spotify SDK: auth, player state, artwork
├── MuseViewModel (@State, @Observable)
│   ├── MuseModel
│   │   └── MusicService protocol (currently MockMusicService)
│   └── Combine subscription to SpotifyController.$currentTrack
└── Views
    ├── SignInView (when unauthenticated)
    └── MuseHomeView (when authenticated)
        ├── Now Playing tab → HeaderView + MusicDisplayView → SongTabView
        └── Nearby tab → MuseNearbyView → ListenerView + ButtonView
                            └── sheet → ListenerModalView → MusicDisplayView + ButtonView
```

**Data flow:** SpotifyController publishes track changes → MuseViewModel subscribes via Combine → updates MuseModel.user.listeningTo → views re-render. Button taps go MuseViewModel → MuseModel.handleButtonAction() → MusicService → refreshState().

## Next Steps

1. **MultipeerConnectivity service** — Implement a real `MusicService` that broadcasts your current track over Bluetooth/WiFi and discovers nearby peers. This replaces `MockMusicService` as the default.
2. **NearbyInteraction gesture** — Use Apple's UWB framework to detect the "hold phones together" gesture and trigger a share.
3. **Session persistence** — Store the Spotify access token in Keychain so users don't re-auth every launch.
4. **Error handling UI** — Surface errors from button actions and network failures as user-facing alerts.
5. **Real playback** — Wire `playTrack()` through `SpotifyController.appRemote.playerAPI` to actually play shared tracks.
