//
//  DataAdress.swift
//  Recepies


import Foundation
import GoogleMaps

// Данные о магазинах
struct DataAdress {
    /// Название магазина
    let title: String
    /// Адресс
    let address: String
    /// Его координаты
    let coordinate: CLLocationCoordinate2D

    static func setupData() -> [DataAdress] {
        [.init(title: "Magazin Stepana", address: "Lenina 16", coordinate: CLLocationCoordinate2D(latitude: 45.040937, longitude: 41.968049)),
         .init(title: "Magazin Vitali", address: "Lenina 17", coordinate: CLLocationCoordinate2D(latitude: 45.044996, longitude: 41.972892)),
         .init(title: "Magazin Antona", address: "Lenina 176", coordinate: CLLocationCoordinate2D(latitude: 45.045783, longitude: 41.962390)),
         .init(title: "Magazin Vity", address: "Lenina 116", coordinate: CLLocationCoordinate2D(latitude: 45.044966, longitude: 41.979751)),
         .init(title: "Magazin Ruslana", address: "Lenina 196", coordinate: CLLocationCoordinate2D(latitude: 45.036909, longitude: 41.965391)),
         .init(title: "Magazin Natasha", address: "Lenina 161", coordinate: CLLocationCoordinate2D(latitude: 45.039423, longitude: 41.983309))]
    }
}
