import SwiftUI
import Combine

// MARK: - MuseViewModel
/// Coordinates business logic between Model-layer data and View-layer presentation.
/// Handles:
/// - Music playback state synchronization
/// - Listener interaction workflows
/// - UI button configuration
/// - Error propagation
@MainActor
@Observable
class MuseViewModel {
  
  // MARK: - Type Aliases
  /// Tuple defining primary/secondary colors for button states
  typealias ButtonColor = (primaryColor: Color, secondaryColor: Color?)
  /// Tuple defining text/icon assets for button variants
  typealias ButtonAssets = (title: String, icon: String)
  
  // MARK: - Properties
  /// The currently focused listener in detail views/modals
  var selectedListener: Listener? = nil
  
  /// Core data model handling persistence and business logic
  private var model: MuseModel
  
  /// Current list of nearby listeners (derived from model)
  private(set) var listeners: [Listener] = []
  
  /// Authenticated user profile (derived from model)
  private(set) var user: User
  
  /// Manages Spotify connection subscriptions
  private var cancellables = Set<AnyCancellable>()
  
  /// Spotify SDK controller reference
  var spotifyController: SpotifyController? {
    didSet { setupSpotifyObservers() }
  }
  
  // MARK: - Initialization
  
  /// Default initializer with empty model state
  init() {
    let initialModel = MuseModel()
    self.model = initialModel
    self.user = initialModel.user
    self.listeners = initialModel.listeners
    loadInitialData()
  }
  
  /// Dependency injection initializer for testing/previews
  /// - Parameter model: Preconfigured data model
  init(model: MuseModel) {
    self.model = model
    self.user = model.user
    self.listeners = model.listeners
    loadInitialData()
  }
  
  // MARK: - Music Display Logic
  
  /// Retrieves formatted track data for listener display
  /// - Parameter listener: Target listener entity
  /// - Returns: Array of (track, header) tuples
  func listenerTracks(_ listener: Listener) -> [(
    track: SpotifyTrack?,
    header: String
  )] {
    model.listenerTracks(listener)
  }
  
  /// Determines carousel eligibility for listener
  /// - Parameter listener: Target listener entity
  /// - Returns: True if both recommended and current tracks exist
  func shouldShowCarousel(for listener: Listener) -> Bool {
    model.shouldShowCarousel(listener)
  }
  
  /// Generates header text for user's playback state
  /// - Parameter user: Target user entity
  /// - Returns: Localized header string
  func userHeader(_ user: User) -> String {
    model.userHeader(user)
  }
  
  // MARK: - Button Handling
  
  /// Handles button press events for listener interactions
  /// - Parameter listener: Associated listener entity
  func buttonTap(_ listener: Listener) {
    Task {
      do {
        try await model
          .handleButtonAction(for: listener, type: listener.buttonToShow)
        await MainActor.run { refreshState() }
      } catch {
        handleButtonActionError(error)
      }
    }
  }
  
  /// Resolves display text for button states
  /// - Parameter buttonType: Interaction type
  /// - Returns: Localized button text
  func textToDisplay(_ buttonType: ButtonType) -> String {
    model.textToDisplay(buttonType)
  }
  
  // MARK: - Button Configuration
  
  /// Generates button display configuration
  /// - Parameters:
  ///   - type: Interaction type
  ///   - style: Visual presentation style
  /// - Returns: Configured ButtonData
  func buttonData(for type: ButtonType, style: ButtonStyle) -> ButtonData {
    let assets = buttonAssets(for: type)
    return ButtonData(
      type: type,
      title: style == .text ? assets.title : nil,
      icon: style == .icon ? assets.icon : nil
    )
  }
  
  /// Provides color scheme for button variants
  /// - Parameter type: Interaction type
  /// - Returns: Color tuple (primary, secondary)
  func buttonColors(for type: ButtonType) -> ButtonColor {
    switch type {
    case .listen, .connect: return (.green, .black)
    case .disconnect, .share: return (.pink, .white)
    case .shared: return (.red, .white)
    }
  }
  
  /// Maps button types to text/icon assets
  /// - Parameter type: Interaction type
  /// - Returns: Localized (title, icon) tuple
  func buttonAssets(for type: ButtonType) -> ButtonAssets {
    switch type {
    case .listen: return ("Listen", "music.note")
    case .connect: return ("Connect", "door.left.hand.open")
    case .disconnect: return ("Disconnect", "door.right.hand.open")
    case .share: return ("Share", "bolt")
    case .shared: return ("Shared", "bolt.fill")
    }
  }
  
  // MARK: - Data Loading
  
  /// Initial data hydration from model
  private func loadInitialData() {
    Task {
      do {
        try await model.loadData()
        await MainActor.run { refreshState() }
      } catch {
        print("Data loading error: \(error.localizedDescription)")
      }
    }
  }
  
  // MARK: - Listener Management
  
  /// Synchronizes view state with model updates
  private func refreshState() {
    listeners = model.listeners
    user = model.user
    updateSelectedListener()
  }
  
  /// Maintains selected listener reference integrity
  private func updateSelectedListener() {
    selectedListener = listeners.first { $0.id == selectedListener?.id }
  }
  
  // MARK: - Error Handling
  
  /// Centralized error handler for button actions
  /// - Parameter error: Encountered error object
  func handleButtonActionError(_ error: Error) {
    print("Button action failed: \(error.localizedDescription)")
    // Note: Consider propagating errors to UI alerts here
  }
}

// MARK: - Spotify Integration

private extension MuseViewModel {
  
  /// Establishes Spotify playback state observers
  func setupSpotifyObservers() {
    spotifyController?.$currentTrack
      .receive(on: DispatchQueue.main)
      .sink { [weak self] track in
        guard let self else { return }
        model.updateListeningTo(track)
        user = model.user
      }
      .store(in: &cancellables)
  }
}
