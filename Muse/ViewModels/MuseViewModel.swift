import SwiftUI
import Combine

// MARK: - MuseViewModel
/// Coordinates data flow between the model layer and the view layer.
@MainActor
@Observable
class MuseViewModel {

  // MARK: - Type Aliases
  typealias ButtonColor = (primary: Color, secondary: Color?)
  typealias ButtonAssets = (title: String, icon: String)

  // MARK: - Properties
  var selectedListener: Listener?

  private var model: MuseModel
  private(set) var listeners: [Listener] = []
  private(set) var user: User

  private var cancellables = Set<AnyCancellable>()

  var spotifyController: SpotifyController? {
    didSet { setupSpotifyObservers() }
  }

  // MARK: - Initialization
  init(model: MuseModel? = nil) {
    let resolvedModel = model ?? MuseModel()
    self.model = resolvedModel
    self.user = resolvedModel.user
    self.listeners = resolvedModel.listeners
    loadInitialData()
  }

  // MARK: - Button Handling

  func buttonTap(_ listener: Listener) {
    Task {
      do {
        try await model.handleButtonAction(for: listener, type: listener.buttonToShow)
        refreshState()
      } catch {
        handleButtonActionError(error)
      }
    }
  }

  func buttonColors(for type: ButtonType) -> ButtonColor {
    switch type {
    case .react:    return (.primary, nil)
    case .reacted:  return (.yellow, nil)
    }
  }

  func buttonAssets(for type: ButtonType) -> ButtonAssets {
    switch type {
    case .react:    return ("React", "hand.thumbsup")
    case .reacted:  return ("Reacted", "hand.thumbsup.fill")
    }
  }

  // MARK: - Private Helpers

  private func loadInitialData() {
    Task {
      do {
        try await model.loadData()
        refreshState()
      } catch {
        print("Data loading error: \(error.localizedDescription)")
      }
    }
  }

  private func refreshState() {
    listeners = model.listeners
    user = model.user
    selectedListener = listeners.first { $0.id == selectedListener?.id }
  }

  private func handleButtonActionError(_ error: Error) {
    print("Button action failed: \(error.localizedDescription)")
  }
}

// MARK: - Spotify Integration
private extension MuseViewModel {
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
