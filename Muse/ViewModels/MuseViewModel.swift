import SwiftUI
import Combine

// MARK: - MuseViewModel
/// Coordinates data flow between the model layer and the view layer.
@MainActor
@Observable
class MuseViewModel {

  // MARK: - Properties

  // Public
  var selectedListener: Listener?
  var errorMessage: String?
  var toastMessage: String?
  var spotifyController: SpotifyController? { didSet { setupSpotifyObservers() } }

  // Read-only externally
  private(set) var listeners: [Listener] = []
  private(set) var user: User

  // Private
  private var cancellables = Set<AnyCancellable>()
  private var model: MuseModel

  // MARK: - Initialization
  init(model: MuseModel? = nil) {
    let resolvedModel = model ?? MuseModel()
    self.model = resolvedModel
    self.user = resolvedModel.user
    self.listeners = resolvedModel.listeners
    loadInitialData()
  }

  // MARK: - Playback Actions

  func playTrack(for listener: Listener) {
    guard let track = listener.listeningTo else { return }
    spotifyController?.playTrack(uri: track.uri) { [weak self] error in
      Task { @MainActor in
        if let error {
          self?.errorMessage = "Could not play: \(error.localizedDescription)"
        } else {
          self?.toastMessage = "Now playing: \(track.name)"
        }
      }
    }
  }

  func queueTrack(for listener: Listener) {
    guard let track = listener.listeningTo else { return }
    spotifyController?.queueTrack(uri: track.uri) { [weak self] error in
      Task { @MainActor in
        if let error {
          self?.errorMessage = "Could not queue: \(error.localizedDescription)"
        } else {
          self?.toastMessage = "Queued: \(track.name)"
          // TODO: send push notification to listener that someone queued their song
        }
      }
    }
  }

  // MARK: - Private Helpers

  private func loadInitialData() {
    Task {
      do {
        try await model.loadData()
        refreshState()
      } catch {
        errorMessage = error.localizedDescription
      }
    }
  }

  private func refreshState() {
    listeners = model.listeners
    user = model.user
    selectedListener = listeners.first { $0.id == selectedListener?.id }
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
