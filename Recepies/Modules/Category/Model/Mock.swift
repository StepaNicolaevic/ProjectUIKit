//
//  Mock.swift
//  Recepies
//

import Foundation

// Модель для поста
struct Post: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

// class NetworkService {
//    func fetchPosts(completion: @escaping (Result<[Post], Error>) -> Void) {
//        let serverURLString = "https://jsonplaceholder.typicode.com/posts"
//
//        /// На этот код
//        guard let url = URL.makeURL(serverURLString, mockFileName: .recipe) else {
//                    completion(.failure("Отсутствует моковый файл" as! Error))
//                    return
//         }
//
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let data = data else {
//                completion(.failure(NSError(domain: "NetworkService", code: -2, userInfo: [NSLocalizedDescriptionKey: "Данные не получены"])))
//                return
//            }
//
//            do {
//                let posts = try JSONDecoder().decode([Post].self, from: data)
//                completion(.success(posts))
//            } catch {
//                completion(.failure(error))
//            }
//        }
//        .resume()
//    }
// }
/// Константы
// final class Constants {
//    /// Режим работы на моках вместо сервера
//    static var isMockMode: Bool {
//    #if Mock
//        true
//    #else
//        false
//    #endif
//    }
// }
//
///// Имя файла мока
// enum MockFileName: String {
//    /// Посты
//    case recipe
//    /// Пустой ответ
//    case empty
// }
//
// extension URL {
//   static func makeURL(_ urlString: String, mockFileName: MockFileName?) -> URL? {
//        var newURL = URL(string: urlString)
//        guard Constants.isMockMode else { return newURL }
//        var fileName = mockFileName?.rawValue ?? ""
//        if fileName.isEmpty {
//            fileName = fileName.replacingOccurrences(of: "/", with: "_")
//        }
//        let bundleURL = Bundle.main.url(forResource: fileName, withExtension: "json")
//        guard let bundleURL = bundleURL else {
//            let errorText = "Отсутствует моковый файл: \(fileName).json"
//            debugPrint(errorText)
//            return nil
//        }
//        newURL = bundleURL
//        return newURL
//    }
// }
