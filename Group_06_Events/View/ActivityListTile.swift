//
//  ActivityListTile.swift
//  Group_06_Events
//
//  Created by Vaishnavi Selvakumar on 2024-03-14.
//
import SwiftUI

struct ActivityListTile: View {
    var event: Event
    
    var body: some View {
        HStack(alignment: .top) {
            if let firstPerformerImageUrl = URL(string: event.performers.first?.image ?? "") {
                AsyncImage(url: firstPerformerImageUrl) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .cornerRadius(8)
                    default:
                        Image(systemName: "person.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .cornerRadius(8)
                    }
                }
            } else {
                Image(systemName: "person.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .cornerRadius(8)
            }
            
            VStack(alignment: .leading) {
                Text(event.title)
                    .font(.headline)
//                Text(event.datetime_utc)
//                    .font(.subheadline)
//                if let address = event.venue.address {
//                    Text(address)
//                        .font(.subheadline)
//                }
            }
            .padding()
            
            Spacer()
        }
        .padding(.vertical, 5.0)
    }
}
