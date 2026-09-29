//
//  OfflineBannerView.swift
//  Katalog
//
//  Created by Sergio Flores Ramírez on 27/09/26.
//

import SwiftUI

struct OfflineBannerView: View {
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "wifi.slash")
                .symbolEffect(.pulse)
            Text("Offline Mode")
                .fontWeight(.medium)
        }
        .font(.footnote)
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 6)
        .background(Color(.systemOrange).gradient)
        .background(.ultraThinMaterial)
    }
}

private struct OfflineBannerModifier: ViewModifier {
    let isConnected: Bool

    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            if !isConnected {
                OfflineBannerView()
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
            content
        }
        .animation(.easeInOut(duration: 0.3), value: isConnected)
    }
}

extension View {
    func offlineBanner(isConnected: Bool) -> some View {
        modifier(OfflineBannerModifier(isConnected: isConnected))
    }
}

#Preview {
    VStack {
        Spacer()
        Text("Contenido")
        Spacer()
    }
    .offlineBanner(isConnected: false)
}
