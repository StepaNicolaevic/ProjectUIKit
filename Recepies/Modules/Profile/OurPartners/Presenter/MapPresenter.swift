//
//  MapPresenter.swift
//  Recepies


import Foundation

/// Презентер карты
protocol MapPresenterProtocol: AnyObject {
    /// Координатор
    var coordinator: ProfileCoordinator? { get set }
    /// Экрнан с картой
    var view: MapViewProtocol? { get set }
    /// Выход с экрана
    func dismisView()
    /// Загрузка данных об адрессе
    func loadInfoFromMark(info: DataAdress)
}

/// Экран с гугл картой
protocol MapViewProtocol: AnyObject {
    /// Открытие экрана с дополнительной информацией
    func openInfoAdress(info: DataAdress)
}

final class MapPresenter: MapPresenterProtocol {
    // MARK: - Public Properties

    var coordinator: ProfileCoordinator?

    weak var view: MapViewProtocol?

    // MARK: - Public Methods

    func dismisView() {
        coordinator?.popViewController()
    }

    func loadInfoFromMark(info: DataAdress) {
        view?.openInfoAdress(info: info)
    }
}
