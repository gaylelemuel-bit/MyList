//
//  MyListApp.swift
//  MyList
//
//  Created by Lemuel Gayle on 10/3/26.
//

import SwiftUI

@main
struct MyListApp: App {
    @State private var isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
