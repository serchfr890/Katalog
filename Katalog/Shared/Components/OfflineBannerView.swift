//
//  OfflineBannerView.swift
//  Katalog
//
//  Created by Sergio Flores Ramírez on 27/09/26.
//

import SwiftUI

struct OfflineBannerView: View {
    var body: some View {
        Text("Modo sin Conexión")
            .font(.footnote)
            .fontWeight(.medium)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 6)
            .background(Color.orange.opacity(0.9))
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
