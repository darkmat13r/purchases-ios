//
//  FileHelper.swift
//  iosnative
//
//  Created by Dark Matter on 12/5/23.
//

import Foundation


public class FileHelper{
    public static func readFilesAt(_ url: URL, _ callback: @escaping(Result<[String], Error>) -> Void) {
        guard url.startAccessingSecurityScopedResource() else {
            let error = NSError(domain: "YourDomain", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to access security-scoped resource"])
            callback(.failure(error))
            return
        }

        var selectedUrl = [String]()
        defer { url.stopAccessingSecurityScopedResource() }

        var error: NSError? = nil
        NSFileCoordinator().coordinate(readingItemAt: url, error: &error) { (url) in
            let keys: [URLResourceKey] = [.nameKey, .isDirectoryKey]

            guard let fileList = FileManager.default.enumerator(at: url, includingPropertiesForKeys: keys) else {
                let error = NSError(domain: "YourDomain", code: 2, userInfo: [NSLocalizedDescriptionKey: "Unable to access the contents of \(url.path)"])
                callback(.failure(error))
                return
            }

            for case let file as URL in fileList {
                guard url.startAccessingSecurityScopedResource() else {
                    let error = NSError(domain: "YourDomain", code: 3, userInfo: [NSLocalizedDescriptionKey: "Failed to access security-scoped resource for \(file.path)"])
                    callback(.failure(error))
                    continue
                }

                do {
                    let resourceValues = try file.resourceValues(forKeys: [.isDirectoryKey])
                    if resourceValues.isDirectory == true {
                        continue
                    }

                    let data = try file.bookmarkData(options: .suitableForBookmarkFile, includingResourceValuesForKeys: nil, relativeTo: nil)
                    if file.absoluteString.isImageType() {
                        selectedUrl.append(data.base64EncodedString())
                    }
                } catch let error {
                    callback(.failure(error))
                    return
                }
                url.stopAccessingSecurityScopedResource()
            }

            callback(.success(selectedUrl))
        }
    }

}


extension String {
    public func isImageType() -> Bool {
        // image formats which you want to check
        let imageFormats = ["jpg","jpeg","pjpeg","pjp","webp","jfif", "png", "gif"]

        if URL(string: self) != nil  {

            let extensi = (self as NSString).pathExtension.lowercased()

            return imageFormats.contains(extensi)
        }
        return false
    }
}

