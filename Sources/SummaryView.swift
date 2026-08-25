import SwiftUI
import Photos

struct SummaryView: View {
    let total: Int
    let toDelete: [PHAsset]

    @State private var showConfirmation = false
    @State private var deleted = false
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Text("Session terminée")
                .font(.largeTitle.bold())

            Text("\(toDelete.count) photo(s) à supprimer sur \(total)")
                .font(.title3)
                .foregroundColor(.secondary)

            if deleted {
                Label("Photos supprimées", systemImage: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .font(.title2)
            } else if toDelete.isEmpty {
                Text("Rien à supprimer, bravo !")
            } else {
                Button("Confirmer la suppression") {
                    showConfirmation = true
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
                .font(.title3)
            }

            Button("Retour à l'accueil") {
                presentationMode.wrappedValue.dismiss()
            }
            .padding(.top, 20)

            Spacer()
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .alert("Supprimer définitivement \(toDelete.count) photo(s) ?", isPresented: $showConfirmation) {
            Button("Annuler", role: .cancel) { }
            Button("Supprimer", role: .destructive) {
                PhotoManager.delete(assets: toDelete) { success in
                    deleted = success
                }
            }
        }
    }
}
