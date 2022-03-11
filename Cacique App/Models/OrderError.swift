//
//  BeersError.swift
//  Cacique App
//
//  Created by Augusto Galindo Alí on 9/08/21.
//

import Foundation

enum OrderError: Error, LocalizedError {
    case saveError
    case readError
    case decodingError
    case encodingError
    
    var errorDescription: String? {
        switch self {
        case .saveError:
            return NSLocalizedString("Could not save Orders, please reinstall the app.", comment: "")
        case .readError:
            return NSLocalizedString("Could not load Orders, please reinstall the app.", comment: "")
        case .decodingError:
            return NSLocalizedString("There was a problem loading your Orders, please create a new Order to start over.", comment: "")
        case .encodingError:
            return NSLocalizedString("Could not save Orders, please reinstall the app.", comment: "")
        }
    }
}

struct ErrorType: Identifiable {
    let id = UUID()
    let error: OrderError
}
