//
//  ContentView.swift
//  F1 Driver Standings URLSession
//
//  Created by Angus Muller on 13/06/2022.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: DriverStandingsViewModel
    
    var body: some View {
        List(viewModel.driverStanding, id: \.driver.driverId) { (driver) in
            ZStack {
                Circle()
                    .stroke()
                Text(driver.position)
            }
            .frame(width: 40, height: 40)
            
            VStack(alignment: .leading) {
                Text(driver.driverFullName)
                Text(driver.constructorsName ?? "")
                    .font(.subheadline)
            }
        }.onAppear(perform: loadData)
    }
    
    private func loadData() {
        
        viewModel.refresh()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let f1Service = F1APIService()
        let repository = F1Repository(f1Service: f1Service)
        let viewModel = DriverStandingsViewModel(f1Repository: repository)
        ContentView(viewModel: viewModel)
    }
}
