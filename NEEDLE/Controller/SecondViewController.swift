//
//  SecondViewController.swift
//  niddle
//
//  Created by Jason Kim on 2017. 11. 29..
//  Copyright © 2017년 JasonKim. All rights reserved.
//

import UIKit
import SwiftyJSON
import Firebase
import CoreData

class SecondViewController: UIViewController,NMapViewDelegate, NMapPOIdataOverlayDelegate,UISearchResultsUpdating,NMapLocationManagerDelegate,MMapReverseGeocoderDelegate,NSFetchedResultsControllerDelegate{
    
    @IBAction func unwindToMap(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    var fetchResultController: NSFetchedResultsController<EventMO>!
    let fetchRequest: NSFetchRequest<EventMO> = EventMO.fetchRequest()
    let sortDescriptor = NSSortDescriptor(key: "registerTime", ascending: true)
        //fetchRequest.sortDescriptors = [sortDescriptor]
    
    
    
    open func location(_ location: NGeoPoint, didFind placemark: NMapPlacemark!) {
        let address = placemark.address
        
        self.title = address
        
        let alert = UIAlertController(title: "ReverseGeocoder", message: address, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    open func location(_ location: NGeoPoint, didFailWithError error: NMapError!) {
        print("location:(\(location.longitude), \(location.latitude)) didFailWithError: \(error.description)")
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    
    var mapView: NMapView?
    var changeStateButton: UIButton?
    var Events : [Event] = []
    //var Pins : [NGeoPoint] = []
    @IBOutlet weak var addButton: UIButton!
    enum state {
        case disabled
        case tracking
        case trackingWithHeading
    }
    
    
    var currentState: state = .tracking
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var colors = [UIColor]()
        colors.append(UIColor(red: 136, green: 128, blue: 216))
        colors.append(UIColor(red: 91, green: 143, blue: 191))
        navigationController?.navigationBar.setGradientBackground(colors: colors)
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        
        callEvents()
        while NDEvents.count == 0 {}
        
        mapView = NMapView(frame: self.view.frame)
        
        print(Events)
        
        if let mapView = mapView {
            
            
            // set the delegate for map view
            mapView.delegate = self
            
            
            // set the application api key for Open MapViewer Library
            mapView.setClientId("eBknY0lClg3MZUJW1TOB")
            
            
            mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            
            view.addSubview(mapView)
        }
        
        // Add Controls.
        changeStateButton = createButton()
        
        if let button = changeStateButton {
            view.addSubview(button)
            updateState(.tracking)
        }
        
        view.addSubview(addButton)
        
     
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        
        if view.frame.size.width != size.width {
            if let mapView = mapView, mapView.isAutoRotateEnabled {
                mapView.setAutoRotateEnabled(false, animate: false)
                
                coordinator.animate(alongsideTransition: {(context: UIViewControllerTransitionCoordinatorContext) -> Void in
                    if let mapView = self.mapView {
                        mapView.setAutoRotateEnabled(true, animate: false)
                    }
                }, completion: nil)
                
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        mapView?.didReceiveMemoryWarning()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateState(.tracking)
        enableLocationUpdate()
        
        mapView?.viewWillAppear()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let helper = DispatchQueue(label : "forUpdatePins")
        helper.sync {
        updatePins()
        }
        
        addMarker(NDPins)
        mapView?.viewDidAppear()
        
    }
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
       
        
        mapView?.viewDidDisappear()
    }
    
    // MARK: - NMapViewDelegate Methods
    
    open func onMapView(_ mapView: NMapView!, initHandler error: NMapError!) {
        if (error == nil) { // success
            // set map center and level
            mapView.setMapCenter(NGeoPoint(longitude:126.978371, latitude:37.5666091), atLevel:11)
            // set for retina display
            mapView.setMapEnlarged(true, mapHD: true)
            // set map mode : vector/satelite/hybrid
            mapView.mapViewMode = .vector
        } else { // fail
            print("onMapView:initHandler: \(error.description)")
        }
    }
    /*
     open func onMapView(_ mapView: NMapView!, touchesEnded touches: Set<AnyHashable>!, with event: UIEvent!) {
     
     if let touch = event.allTouches?.first {
     // Get the specific point that was touched
     let scrPoint = touch.location(in: mapView)
     
     print("scrPoint: \(scrPoint)")
     print("to: \(mapView.fromPoint(scrPoint))")
     requestAddressByCoordination(mapView.fromPoint(scrPoint))
     }
     }
     */
    func requestAddressByCoordination(_ point: NGeoPoint) {
        mapView?.findPlacemark(atLocation: point)
        
        setMarker(point)
    }
    let UserFlagType: NMapPOIflagType = NMapPOIflagTypeReserved + 1
    
    func setMarker(_ point: NGeoPoint) {
        
        clearOverlay()
        
        if let mapOverlayManager = mapView?.mapOverlayManager {
            
            // create POI data overlay
            if let poiDataOverlay = mapOverlayManager.newPOIdataOverlay() {
                
                poiDataOverlay.initPOIdata(1)
                
                poiDataOverlay.addPOIitem(atLocation: point, title: "마커 1", type: UserFlagType, iconIndex: 0, with: nil)
                
                poiDataOverlay.endPOIdata()
            }
        }
    }
    func clearOverlay() {
        if let mapOverlayManager = mapView?.mapOverlayManager {
            mapOverlayManager.clearOverlay()
        }
    }
    
    
    
   
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
        mapView?.viewWillDisappear()
        
        
        stopLocationUpdating()
    }
    
    
    // MARK: - NMapPOIdataOverlayDelegate Methods
    
    open func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, imageForOverlayItem poiItem: NMapPOIitem!, selected: Bool) -> UIImage! {
        return NMapViewResources.imageWithType(poiItem.poiFlagType, selected: selected)
    }
    func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, viewForCalloutOverlayItem poiItem: NMapPOIitem!, calloutPosition: UnsafeMutablePointer<CGPoint>!) -> UIView?{
        let vvv = UIView(frame : CGRect(x:0,y:self.view.bounds.size.height-300,width:self.view.bounds.size.width,height:200))
        
        vvv.backgroundColor = UIColor.blue
        return vvv
        
    }
    
    open func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, anchorPointWithType poiFlagType: NMapPOIflagType) -> CGPoint {
        return NMapViewResources.anchorPoint(withType: poiFlagType)
    }
    
    
    open func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, calloutOffsetWithType poiFlagType: NMapPOIflagType) -> CGPoint {
        return CGPoint.zero
    }
    
    
    open func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, imageForCalloutOverlayItem poiItem: NMapPOIitem!, constraintSize: CGSize, selected: Bool, imageForCalloutRightAccessory: UIImage!, calloutPosition: UnsafeMutablePointer<CGPoint>!, calloutHit calloutHitRect: UnsafeMutablePointer<CGRect>!) -> UIImage! {
        return nil
    }
    
    
    // MARK: - NMapLocationManagerDelegate Methods
    
    open func locationManager(_ locationManager: NMapLocationManager!, didUpdateTo location: CLLocation!) {
        
        
        let coordinate = location.coordinate
        
        
        let myLocation = NGeoPoint(longitude: coordinate.longitude, latitude: coordinate.latitude)
        let locationAccuracy = Float(location.horizontalAccuracy)
        
        
        mapView?.mapOverlayManager.setMyLocation(myLocation, locationAccuracy: locationAccuracy)
        mapView?.setMapCenter(myLocation)
    }
    
    
    open func locationManager(_ locationManager: NMapLocationManager!, didFailWithError errorType: NMapLocationManagerErrorType) {
        
        
        var message: String = ""
        
        
        switch errorType {
        case .unknown: fallthrough
        case .canceled: fallthrough
        case .timeout:
            message = "일시적으로 내위치를 확인 할 수 없습니다."
        case .denied:
            message = "위치 정보를 확인 할 수 없습니다.\n사용자의 위치 정보를 확인하도록 허용하시려면 위치서비스를 켜십시오."
        case .unavailableArea:
            message = "현재 위치는 지도내에 표시할 수 없습니다."
        case .heading:
            message = "나침반 정보를 확인 할 수 없습니다."
        }
        
        
        if (!message.isEmpty) {
            let alert = UIAlertController(title:"NMapViewer", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"OK", style:.default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        
        
        if let mapView = mapView, mapView.isAutoRotateEnabled {
            mapView.setAutoRotateEnabled(false, animate: true)
        }
    }
    
    
    func locationManager(_ locationManager: NMapLocationManager!, didUpdate heading: CLHeading!) {
        let headingValue = heading.trueHeading < 0.0 ? heading.magneticHeading : heading.trueHeading
        setCompassHeadingValue(headingValue)
    }
    
    
    func onMapViewIsGPSTracking(_ mapView: NMapView!) -> Bool {
        return NMapLocationManager.getSharedInstance().isTrackingEnabled()
    }
    
    func findCurrentLocation() {
        enableLocationUpdate()
    }
    
    
    func setCompassHeadingValue(_ headingValue: Double) {
        
        if let mapView = mapView, mapView.isAutoRotateEnabled {
            mapView.setRotateAngle(Float(headingValue), animate: true)
        }
    }
    
    
    func stopLocationUpdating() {
        
        disableHeading()
        disableLocationUpdate()
    }
    
    // MARK: - My Location
    
    func enableLocationUpdate() {
        
        if let lm = NMapLocationManager.getSharedInstance() {
            
            if lm.locationServiceEnabled() == false {
                locationManager(lm, didFailWithError: .denied)
                return
            }
            
            if lm.isUpdateLocationStarted() == false {
                // set delegate
                lm.setDelegate(self)
                // start updating location
                lm.startContinuousLocationInfo()
            }
        }
    }
    
    func disableLocationUpdate() {
        
        
        if let lm = NMapLocationManager.getSharedInstance() {
            
            if lm.isUpdateLocationStarted() {
                // start updating location
                lm.stopUpdateLocationInfo()
                // set delegate
                lm.setDelegate(nil)
            }
        }
        
        mapView?.mapOverlayManager.clearMyLocationOverlay()
    }
    
    // MARK: - Compass
    
    func enableHeading() -> Bool {
        
        
        if let lm = NMapLocationManager.getSharedInstance() {
            
            
            let isAvailableCompass = lm.headingAvailable()
            
            if isAvailableCompass {
                
                mapView?.setAutoRotateEnabled(true, animate: true)
                
                lm.startUpdatingHeading()
            } else {
                return false
            }
        }
        
        return true;
    }
    
    func disableHeading() {
        if let lm = NMapLocationManager.getSharedInstance() {
            
            
            let isAvailableCompass = lm.headingAvailable()
            
            if isAvailableCompass {
                lm.stopUpdatingHeading()
            }
        }
        
        mapView?.setAutoRotateEnabled(false, animate: true)
    }
    
    // MARK: - Button Control
    
    func createButton() -> UIButton? {
        
        let button = UIButton(type: .custom)
        
        button.frame = CGRect(x: 15, y: 30, width: 36, height: 36)
        button.setImage(#imageLiteral(resourceName: "v4_btn_navi_location_normal"), for: .normal)
        
        
        button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        
        return button
    }
    
    
    func createAddButton() -> UIButton? {
        
        let button = UIButton(type: .custom)
        if let mapView = self.mapView{
            button.frame = CGRect(x: mapView.bounds.size.width-100, y: mapView.bounds.size.height-200, width: 80, height: 80)
        }
        //button.frame = CGRect(x: 354, y: 300, width: 30, height: 30)
        button.setImage(UIImage(named:"addButton"), for: .normal)
        button.imageView!.contentMode = UIViewContentMode.scaleAspectFill
        
        
        //button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        
        return button
    }
    
    @objc func buttonClicked(_ sender: UIButton!) {
        
        if let lm = NMapLocationManager.getSharedInstance() {
            
            switch currentState {
            case .disabled:
                enableLocationUpdate()
                updateState(.tracking)
            case .tracking:
                let isAvailableCompass = lm.headingAvailable()
                
                if isAvailableCompass {
                    enableLocationUpdate()
                    if enableHeading() {
                        updateState(.trackingWithHeading)
                    }
                } else {
                    stopLocationUpdating()
                    updateState(.disabled)
                }
            case .trackingWithHeading:
                stopLocationUpdating()
                updateState(.disabled)
            }
        }
    }
    
    func updateState(_ newState: state) {
        
        currentState = newState
        
        switch currentState {
        case .disabled:
            changeStateButton?.setImage(#imageLiteral(resourceName: "v4_btn_navi_location_normal"), for: .normal)
        case .tracking:
            changeStateButton?.setImage(#imageLiteral(resourceName: "v4_btn_navi_location_selected"), for: .normal)
        case .trackingWithHeading:
            changeStateButton?.setImage(#imageLiteral(resourceName: "v4_btn_navi_location_my"), for: .normal)
        }
    }
    
    func addMarker(_ pins:[NGeoPoint]) {
        
        if let mapOverlayManager = mapView?.mapOverlayManager {
            
            // create POI data overlay
            if let poiDataOverlay = mapOverlayManager.newPOIdataOverlay() {
                
                poiDataOverlay.initPOIdata(Int32(pins.count))
                for index in pins{
                    let poiItem = poiDataOverlay.addPOIitem(atLocation: NGeoPoint(longitude: index.longitude, latitude: index.latitude), title: "Touch & Drag to Move", type: UserPOIflagTypeDefault, iconIndex: 0, with: nil)
                    poiItem?.setPOIflagMode(.fixed)
                }
                //                let poiItem = poiDataOverlay.addPOIitem(atLocation: NGeoPoint(longitude: 126.979, latitude: 37.567), title: "Touch & Drag to Move", type: UserPOIflagTypeDefault, iconIndex: 0, with: nil)
                
                // set floating mode
                
                
                // hide right button on callout
                // poiItem?.hasRightCalloutAccessory = false
                
                poiDataOverlay.endPOIdata()
                
                // select item
                //poiDataOverlay.selectPOIitem(at: 0, moveToCenter: true)
                poiDataOverlay.selectPOIitem(at: 0)
                // show all POI data
                poiDataOverlay.showAllPOIdata()
            }
        }
    }
    
    
    func clearOverlays() {
        if let mapOverlayManager = mapView?.mapOverlayManager {
            mapOverlayManager.clearOverlays()
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //mapView.beginUpdates()
        
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            //if let newIndexPath = newIndexPath { tableView.insertRows(at: [newIndexPath], with: .fade)            }
            addMarker(NDPins)
        case .delete:
            //if let indexPath = indexPath { tableView.deleteRows(at: [indexPath], with: .fade)            }
            addMarker(NDPins)
        case .update:
          //  if let indexPath = indexPath { tableView.reloadRows(at: [indexPath], with: .fade)            }
            addMarker(NDPins)
        default:
                self.viewDidAppear(true)
        }
        if let fetchedObjects = controller.fetchedObjects {
            NDEvents = fetchedObjects as! [EventMO]
        }
        
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
       // mapView.endUpdates()
        
    }
    
    
}

