import SwiftUI

struct SignInView: View {
  @Binding var showSignIn: Bool
  @Environment(\.dismiss) private var dismiss
    
  var body: some View {
    VStack(spacing: Constants.vStackSpacing) {
      Spacer()
            
      Text("Discover the Music Around You")
        .font(.largeTitle)
        .fontWeight(.bold)
        .multilineTextAlignment(.center)
        .padding(.horizontal)
            
      Text(
        "Sign in with Spotify to explore and share what you're listening to with those nearby."
      )
      .font(.body)
      .multilineTextAlignment(.center)
      .foregroundStyle(.secondary)
      .padding(.horizontal)
            
      Spacer()
            
      Button(action: signInWithSpotify) {
        HStack {
          Image(systemName: "music.note")
          Text("Sign in with Spotify")
            .fontWeight(.medium)
        }
        .padding(.vertical, Constants.verticalPadding)
        .padding(.horizontal, Constants.horizontalPadding)
        .background(.green)
        .foregroundColor(.black)
        .cornerRadius(Constants.cornerRadius)
      }
            
      Spacer()
    }
    .padding()
  }
    
  private func signInWithSpotify() {
    AuthManager.shared.login()
    showSignIn = false
    dismiss()
  }
    
  private struct Constants {
    static let verticalPadding: CGFloat = 12
    static let horizontalPadding: CGFloat = 24
    static let cornerRadius: CGFloat = 20
    static let vStackSpacing: CGFloat = 24
  }
}

#Preview {
  SignInView(showSignIn: .constant(true))
}
