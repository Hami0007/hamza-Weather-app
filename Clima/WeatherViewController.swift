//
//  ViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//
// it my weather app that i create due to the help of ALLAH 
import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
class WeatherViewController: UIViewController,CLLocationManagerDelegate,citydelegate {
  
    
    var weatherdelegate=WeatherDataModel()
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "e72ca729af228beabd5d20e3b7749713"
    /***Get your own App ID at https://openweathermap.org/appid ****/
    
   
    //TODO: Declare instance variables here
    
var locationManager=CLLocationManager()
    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate=self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        //TODO:Set up the location manager here.
    
        
        
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    
    func checnetwork(urrl:String,parameter:[String:String])
        {
            Alamofire.request(urrl, method: .get, parameters: parameter).responseJSON { (responsee) in
                if(responsee.result.isSuccess)
                {
                    print("Successfully connection request")
                    print(responsee.result.value)
                    var json:JSON=JSON(responsee.result.value)
                    self.jsonparsin(jsondata: json)
                    
            }
                else{
                    print(responsee.result.error)
                    self.cityLabel.text="Connection Error"
                }
            }
    }
    
    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
   
    func jsonparsin(jsondata:JSON)
    {
    var temp=(jsondata["main"]["temp"])
        var tempinc=Int(temp.doubleValue-273.0)
    weatherdelegate.tempeture=tempinc
        print(tempinc)
        var name=jsondata["name"]
        weatherdelegate.name=name.stringValue
        print(name)
        var condition=jsondata["weather"]
        var id=condition[0]["id"]
        weatherdelegate.condirion=id.intValue
        print(condition)
        print(id)
        var icon=jsondata["weather"][0]["icon"]
        weatherdelegate.icon=icon.stringValue
        updateui()
        
        
        
        
    
    }
    
    //Write the updateWeatherData method here:
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var location=locations[locations.count-1]
        if(location.horizontalAccuracy>0)
        {
            locationManager.stopUpdatingLocation()
            locationManager.delegate=nil
            var latitude=String(location.coordinate.latitude)
            var longitude=String(location.coordinate.longitude)
            print(latitude,longitude)
            var para=["lat":latitude,"lon":longitude,"appid":APP_ID]
            checnetwork(urrl:WEATHER_URL,parameter:para)
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text="No Location Found"
    }
    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    func updateui()
    {
        cityLabel.text=weatherdelegate.name
        temperatureLabel.text="\(weatherdelegate.tempeture)"
        var weathericon=weatherdelegate.updateWeatherIcon(condition: weatherdelegate.condirion)
        weatherIcon.image=UIImage(named: weathericon)
        
    }
    //Write the updateUIWithWeatherData method here:
    @IBAction func changecitybuttonclick(_ sender: Any) {
    var sndview=self.storyboard?.instantiateViewController(withIdentifier: "ChangeCityViewController") as! ChangeCityViewController
        sndview.delegate=self
        self.navigationController?.pushViewController(sndview, animated: true)
    }
    
    
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    
    
    
    //Write the didFailWithError method here:
    
    
    
    func citydata(city: String) {
        var dic=["q":city,"appid":APP_ID]
        print(city)
        checnetwork(urrl: WEATHER_URL, parameter: dic)
    }
    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    
    //Write the userEnteredANewCityName Delegate method here:
    

    
    //Write the PrepareForSegue Method here
    
    
    
    
    
}


