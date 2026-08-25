import SwiftUI
import Photos

struct SwipeView: View {
    let assets: [PHAsset]

    @State private var currentIndex = 0
    @State private var currentImage: UIImage?
    @State private var toDelete: [PHAsset] = []
    @State private var dragOffset: CGSize = .zero
    @State private var goToSummary = false

    var body: some View {
        VStack {
            Text("\(currentIndex + 1) / \(assets.count)")
                .font(.headline)
                .padding(.top)

            ZStack {
                if let image = currentImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(16)
                        .padding()
                        .offset(x: dragOffset.width, y: 0)
                        .rotationEffect(.degrees(Double(dragOffset.width / 20)))
                        .overlay(alignment: dragOffset.width > 0 ? .topLeading : .topTrailing) {
                            if abs(dragOffset.width) > 30 {
                                Text(dragOffset.width > 0 ? "GARDER" : "SUPPRIMER")
                                    .font(.title.bold())
                                    .foregroundColor(dragOffset.width > 0 ? .green : .red)
                                    .padding(8)
                                    .background(.ultraThinMaterial)
                                    .cornerRadius(8)
                                    .padding()
                            }
                        }
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    dragOffset = value.translation
                                }
                                .onEnded { value in
                                    if value.translation.width < -100 {
                                        swipe(keep: false)
                                    } else if value.translation.width > 100 {
                                        swipe(keep: true)
                                    } else {
                                        withAnimation { dragOffset = .zero }
                                    }
                                }
                        )
                } else {
                    ProgressView()
                }
            }
            .frame(maxHeight: .infinity)

            HStack(spacing: 60) {
                Button {
                    swipe(keep: false)
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 56))
                        .foregroundColor(.red)
                }
                Button {
                    swipe(keep: true)
                } label: {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 56))
                        .foregroundColor(.green)
                }
            }
            .padding(.bottom, 30)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear { loadCurrentImage() }
        .background(
            NavigationLink(isActive: $goToSummary) {
                SummaryView(total: assets.count, toDelete: toDelete)
            } label: { EmptyView() }
        )
    }

    private func swipe(keep: Bool) {
        if !keep, currentIndex < assets.count {
            toDelete.append(assets[currentIndex])
        }
        withAnimation(.easeOut(duration: 0.2)) {
            dragOffset = CGSize(width: keep ? 500 : -500, height: 0)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            dragOffset = .zero
            currentIndex += 1
            if currentIndex >= assets.count {
                goToSummary = true
            } else {
                loadCurrentImage()
            }
        }
    }

    private func loadCurrentImage() {
        guard currentIndex < assets.count else { return }
        currentImage = nil
        let screenSize = UIScreen.main.bounds.size
        let targetSize = CGSize(width: screenSize.width * 2, height: screenSize.height * 2)
        PhotoManager.loadImage(for: assets[currentIndex], targetSize: targetSize) { image in
            currentImage = image
        }
    }
}
