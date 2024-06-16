// Proxy.swift


import UIKit

/// Protocol for image loading service
protocol LoadImageServiceProtocol {
    /// Provide UIImage by url
    /// - Parameter stringURL: url adress of image in string format
    /// - Returns requested image
    func loadImage(by urlString: String, completion: @escaping (Result<UIImage, Error>) -> Void)
}

/// Load images from network or from cashe if existed
final class Proxy {
    // MARK: - Private properties

    private let fileManager = FileManager.default
    private var cacheFolderPath: URL? {
        fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first
    }

    // MARK: - Private Properties

    private let service: LoadImageServiceProtocol

    // MARK: - Initialization

    init(service: LoadImageServiceProtocol) {
        self.service = service
    }

    // MARK: - Private Methods

    private func makeFilePath(for urlString: String) -> URL? {
        if let url = URL(string: urlString) {
            let fileName = url.lastPathComponent
            return cacheFolderPath?.appendingPathComponent(fileName, conformingTo: .jpeg)
        } else {
            print("Failed to create file URL")
            return nil
        }
    }

    private func readDataFromFile(urlString: String) -> UIImage? {
        if let url = makeFilePath(for: urlString), let data = try? Data(contentsOf: url),
           let image = UIImage(data: data)
        {
            return image
        } else {
            print("No image")
            return nil
        }
    }

    private func writeImageToFile(_ image: UIImage, urlString: String) {
        if let data = image.jpegData(compressionQuality: 1),
           let fileName = makeFilePath(for: urlString)
        {
            try? data.write(to: fileName)
            print("Data saved to file", fileName)
        } else {
            print("Error writing to file:")
        }
    }
}

// MARK: - Proxy - LoadImageServiceProtocol

extension Proxy: LoadImageServiceProtocol {
    func loadImage(by urlString: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let filePath = makeFilePath(for: urlString)?.path ?? ""
        if fileManager.fileExists(atPath: filePath),
           let image = readDataFromFile(urlString: filePath)
        {
            completion(.success(image))
        } else {
            service.loadImage(by: urlString) { result in
                switch result {
                case let .failure(error):
                    completion(.failure(error))
                case let .success(image):
                    self.writeImageToFile(image, urlString: urlString)
                    completion(.success(image))
                }
            }
        }
    }
}
