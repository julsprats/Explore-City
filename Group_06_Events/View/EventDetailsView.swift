//
//  EventDetailsView.swift
//  Group_06_Events
//
//  Created by Julia Prats on 2024-03-11.
//

import Foundation
import SwiftUI
import MapKit

struct EventDetailsView: View {
    @EnvironmentObject var firebaseAuth: FirebaseAuthHelper
    let event: Event
    @State private var isAttending = false
    
    var body: some View {
        ScrollView {
            VStack {
                Spacer()
                
                VStack(alignment: .center) {
                    Text(event.title)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    HStack {
                        ForEach(event.performers, id: \.self) { performer in
                            if let imageUrl = URL(string: performer.image) {
                                AsyncImage(url: imageUrl) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 200, height: 200)
                                        .cornerRadius(8)
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                        }
                    }
                    
                    Text("Date: \(event.datetime_utc)")
                    
                    Text("Venue: \(event.venue.name)")
                    if (event.venue.address != nil)
                    {Text("Address: \(event.venue.address!)")
                    }
                    
                    Text("\(event.venue.city), \(event.venue.state), \(event.venue.country)")
                    
                    // map view
                    MapView(venue: event.venue)
                        .frame(height: 200)
                        .cornerRadius(8)
                        .padding(.top, 20)
                    
                    // attend button
                    Button(action: {
                        isAttending.toggle()
                        
                        // add and remove event
                        if isAttending {
                            firebaseAuth.addEventToFavorites(event)
                        } else {
                            firebaseAuth.removeEventFromFavorites(event)
                        }
                    }) {
                        Text(isAttending ? "Attending" : "Attend")
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .foregroundColor(.white)
                            .background(isAttending ? Color.green : Color.blue)
                            .cornerRadius(8)
                    }
                    .padding(.top, 20)
                    
                }
                .frame(maxWidth: .infinity)
                .onAppear {
                    // check if user is attending event
                    if let user = firebaseAuth.user {
                        isAttending = user.favourites.contains(where: { $0.id == event.id })
                    }
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Event Details")
    }
}

struct EventDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleEvent = Event(id: 1, venue: Venue(id: 1, state: "State", name: "Venue Name", location: Location(lat: 0.0, lon: 0.0), address: "123 Street", country: "Country", city: "City"), title: "Concert 1", datetime_utc: "March 20, 2024", description: "Event Description", performers: [Performer(image: "https://via.placeholder.com/150")])
        return EventDetailsView(event: sampleEvent)
    }
}

struct MapView: View {
    var venue: Venue
    
    var body: some View {
        let annotation = VenueAnnotation(id: venue.id, venue: venue)
        
        Map(coordinateRegion: .constant(region), annotationItems: [annotation]) { annotation in
            MapMarker(coordinate: CLLocationCoordinate2D(latitude: annotation.venue.location.lat, longitude: annotation.venue.location.lon), tint: .blue)
        }
        .onAppear {
            let coordinate = CLLocationCoordinate2D(latitude: venue.location.lat, longitude: venue.location.lon)
            region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        }
    }
    
    @State private var region = MKCoordinateRegion()
}
