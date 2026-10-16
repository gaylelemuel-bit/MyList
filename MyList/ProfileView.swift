//
//  ProfileView.swift
//  MyList
//
//  Created by Lemuel Gayle on 10/15/26.
//

import SwiftUI


struct ProfileView: View {
    @State private var profiles: [Profile] = Profile.sample
    @State private var path = NavigationPath()
    let colums = [
        GridItem(.flexible(), spacing:20),
        GridItem(.flexible(), spacing:20)
    ]
    var body: some View {
        NavigationStack(path: $path){
            ZStack {
                ScrollView {
                    VStack (spacing: 40){
                        VStack {
                            Text("Welcome Back")
                                .font(.subheadline)
                                .textCase(.uppercase)
                                .padding(.top, 40)
                            Text("Choose a profile")
                                .font(.system(size:28, weight: .bold))
                        }
                        LazyVGrid(columns: colums, spacing: 25) {
                            ForEach($profiles) {$profile in
                                NavigationLink(value: profile) {                                    profileCardView(profile: profile)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Home")
            // TODO: Finish this toolbar button. A bare `Button` with no label or action does not compile.
            //.toolbar {
            //    ToolbarItem(placement: .topBarTrailing) {
            //        Button
            //    }
            //}
            .navigationDestination(for: Profile.self) { selectedProfile in
                if let index = profiles.firstIndex(where: {$0.id ==
                    selectedProfile.id}) {
                    ContentView(profile: $profiles[index])
                }
            }
        }
    }
}




struct profileCardView: View {
    let profile: Profile
    
    var body: some View {
        VStack(spacing: 15){
            ZStack {
                Image(profile.profileImage)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 22))
            }
            .frame(width: 120, height: 120)
            Text(profile.name)
                .fontWeight(.bold)
                .foregroundColor(.red)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 25)
        .background(RoundedRectangle(cornerRadius: 25).fill(Color(UIColor.secondarySystemBackground)))
    }
}
