//
//  TNM.swift
//  GitHubDownloader
//
//  Created by Andrei Niunin on 30.07.2021.
//

import Foundation



// MARK: - Data Structure

enum NetworkManagerError: Error {

    case badResponse(URLResponse?)
    case badData
    case badLocalUrl
    case badFileExtension
    
}

// MARK: - Object

class NetworkService {
    
    // MARK: properties
    let session = URLSession(configuration: .default)
    
    // MARK: request
    
    func requestData(withSearchQuery query: String?, completion: @escaping (Data?, Error?) -> Void) {
        let urlComponents: URLComponents = makeURLComponents()
        let queryItems: [URLQueryItem] = makeQuery(query)
        guard let url = makeURL(from: urlComponents, with: queryItems) else {
            completion(nil, NetworkManagerError.badLocalUrl)
            return
        }
        let request: URLRequest = makeRequest(with: url)
        let task: URLSessionDataTask = makeDataTask(request: request, completion: completion)
        task.resume()
    }
    
    func requestRepoFile(repoFullName: String, completion: @escaping (Data?, Error?) -> Void) {
        guard let repuURL = makeDownloadURL(repoFullName) else { return }
        let task = makeDownloadTask(repoURL: repuURL, completion: completion)
        task.resume()
    }
    
}

// MARK: - Factories

private extension NetworkService {
    
    func makeURLComponents() -> URLComponents {
        var urlConstructor = URLComponents()
        urlConstructor.scheme = "https"
        urlConstructor.host = "api.github.com"
        urlConstructor.path = "/search/repositories"
        return urlConstructor
    }
    
    func makeQuery(_ query: String?) -> [URLQueryItem] {
        return [
            URLQueryItem(name: "q", value: "user:\(query!)"),
            URLQueryItem(name: "per_page", value: "30"),
            URLQueryItem(name: "page", value: "1"),
        ]
    }
    
    func makeURL(from components: URLComponents, with queryItems: [URLQueryItem]) -> URL? {
        var comp = components
        comp.queryItems = queryItems
        return comp.url
    }
    
    func makeDownloadURL(_ full_name: String) -> URL? {
        var urlConstructor = URLComponents()
        urlConstructor.scheme = "https"
        urlConstructor.host = "api.github.com"
        urlConstructor.path = "/repos/\(full_name)/zipball/"
        return urlConstructor.url
    }
    
    func makeRequest(with url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        //        request.addValue("Client-ID \(key)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func makeDataTask(request: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            // Checking for error message abscence
            if error != nil {
                completion(nil, error)
                return
            }
            // Checking for succesfull 2xx response
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(nil, NetworkManagerError.badResponse(response))
                return
            }
            // Checking for data presence
            guard let data = data else {
                completion(nil, NetworkManagerError.badData)
                return
            }
            // Everything is OK
            completion(data, nil)
        }
        return dataTask
    }
    
    func makeDownloadTask(repoURL: URL, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDownloadTask {
        let downloadTask = URLSession.shared.downloadTask(with: repoURL) { localUrl, response, error in

            if let error = error as NSError? {
                completion(nil, error)
                return
            }
            let response = response as! HTTPURLResponse
            guard (200...299).contains(response.statusCode) else {
                completion(nil, NetworkManagerError.badResponse(response))
                return
            }
            guard let localUrl = localUrl else {
                completion(nil, NetworkManagerError.badLocalUrl)
                return
            }
            guard response.mimeType == "application/zip" else {
                completion(nil, NetworkManagerError.badFileExtension)
                return
            }
            
            do {
                let directory = try FileManager.default.url(for: .documentDirectory  , in: .userDomainMask, appropriateFor: nil, create: true) .appendingPathComponent(response.suggestedFilename ?? "Unnamed")
                
                try? FileManager.default.removeItem(at: directory)
                try FileManager.default.copyItem(at: localUrl, to: directory)
                completion(nil, nil)
            } catch let error {
                completion(nil, error)
            }
        }
        return downloadTask
    }
    
}
