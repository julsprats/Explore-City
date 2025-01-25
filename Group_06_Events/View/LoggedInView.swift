//
//  LoggedInView.swift
//  Group_06_Events
//
//  Created by Darren Eddy on 2024-03-11.
//

import SwiftUI
import MapKit

struct LoggedInView: View {
    @EnvironmentObject var firebaseAuth: FirebaseAuthHelper
    @EnvironmentObject var fireDB : FireDBHelper
    @EnvironmentObject var locationHelper: LocationHelper
    
    @State var displayCity = "Toronto"
    @State var showMap = false
    @State var events : [Event] = [Event]()

    
    

    
    var body: some View {
        VStack{
            Toggle("Show Map", isOn: $showMap).padding()
            
            if (showMap) {
                MyMap(events: events).environmentObject(locationHelper)
            } else {
                Text("Showing Results for \(self.displayCity)")
               
                List {
                    ForEach(events, id: \.id) { event in
                        NavigationLink(destination: EventDetailsView(event: event)) {
                            ActivityListTile(event: event)
                        }
                    }
                }
                .searchable(text: $displayCity)
                .onSubmit(of: .search) {
                    loadEventsFromApi()
                }
            
            }
            
        }.onAppear{
            loadEventsFromApi()
        }
        

    }
    
    
    func loadEventsFromApi()
    {
        
        let websiteAddress:String = "https://api.seatgeek.com/2/events?venue.city=\(self.displayCity)&client_id=NDAzODA3NTJ8MTcxMDM1NjcxOC4zNjU3NTU2"
        print (#function,"Trying API: \(websiteAddress)")
        guard let apiURL = URL(string: websiteAddress) else {
            print("ERROR: Can not convert api address to url object")
            return
        }
        //request object
        let request = URLRequest(url: apiURL)
        
        //use request object > COnnect to api > Handle Result
        let task = URLSession.shared.dataTask(with: request) {
            
            (data:Data?,response,error) in
            //checking if data retrieved
            if let jsonData = data{
                print(#function,jsonData)
                
                if let decodedResponse = try? JSONDecoder().decode(Events.self, from:jsonData) {
                    DispatchQueue.main.async{
                        self.events = decodedResponse.events
                    }
                    
                }
            }
        }
    
        task.resume()
    }

    
}

//
struct MyMap : UIViewRepresentable{
    
    typealias UIViewType = MKMapView
    
    private var events : [Event]
    private var locations : [CLLocation]
    
    @EnvironmentObject var locationHelper : LocationHelper
    let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
    
    init(events: [Event]) {
        self.events = events
        self.locations = [CLLocation]()
        
        for i in self.events {
            locations.append(CLLocation(latitude: i.venue.location.lat, longitude: i.venue.location.lon))
        }
    }
    
    func makeUIView(context: Context) -> MKMapView {
        
        let sourceCoordinates : CLLocationCoordinate2D
        let region : MKCoordinateRegion
        
        if (self.locationHelper.currentLocation != nil){
            sourceCoordinates = self.locationHelper.currentLocation!.coordinate
        }else{
            sourceCoordinates = CLLocationCoordinate2D(latitude: 43.64732, longitude: -79.38279)
        }
        
        region = MKCoordinateRegion(center: sourceCoordinates, span: span)
        
        let map = MKMapView(frame: .infinite)
        map.mapType = MKMapType.standard
        map.isZoomEnabled = true
        map.isUserInteractionEnabled = true
        map.showsUserLocation = true
        
        map.setRegion(region, animated: true)
        
        return map
        
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
        let sourceCoordinates : CLLocationCoordinate2D
        let region : MKCoordinateRegion
        
        region = MKCoordinateRegion(center: locations[0].coordinate, span: span)
        
        for i in 0...locations.count-1 {
            let mapAnnotation = MKPointAnnotation()
            mapAnnotation.coordinate = locations[i].coordinate
            mapAnnotation.title = events[i].title
            uiView.addAnnotation(mapAnnotation)
        }

        uiView.setRegion(region, animated: true)

        
    }
    
}
