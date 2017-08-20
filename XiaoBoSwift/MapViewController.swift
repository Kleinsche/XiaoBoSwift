//
//  MapViewController.swift
//  XiaoBoSwift
//
//  Created by 🍋 on 2017/5/5.
//  Copyright © 2017年 🍋. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController,MKMapViewDelegate {
    @IBOutlet var mapView: MKMapView!
    var area : AreaMO!

    override func viewDidLoad() {
        super.viewDidLoad()
//        mapView.delegate = self
        
        mapView.showsScale = true
        mapView.showsCompass = true
        mapView.showsTraffic = true
        mapView.showsBuildings = true
        mapView.showsUserLocation = true
        mapView.showsPointsOfInterest = true

        let coder = CLGeocoder()
        coder.geocodeAddressString(area.name!) { (ps, error) in
            guard ps != nil else{
                print(error ?? "未知错误")
                return
            }
            
            let annotation = MKPointAnnotation()
            annotation.title = self.area.name
            annotation.subtitle = self.area.province
            
            if let loc = ps?.first?.location{
                annotation.coordinate = loc.coordinate
                self.mapView.showAnnotations([annotation], animated: true)
                self.mapView.selectAnnotation(annotation, animated: true)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let id = "myid"
        //重复利用
        var av = mapView.dequeueReusableAnnotationView(withIdentifier: id) as? MKPinAnnotationView
        
        if av == nil {
            av = MKPinAnnotationView.init(annotation: annotation, reuseIdentifier: id)
            av?.canShowCallout = true
        }
        
        let leftIconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 53, height: 53))
        leftIconView.image = UIImage(data: area.image! as Data)
        av?.leftCalloutAccessoryView = leftIconView
        av?.tintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        
        return av
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
