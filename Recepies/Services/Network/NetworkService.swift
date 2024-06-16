// NetworkService.swift


import UIKit

/// Protocol for network service in app
protocol NetworkServiceProtocol {
    /// Init with service to create url requests
    init(requestCreator: RequestCreatorProtocol)

    /// Try to download requested recipes
    /// - Parameters:
    /// type: type of category
    /// completion: closure to handle results
    /// - Returns: Array of recipes if success, or error in case of failure
    func getRecipes(type: CategoryType, text: String, completion: @escaping (Result<[Recipe], Error>) -> Void)

    /// Try to download requested recipe
    /// - Parameters:
    /// url: recipe url for detailed search
    /// completion: closure to handle results
    /// - Returns: Recipe if success, or error in case of failure
    func getDetailedRecipe(url: String, completion: @escaping (Result<RecipeDetail, Error>) -> Void)
}

/// Download data from server
final class NetworkService {
    // MARK: - Private Properties

    private let decoder = JSONDecoder()
    private var requestCreator: RequestCreatorProtocol

    // MARK: - Initialization

    init(requestCreator: RequestCreatorProtocol) {
        self.requestCreator = requestCreator
    }

    // MARK: - Private Methods

    private func convertToRecipes(_ categoryDTO: CategoryDTO) -> [Recipe] {
        categoryDTO.hits.map { Recipe($0.recipe) }
    }

    private func getData<T: Codable>(
        request: URLRequest?,
        parseProtocol: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let request else { return }
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let self else { return }
            // Try to download data
            guard let downloadedData = data else {
                if let error {
                    completion(.failure(error))
                }
                return
            }
            // Try to decode downloaded data
            do {
                let parsedData = try self.decoder.decode(parseProtocol, from: downloadedData)
                completion(.success(parsedData))
            } catch { completion(.failure(error)) }
        }
        task.resume()
    }
}

// MARK: - NetworkService - NetworkServiceProtocol

extension NetworkService: NetworkServiceProtocol {
    func getRecipes(type: CategoryType, text: String, completion: @escaping (Result<[Recipe], Error>) -> Void) {
        var request = requestCreator.createCategoryURLRequest(type: type, text: text)
        if Constants.isMockMode {
            let url = "\(String(describing: request?.url))"

            guard let urlMock = URL.makeURL(url, mockFileName: .recipe) else {
                return
            }
            request = URLRequest(url: urlMock)
        }
        getData(request: request, parseProtocol: CategoryDTO.self) { result in
            switch result {
            case let .success(categoryDTO):
                let recipes = self.convertToRecipes(categoryDTO)
                completion(.success(recipes))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func getDetailedRecipe(url: String, completion: @escaping (Result<RecipeDetail, Error>) -> Void) {
        let request = requestCreator.createRecipeURLRequest(uri: url)
        getData(request: request, parseProtocol: RecipeDetailResponseDTO.self) { result in
            switch result {
            case let .success(recipe):
                guard let detailDto = recipe.hits.first else { return }

                completion(.success(RecipeDetail(dto: detailDto.recipe)))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

// MARK: - NetworkService - LoadImageServiceProtocol

extension NetworkService: LoadImageServiceProtocol {
    func loadImage(by urlString: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            print("Failed to create URL")
            return
        }
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.urlCache = nil
        let session = URLSession(configuration: configuration)
        let task = session.dataTask(with: URLRequest(url: url)) { data, _, error in
            if let data, let image = UIImage(data: data) {
                completion(.success(image))
            } else if let error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

// MARK: - NetworkService + Extension

extension NetworkService {
    func getMokResponse(by urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            print("Failed to create URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                completion(.success(data))
            } else if let error {
                completion(.failure(error))
            }
        }.resume()
    }
}

enum Constants {
    /// Режим работы на моках вместо сервера
    static var isMockMode: Bool {
        #if Mock
            true
        #else
            false
        #endif
    }
}

/// Имя файла мока
enum MockFileName: String {
    /// Посты
    case recipe
    /// Пустой ответ
    case empty
}

extension URL {
    static func makeURL(_ urlString: String, mockFileName: MockFileName?) -> URL? {
        var newURL = URL(string: urlString)
        guard Constants.isMockMode else { return newURL }
        var fileName = mockFileName?.rawValue ?? ""
        if fileName.isEmpty {
            fileName = fileName.replacingOccurrences(of: "/", with: "_")
        }
        let bundleURL = Bundle.main.url(forResource: fileName, withExtension: "json")
        guard let bundleURL = bundleURL else {
            let errorText = "Отсутствует моковый файл: \(fileName).json"
            debugPrint(errorText)
            return nil
        }
        newURL = bundleURL
        return newURL
    }
}
