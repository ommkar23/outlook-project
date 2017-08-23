//
//  WeatherProvider.swift
//  Outlook-Ommkar
//
//  Created by Ommkar Pattnaik on 23/08/2017.
//  Copyright © 2017 Ommkar Pattnaik. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case urlError
    case responseError
    case statusError(expectedStatus: Int, receivedStatus: Int)
    case nilData
    case wrongDataFormat
    var localizedDescription: String {
        switch self {
        case .urlError:
            return "Wrong url format"
        case .responseError:
            return "Response not http url response"
        case .statusError(let expectedStatus, let receivedStatus):
            return "Expected \(expectedStatus), but received \(receivedStatus)"
        case .nilData:
            return "Data null"
        case .wrongDataFormat:
            return "Wrong data format"
        }
    }
}

class WeatherProvider {
    private static let apiKey = "998207a40adcdeb72e4427b7cf7565b6"
    private static let forecastUrl = "https://api.darksky.net/forecast/"+WeatherProvider.apiKey+"/"
    private static let excludeString = "hourly,daily,alerts,flags"
    
    static func fetchWeatherIcon(latitude: Double, longitude: Double, timestamp: Double, completion: @escaping (String?, Error?)-> Void) {
        let defaultSession = URLSession(configuration: .default)
        let urlString = WeatherProvider.forecastUrl + "\(latitude),\(longitude),\(Int(timestamp))" + "?exclude=\(WeatherProvider.excludeString)"
        guard let url = URL(string: urlString) else {
            completion(nil, NetworkError.urlError)
            return
        }
        defaultSession.dataTask(with: url, completionHandler: {
            data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(nil, error)
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(nil, NetworkError.responseError)
                    return
                }
                guard httpResponse.statusCode == 200 else {
                    completion(nil, NetworkError.statusError(expectedStatus: 200, receivedStatus: httpResponse.statusCode))
                    return
                }
                guard let data = data else {
                    completion(nil, NetworkError.nilData)
                    return
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let jsonDict = json as? [String: Any],
                        let currentData = jsonDict["currently"] as? [String: Any],
                        let icon = currentData["icon"] as? String {
                        completion(icon, nil)
                    }
                    else {
                        completion(nil, NetworkError.wrongDataFormat)
                    }
                }
                catch (let error) {
                    completion(nil, error)
                }
            }
        }).resume()
    }
}
