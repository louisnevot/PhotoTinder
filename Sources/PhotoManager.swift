import Foundation
import Photos
import UIKit

enum SortMode {
    case byMonth(year: Int, month: Int)
    case random
}

final class PhotoManager: ObservableObject {

    static func requestAuthorization(completion: @escaping (Bool) -> Void) {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            DispatchQueue.main.async {
                completion(status == .authorized || status == .limited)
            }
        }
    }

    /// Récupère un batch de PHAsset selon le mode choisi, limité à `limit` éléments.
    static func fetchAssets(mode: SortMode, limit: Int) -> [PHAsset] {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]

        switch mode {
        case .byMonth(let year, let month):
            var startComponents = DateComponents()
            startComponents.year = year
            startComponents.month = month
            startComponents.day = 1
            var endComponents = DateComponents()
            endComponents.year = month == 12 ? year + 1 : year
            endComponents.month = month == 12 ? 1 : month + 1
            endComponents.day = 1

            let calendar = Calendar.current
            guard let start = calendar.date(from: startComponents),
                  let end = calendar.date(from: endComponents) else {
                return []
            }
            options.predicate = NSPredicate(format: "creationDate >= %@ AND creationDate < %@", start as NSDate, end as NSDate)

        case .random:
            break // pas de filtre, on prend tout puis on mélange
        }

        let result = PHAsset.fetchAssets(with: .image, options: options)
        var assets: [PHAsset] = []
        result.enumerateObjects { asset, _, _ in
            assets.append(asset)
        }

        if case .random = mode {
            assets.shuffle()
        }

        if assets.count > limit {
            assets = Array(assets.prefix(limit))
        }
        return assets
    }

    /// Charge l'image d'un asset de façon asynchrone.
    static func loadImage(for asset: PHAsset, targetSize: CGSize, completion: @escaping (UIImage?) -> Void) {
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        options.deliveryMode = .highQualityFormat
        manager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options) { image, _ in
            completion(image)
        }
    }

    /// Supprime réellement les assets donnés (demande la confirmation système d'iOS).
    static func delete(assets: [PHAsset], completion: @escaping (Bool) -> Void) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.deleteAssets(assets as NSArray)
        }) { success, _ in
            DispatchQueue.main.async {
                completion(success)
            }
        }
    }
}
