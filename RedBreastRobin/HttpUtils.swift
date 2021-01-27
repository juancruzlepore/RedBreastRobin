//
//  HttpUtils.swift
//  RedBreastRobin
//
//  Created by Juan Cruz Lepore on 23/1/21.
//

import Foundation

class HttpUtils {
    public static func makePostRequest(url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let parameters: [String: Any] = [:]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return
        }
        request.httpBody = httpBody
        request.timeoutInterval = 20
        let session = URLSession.shared
        session.dataTask(with: request, completionHandler: completionHandler).resume()
    }
    
    public static func makeDownloadRequest(url: URL, completionHandler: @escaping (URL?, URLResponse?, Error?) -> Void) {
        URLSession.shared.downloadTask(with: url, completionHandler: completionHandler).resume()
    }
    
    public static func makeGithubRequest(url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let parameters: [String: Any] = [:]
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/vnd.github.v3.object", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return
        }
        request.httpBody = httpBody
        request.timeoutInterval = 20
        let session = URLSession.shared
        session.dataTask(with: request, completionHandler: completionHandler).resume()
    }
}
