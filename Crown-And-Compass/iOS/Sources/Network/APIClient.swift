import Foundation

/// A client to handle REST API networking using URLSession.
class APIClient {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    /// Performs a GET request to the given URL.
    /// - Parameters:
    ///   - url: The URL for the request.
    ///   - completion: A closure to be executed once the request has finished.
    func getRequest<T: Decodable>(url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "APIClientError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data returned"])))
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }

    /// Performs a POST request to the given URL with the given parameters.
    /// - Parameters:
    ///   - url: The URL for the request.
    ///   - body: The body parameters to encode as JSON.
    ///   - completion: A closure to be executed once the request has finished.
    func postRequest<T: Encodable, U: Decodable>(url: URL, body: T, completion: @escaping (Result<U, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            completion(.failure(error))
            return
        }

        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "APIClientError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data returned"])))
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(U.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}