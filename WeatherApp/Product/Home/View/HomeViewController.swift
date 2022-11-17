//
//  HomeViewController.swift
//  WeatherApp
//
//  Created by Ensar Yasin Karaköse on 3.11.2022.
//

import UIKit
import Kingfisher
import CoreLocation

protocol HomeViewControllerDelegate {
    func loadingState()
    func completeState()
    func failedState(error: String)
}

final class HomeViewController: UIViewController, HomeViewControllerDelegate {
    
    
    private let backgroundImage : UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "day.png")
        return image
    }()
    private let rootStackView : UIStackView = {
        let rootStackView = UIStackView()
        rootStackView.translatesAutoresizingMaskIntoConstraints = false
        rootStackView.axis = .vertical
        rootStackView.alignment = .center
        rootStackView.spacing = 10
        return rootStackView
    }()
    
    private let searchStack : UIStackView = {
        let searchStack = UIStackView()
        searchStack.translatesAutoresizingMaskIntoConstraints = false
        searchStack.axis = .horizontal
        searchStack.spacing = 8
        return searchStack
    }()
    
    private let locationButton : UIButton = {
        let locationButton = UIButton()
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        locationButton.setBackgroundImage(UIImage(systemName: "location.circle"), for: .normal)
        locationButton.addTarget(self, action: #selector(locationPressed(_:)), for: .primaryActionTriggered)
        return locationButton
    }()
    
    private let searchButton : UIButton = {
        let searchButton = UIButton()
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.addTarget(self, action: #selector(searchPressed(_:)), for: .touchUpInside)

        searchButton.setBackgroundImage(UIImage(systemName: "magnifyingglass.circle"), for: .normal)
        return searchButton
    }()
    private let searchTextField : UITextField = {
        let searchTextField = UITextField()
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.font = UIFont.preferredFont(forTextStyle: .subheadline)
        searchTextField.placeholder = "Search"
        searchTextField.layer.cornerRadius = 20
        searchTextField.layer.borderWidth = 0.50
        searchTextField.textAlignment = .center
        return searchTextField
    }()
    private let weatherImage : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private let temperatureLabel : UILabel = {
        let temperatureLabel = UILabel()
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        return temperatureLabel
    }()
    private let cityLabel : UILabel = {
        let cityLabel = UILabel()
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.font = UIFont.systemFont(ofSize: 24)
        return cityLabel
    }()
    private let activityIndicator : UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.style = .large
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()

    
    private var viewModel : HomeViewModel
    private let locationManager = CLLocationManager()
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        configure()
        setLayouts()
    }

}

extension HomeViewController {
    
    private func setup() {
        viewModel.delegate = self
        searchTextField.delegate = self
        locationManager.delegate = self
        activityIndicator.startAnimating()

        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    private func configure() {
        view.addSubview(backgroundImage)
        view.addSubview(rootStackView)
        

        
        backgroundImage.pinToEdgesOf(view: view)
        
        rootStackView.addArrangedSubview(searchStack)
        rootStackView.setCustomSpacing(30, after: searchStack)
        rootStackView.addArrangedSubview(weatherImage)
        rootStackView.addArrangedSubview(temperatureLabel)
        rootStackView.addArrangedSubview(cityLabel)
        rootStackView.addArrangedSubview(activityIndicator)
        
        searchStack.addArrangedSubview(locationButton)
        searchStack.addArrangedSubview(searchTextField)
        searchStack.addArrangedSubview(searchButton)
        
        
        
       
    }
    
    private func setLayouts() {
        
        NSLayoutConstraint.activate([
            rootStackView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1.2),
            rootStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: rootStackView.trailingAnchor, multiplier: 1),
            
            searchStack.leadingAnchor.constraint(equalTo: rootStackView.leadingAnchor),
            searchStack.trailingAnchor.constraint(equalTo: rootStackView.trailingAnchor),

            locationButton.widthAnchor.constraint(equalToConstant: 40),
            locationButton.heightAnchor.constraint(equalToConstant: 40),
            
            searchButton.widthAnchor.constraint(equalToConstant: 40),
            searchButton.heightAnchor.constraint(equalToConstant: 40),
            

            weatherImage.widthAnchor.constraint(equalToConstant: view.dWidth(0.75)),
            weatherImage.heightAnchor.constraint(equalToConstant: view.dHeight(0.25)),
          
      ])
    }
    
    private func makeTemperatureText(with temperature: Double) -> NSAttributedString {
        var boldTextAttributes = [NSAttributedString.Key : AnyObject]()
        boldTextAttributes[.foregroundColor] = UIColor.label
        boldTextAttributes[.font] = UIFont.systemFont(ofSize: 80)
        
        var plainTextAttributes = [NSAttributedString.Key : AnyObject]()
        plainTextAttributes[.font] = UIFont.systemFont(ofSize: 50)
        
        let text = NSMutableAttributedString(string: String(Int(temperature)), attributes: boldTextAttributes)
        text.append(NSMutableAttributedString(string: "°C", attributes: plainTextAttributes))
        return text
    }
   
}


extension HomeViewController {
    
    func loadingState() {
        activityIndicator.startAnimating()
        temperatureLabel.text = nil
        weatherImage.image = nil
        cityLabel.text = nil
        
        locationButton.isEnabled = false
        searchButton.isEnabled = false
    }
    
    func completeState() {
        guard let currentWeather = viewModel.weather else {return}

        weatherImage.kf.setImage(with: URL(string: APIURLs.getWeatherIconUrl(iconCode: currentWeather.weather?[0].icon ?? "", iconSize: .normal)))
        temperatureLabel.attributedText = makeTemperatureText(with: currentWeather.main?.temp ?? 0)
        cityLabel.text = currentWeather.name
        
        activityIndicator.stopAnimating()
        locationButton.isEnabled = true
        searchButton.isEnabled = true
        
        let date = Date(timeIntervalSince1970: Double(currentWeather.dt ?? 0))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: currentWeather.timezone ?? 0)
        dateFormatter.dateFormat = "HH"//Specify your format that you want
        let currentHour = Int(dateFormatter.string(from: date)) ?? 0
        print(currentHour)
        if currentHour > 7 && currentHour < 18 {
            backgroundImage.image = UIImage(named: "day.png")
        } else {
            backgroundImage.image = UIImage(named: "night.png")
        }
    }
    
    func failedState(error: String) {
        activityIndicator.stopAnimating()
        makeAlert(title: "Error", message: error)
    }
}

extension HomeViewController : UITextFieldDelegate {
    
    
    @objc func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchTextField.text != "" {
            return true
        } else {
            searchTextField.placeholder = "Type city"
            return false
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            //Fixes city names for url. Replaces spaces with "+" and turns special characters into english
            var localeCity = city.folding(options: .diacriticInsensitive, locale: .current)
            localeCity = localeCity.replacingOccurrences(of: " ", with: "+")
            localeCity = localeCity.replacingOccurrences(of: "ı", with: "i")
            print("DEBUG: \(localeCity)")
            viewModel.fetchCityLocation(city: localeCity)
        }
    }
}

extension HomeViewController : CLLocationManagerDelegate {
    @objc func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = String(location.coordinate.latitude)
            let lon = String(location.coordinate.longitude)
            print("curren lat : \(lat) , current lon : \(lon)")
            viewModel.fetchWeather(lon: lon, lat: lat)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
