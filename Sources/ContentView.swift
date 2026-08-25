import SwiftUI
import Photos

struct ContentView: View {
    @State private var authorized = false
    @State private var mode: Int = 0 // 0 = mois par mois, 1 = aléatoire
    @State private var selectedMonth = Calendar.current.component(.month, from: Date())
    @State private var selectedYear = Calendar.current.component(.year, from: Date())
    @State private var sessionSize: Int = 30
    @State private var assets: [PHAsset] = []
    @State private var goToSwipe = false

    let months = Calendar.current.monthSymbols
    let years = Array((2008...Calendar.current.component(.year, from: Date())).reversed())

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("Tri de Photos")
                    .font(.largeTitle.bold())
                    .padding(.top, 40)

                if !authorized {
                    Text("Autorisation d'accès aux photos requise.")
                        .foregroundColor(.secondary)
                    Button("Autoriser l'accès aux photos") {
                        PhotoManager.requestAuthorization { granted in
                            authorized = granted
                        }
                    }
                    .buttonStyle(.borderedProminent)
                } else {
                    Picker("Mode", selection: $mode) {
                        Text("Mois par mois").tag(0)
                        Text("Aléatoire").tag(1)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)

                    if mode == 0 {
                        HStack {
                            Picker("Mois", selection: $selectedMonth) {
                                ForEach(1...12, id: \.self) { m in
                                    Text(months[m - 1].capitalized).tag(m)
                                }
                            }
                            Picker("Année", selection: $selectedYear) {
                                ForEach(years, id: \.self) { y in
                                    Text(String(y)).tag(y)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    VStack {
                        Text("Photos par session : \(sessionSize)")
                        Stepper("", value: $sessionSize, in: 5...200, step: 5)
                            .labelsHidden()
                    }
                    .padding(.horizontal)

                    Button("Commencer le tri") {
                        let sortMode: SortMode = mode == 0
                            ? .byMonth(year: selectedYear, month: selectedMonth)
                            : .random
                        assets = PhotoManager.fetchAssets(mode: sortMode, limit: sessionSize)
                        goToSwipe = true
                    }
                    .buttonStyle(.borderedProminent)
                    .font(.title3)
                }

                Spacer()

                NavigationLink(isActive: $goToSwipe) {
                    SwipeView(assets: assets)
                } label: {
                    EmptyView()
                }
                .hidden()
            }
            .onAppear {
                let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
                authorized = (status == .authorized || status == .limited)
            }
        }
    }
}
