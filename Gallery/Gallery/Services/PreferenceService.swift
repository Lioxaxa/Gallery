//
//  PreferenceService.swift
//  Gallery
//
//  Created by Pupko, Aleksey on 13.01.24.
//

import Foundation

public class PreferencesService {
    
    // MARK: - Keys
    
    public enum Key : String {
        case favoriteImages = "favoriteImages"
        
        public var defaultValue: Any? {
            switch self {
            case .favoriteImages:
                return []
            }
        }
    }
    
    // MARK: - Singleton
    
    public static let shared = PreferencesService()
    
    // MARK: - Properties
        
    public var favoriteImages: [String] {
        get {
            return value(for: Key.favoriteImages, ofType: [String].self)
        }
        set {
            set(newValue, forKey: Key.favoriteImages)
        }
    }
    
    
    // MARK: - Constuctor
    
    private init() {
    }
    
    public func valueOrNil<ValueType>(for key: Key, ofType type: ValueType.Type) -> ValueType? {
        if let value = UserDefaults.standard.object(forKey: key.rawValue) as? ValueType {
            return value
        }
        if let defaultValue = key.defaultValue as? ValueType {
            return defaultValue
        }
        return nil
    }
    
    public func value<ValueType>(for key: Key, ofType type: ValueType.Type) -> ValueType {
        return valueOrNil(for: key, ofType: ValueType.self)!
    }
    
    public func set(_ value: Any?, forKey key: Key) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    public func remove(key: Key){
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
}

