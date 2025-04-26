//
//  TrialStatusView.swift
//  AirClipboard
//
//  Created by Ariel Marques on 26/04/25.
//

import SwiftUI

struct TrialStatusView: View {
    @ObservedObject private var environment = AppEnvironment.shared

    var body: some View {
        if environment.licenseStatus == .trial {
            let days = environment.trialDaysLeft

            HStack(spacing: 8) {
                Image(systemName: "hourglass.bottomhalf.fill")
                    .foregroundColor(.orange)

                if days > 0 {
                    Text("trial_days_left \(days)")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                } else {
                    Text("trial_expired_message")
                        .font(.footnote)
                        .foregroundColor(.red)
                }

                Spacer()

                Button(action: {
                    AppDelegate.shared?.showPreferences(selecting: .license)
                }) {
                    Text("upgrade_button_label")
                        .font(.footnote)
                        .fontWeight(.medium)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.accentColor.opacity(0.15))
                        .foregroundColor(.accentColor)
                        .cornerRadius(6)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 12)
            .padding(.top, 6)
            .padding(.bottom, 6)
        }
    }
}
