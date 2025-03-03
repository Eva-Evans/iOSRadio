//
//  RadioFetcher.swift
//  RadioSUI
//  Created by brfsu on 24.04.2024.
//
import Foundation

public class RadioFetcher: ObservableObject {
    static let shared = RadioFetcher()
    
    @Published var isLoading = true
    @Published var efirs = [EfirM]()
    @Published var favEfirs = [EfirM]()
    
    private let favouritesKey = "favourites"
    
    init() {
        load()
    }
    
    func load() {
        isLoading = true
        guard let url = URL(string: "https://de1.api.radio-browser.info/json/stations/bycodec/aac?limit=60&order=clocktrend&hidebroken=true") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            do {
                if let data = data {
                    let decodedLists = try JSONDecoder().decode([EfirM].self, from: data)
                    DispatchQueue.main.async {
                        self.efirs = decodedLists.filter { !$0.name.isEmpty && $0.imageUrl.absoluteString != "https://i.postimg.cc/dVhrFLff/temp-Image-Ox-S6ie.avif" }
                        self.isLoading = false
                    }
                } else {
                    print("No data.")
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                }
            } catch {
                print("Error: \(error)")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }.resume()
        
        
    }
    
    // Сохранение массива названий избранных станций в UserDefaults
    func saveFavourites(_ favEfirs: [EfirM]) { // UUID
        let favStrArr = favEfirs.map({ $0.name })
        UserDefaults.standard.set(favStrArr, forKey: favouritesKey)
        UserDefaults.standard.synchronize()
    }
        
    // Получение массива избранных названий станций из UserDefaults
    private func getFavourites() -> [EfirM] {
        let favStrArr = UserDefaults.standard.array(forKey: favouritesKey) as? [String] ?? []
        let efirsStrArr = self.efirs.map({ $0.name })
        let newFavStrArr = favStrArr.filter { efirsStrArr.contains($0) }
        let newfavArr = efirs.filter { newFavStrArr.contains($0.name) }
        self.favEfirs = newfavArr
        return newfavArr
    }
    
    func favAdd(efir: EfirM) {
        favEfirs.append(efir)
    }

    func favDel(efir: EfirM) {
        favEfirs.removeAll() { $0 == efir }
    }
    
    func removeEfir(at offsets: IndexSet) {
        efirs.remove(atOffsets: offsets)
        //saveEfirs()
    }
}
