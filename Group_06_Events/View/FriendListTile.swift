//
//  FriendListTile.swift
//  Group_06_Events
//
//  Created by Vaishnavi Selvakumar Selvakumar on 2024-03-13.
//
import SwiftUI

struct FriendListTile: View {
    var friend: User
    
    var body: some View {
        HStack(alignment: .top) {
            // Conditional image based on gender
            if friend.gender == .male {
                Image("male_profile")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 84, height: 84)
            } else if friend.gender == .female {
                Image("female_profile")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 84, height: 84)
            } else {
                Image(systemName: "person")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 84, height: 84)
            }
            
            VStack(alignment: .leading) {
                Text(friend.name)
                    .font(.headline)
            }
        }
        .padding(.vertical, 5.0)
    }
}

struct FriendListTile_Previews: PreviewProvider {
    static var previews: some View {
        FriendListTile(friend: User(id: "", email: "", name: "John Doe", gender: .male))
    }
}
