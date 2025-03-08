//
//  Health_WidgetBundle.swift
//  Health_Widget
//
//  Created by Kien Tran on 3/7/25.
//

import WidgetKit
import SwiftUI

// Main entry point for the widget bundle that contains all three widget types
@main
struct Health_WidgetBundle: WidgetBundle {
    var body: some Widget {
        StrainWidget()
        RecoveryWidget()
        SleepWidget()
    }
}
