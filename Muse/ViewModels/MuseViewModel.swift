import SwiftUI

/// Manages the app’s business logic and state for music interactions and UI configuration.
/// It mediates between the underlying MuseModel and the SwiftUI views.
@MainActor
@Observable
class MuseViewModel {
  // MARK: - Type Aliases
  
  /// Tuple for standardizing button color configuration.
  typealias ButtonColor = (primaryColor: Color, secondaryColor: Color?)
  /// Tuple for encapsulating button text and icon resources.
  typealias ButtonAssets = (title: String, icon: String)
  
  // MARK: - Properties
  
  /// The currently active listener, used to update UI components conditionally.
  var selectedListener: Listener? = nil
  
  /// The underlying data model handling persistence and data fetching.
  private var model: MuseModel
  
  // MARK: - Initialization
  
  /// Default initializer that creates a new data model instance and starts data loading.
  init() {
    self.model = MuseModel()
    loadInitialData()
  }
  
  /// Initializer for dependency injection, useful for testing or specialized configurations.
  /// - Parameter model: An instance of `MuseModel` provided from outside.
  init(model: MuseModel) {
    self.model = model
    loadInitialData()
  }
  
  // MARK: - Data Access
  
  /// Exposes listener data from the model.
  var listeners: [Listener] { model.listeners }
  
  /// Provides access to the current user from the model.
  var user: User { model.user }
  
  // MARK: - Music Display Logic
  
  /// Retrieves tracks and associated header text for a given listener.
  /// - Parameter listener: The listener for which tracks are requested.
  /// - Returns: An array of tuples pairing an optional Spotify track with a header.
  func listenerTracks(_ listener: Listener) -> [(
    track: SpotifyTrack?,
    header: String
  )] {
    model.listenerTracks(listener)
  }
  
  /// Determines if a carousel UI should be shown for the given listener.
  /// - Parameter listener: The listener under consideration.
  /// - Returns: A Boolean indicating the carousel display preference.
  func shouldShowCarousel(for listener: Listener) -> Bool {
    model.shouldShowCarousel(listener)
  }
  
  /// Generates a formatted header string for the given user.
  /// - Parameter user: The user for which the header is generated.
  /// - Returns: A header string derived from user information.
  func userHeader(_ user: User) -> String {
    model.userHeader(user)
  }
  
  // MARK: - Button Handling
  
  /// Handles the tap action on a button associated with a listener.
  /// This method performs asynchronous operations and updates UI state accordingly.
  /// - Parameter listener: The listener associated with the tapped button.
  func buttonTap(_ listener: Listener) {
    Task {
      do {
        // Execute the action defined in the model for the listener's button.
        try await model
          .handleButtonAction(for: listener, type: listener.buttonToShow)
        // Refresh the selected listener to reflect any changes from the action.
        await updateSelectedListenerIfNeeded(listener)
      } catch {
        // Centralized error handling for button actions.
        handleButtonActionError(error)
      }
    }
  }
  
  /// Retrieves a displayable text for a given button type.
  /// - Parameter buttonType: The type of button for which text is needed.
  /// - Returns: A string intended for button display.
  func textToDisplay(_ buttonType: ButtonType) -> String {
    model.textToDisplay(buttonType)
  }
  
  // MARK: - Button Configuration
  
  /// Generates button configuration data based on style preferences.
  /// This method abstracts the decision of whether to show text or an icon.
  /// - Parameters:
  ///   - type: The type of button (e.g., login, logout).
  ///   - style: The visual style for the button.
  /// - Returns: A `ButtonData` instance configured with the appropriate assets.
  func buttonData(for type: ButtonType, style: ButtonStyle) -> ButtonData {
    let assets = buttonAssets(for: type)
    return ButtonData(
      type: type,
      title: style == .text ? assets.title : nil,
      icon: style == .icon ? assets.icon : nil
    )
  }
  
  /// Maps a button type to its corresponding color scheme.
  /// - Parameter type: The button type to configure.
  /// - Returns: A tuple of primary and optional secondary colors.
  func buttonColors(for type: ButtonType) -> ButtonColor {
    switch type {
    case .listen, .login: return (.green, .black)
    case .logout, .share: return (.pink, .white)
    case .shared: return (.red, .white)
    }
  }
  
  /// Provides the asset resources (title and icon) for a given button type.
  /// - Parameter type: The type of button.
  /// - Returns: A tuple with the display title and icon name.
  func buttonAssets(for type: ButtonType) -> ButtonAssets {
    switch type {
    case .listen: return ("Listen", "music.note")
    case .login: return ("Login", "door.left.hand.open")
    case .logout: return ("Logout", "door.right.hand.open")
    case .share: return ("Share", "bolt")
    case .shared: return ("Shared", "bolt.fill")
    }
  }
  
  // MARK: - Data Loading
  
  /// Initiates the asynchronous loading of initial data.
  /// This ensures the view model is populated as soon as it is instantiated.
  private func loadInitialData() {
    Task {
      do {
        try await model.loadData()
      } catch {
        // Log errors instead of propagating them, as this is a non-critical path.
        print("Data loading error: \(error.localizedDescription)")
      }
    }
  }
  
  // MARK: - Listener Management
  
  /// Updates the currently selected listener if its data has been modified.
  /// This runs on the main thread to synchronize with the UI.
  /// - Parameter listener: The listener to potentially update.
  func updateSelectedListenerIfNeeded(_ listener: Listener) async {
    await MainActor.run {
      // Reassigns the selected listener to reflect any changes in the model.
      if selectedListener?.id == listener.id {
        selectedListener = model.listeners.first { $0.id == listener.id }
      }
    }
  }
  
  // MARK: - Error Handling
  
  /// Centralized error handling for button actions.
  /// Currently logs the error; can be extended to show UI alerts.
  /// - Parameter error: The error encountered during a button action.
  func handleButtonActionError(_ error: Error) {
    print("Button action failed: \(error.localizedDescription)")
  }
}
