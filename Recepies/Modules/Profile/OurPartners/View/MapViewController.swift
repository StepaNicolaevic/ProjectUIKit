//
//  MapViewController.swift
//  Recepies
//
//

import GoogleMaps
import UIKit

final class MapViewController: UIViewController {
    // MARK: - Constants

    enum Constants {
        static let nameInfoLabel = "You can get gifts and discounts from our partners"
        static let textForTittleButton = "Ок"
        static let cancelImage = "xmark"
        static let titleText = "Our Partners"
    }

    private let coordinatesStavropol = CLLocationCoordinate2D(latitude: 45.0428, longitude: 41.9734)
    private let coordinatesMoscow = CLLocationCoordinate2D(latitude: 55.753215, longitude: 37.622504)

    // MARK: - Visual Components

    private let mapView = GMSMapView()
    private var marker: GMSMarker?

    private lazy var myMarker: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.marker, for: .normal)
        button.layer.cornerRadius = 26
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(addMarker), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.nameInfoLabel
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.titleText
        label.font = UIFont.makeVerdanaBold(size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var exitButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitle(Constants.textForTittleButton, for: .normal)
        button.addTarget(self, action: #selector(closeViewController), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Public Properties

    var presenter: MapPresenter?

    // MARK: - Private Properties

    private let allAdress = DataAdress.setupData()
    private var arrayMarker: [GMSMarker] = []

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureCamera()
        addMarkes()
    }

    // MARK: - Private methods

    private func configureCamera() {
        let camera = GMSCameraPosition.camera(withTarget: coordinatesMoscow, zoom: 14)
        mapView.camera = camera
    }

    private func configureUI() {
        mapView.backgroundColor = .orange
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        view.addSubview(myMarker)
        view.addSubview(infoLabel)
        view.addSubview(exitButton)
        view.addSubview(titleLabel)
        view.backgroundColor = .white
        mapView.delegate = self
        setupNavigatinonBar()
        setupAnchor()
    }

    private func setupNavigatinonBar() {
        let barButton = UIBarButtonItem(image: UIImage(systemName: Constants.cancelImage), style: .done, target: self, action: #selector(closeViewController))
        barButton.tintColor = .black
        navigationItem.rightBarButtonItem = barButton
        navigationItem.hidesBackButton = true
    }

    private func setupAnchor() {
        setupMapConsraint()
        setupMarkerConsraint()
        setupInfoLabelConsraint()
        setupExitButtonConsraint()
        setupTitleLabelConsraint()
    }

    private func setupMapConsraint() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            mapView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            mapView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -255),

        ])
    }

    private func setupMarkerConsraint() {
        NSLayoutConstraint.activate([
            myMarker.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -14),
            myMarker.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -14),
            myMarker.widthAnchor.constraint(equalToConstant: 52),
            myMarker.heightAnchor.constraint(equalToConstant: 52),
        ])
    }

    private func setupInfoLabelConsraint() {
        NSLayoutConstraint.activate([
            infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoLabel.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 40),
            infoLabel.widthAnchor.constraint(equalToConstant: 350),
            infoLabel.heightAnchor.constraint(equalToConstant: 60),

        ])
    }

    private func setupTitleLabelConsraint() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
        ])
    }

    private func setupExitButtonConsraint() {
        NSLayoutConstraint.activate([
            exitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            exitButton.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 60),
            exitButton.widthAnchor.constraint(equalToConstant: 350),
            exitButton.heightAnchor.constraint(equalToConstant: 35),

        ])
    }

    private func addMarkes() {
        for item in allAdress {
            let marker = GMSMarker(position: item.coordinate)
            marker.title = item.title
            marker.map = mapView
            arrayMarker.append(marker)
        }
    }

    @objc private func addMarker() {
        marker = GMSMarker(position: coordinatesStavropol)
        marker?.icon = GMSMarker.markerImage(with: .blue)
        marker?.map = mapView
        mapView.animate(toLocation: coordinatesStavropol)
        myMarker.setImage(.blackEdition, for: .normal)
    }

    @objc private func closeViewController() {
        presenter?.dismisView()
    }
}

extension MapViewController: GMSMapViewDelegate {
    func mapView(_: GMSMapView, didTap marker: GMSMarker) -> Bool {
        marker.icon = GMSMarker.markerImage(with: .blue)
        if let markTap = allAdress.first(where: { $0.title == marker.title }) {
            presenter?.loadInfoFromMark(info: markTap)
        }
        return true
    }
}

extension MapViewController: MapViewProtocol {
    func openInfoAdress(info: DataAdress) {
        let infoViewController = InfoViewController()
        infoViewController.adressInfo = info
        infoViewController.setColorHandler = { [weak self] in
            guard let self = self else { return }
            for item in self.arrayMarker {
                item.icon = GMSMarker.markerImage(with: .red)
            }
        }
        if let sheet = infoViewController.sheetPresentationController {
            sheet.detents = [.custom { _ in 230 }]
        }
        present(infoViewController, animated: true)
    }
}
