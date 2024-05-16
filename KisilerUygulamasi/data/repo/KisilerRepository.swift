//
//  KisilerRepository.swift
//  KisilerUygulamasi
//
//  Created by Kaan Uzun on 14.05.2024.
//

import Foundation
import RxSwift

class KisilerRepository {
    var kisilerListesi = BehaviorSubject<[Kisiler]>(value: [Kisiler]())
    
    func kaydet(kisi_ad:String,kisi_tel:String){
        let url = URL(string: "http://kasimadalan.pe.hu/kisiler/insert_kisiler.php")!
        var istek = URLRequest(url: url)
        istek.httpMethod = "POST"
        let postString = "kisi_ad=\(kisi_ad)&kisi_tel=\(kisi_tel)"
        istek.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with: istek){ data , response , error in
            do{
                let cevap = try JSONDecoder().decode(CRUDCevap.self, from: data!)
                print("Başarı : \(cevap.success!)")
                print("Mesaj  : \(cevap.message!)")
            }catch{
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    func guncelle(kisi_id:Int,kisi_ad:String,kisi_tel:String){
        let url = URL(string: "http://kasimadalan.pe.hu/kisiler/update_kisiler.php")!
        var istek = URLRequest(url: url)
        istek.httpMethod = "POST"
        let postString = "kisi_id=\(kisi_id)&kisi_ad=\(kisi_ad)&kisi_tel=\(kisi_tel)"
        istek.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with: istek){ data , response , error in
            do{
                let cevap = try JSONDecoder().decode(CRUDCevap.self, from: data!)
                print("Başarı : \(cevap.success!)")
                print("Mesaj  : \(cevap.message!)")
            }catch{
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    func ara(aramaKelimesi:String){
        let url = URL(string: "http://kasimadalan.pe.hu/kisiler/tum_kisiler_arama.php")!
        var istek = URLRequest(url: url)
        istek.httpMethod = "POST"
        let postString = "kisi_ad=\(aramaKelimesi)"
        istek.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with: istek){ data , response , error in
            do{
                let cevap = try JSONDecoder().decode(KisilerCevap.self, from: data!)
                if let liste = cevap.kisiler {
                    self.kisilerListesi.onNext(liste)//Tetikleme
                }
            }catch{
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    func sil(kisi_id:Int){
        let url = URL(string: "http://kasimadalan.pe.hu/kisiler/delete_kisiler.php")!
        var istek = URLRequest(url: url)
        istek.httpMethod = "POST"
        let postString = "kisi_id=\(kisi_id)"
        istek.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with: istek){ data , response , error in
            do{
                let cevap = try JSONDecoder().decode(CRUDCevap.self, from: data!)
                print("Başarı : \(cevap.success!)")
                print("Mesaj  : \(cevap.message!)")
            }catch{
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    func kisileriYukle(){
        let url = URL(string: "http://kasimadalan.pe.hu/kisiler/tum_kisiler.php")!
        
        URLSession.shared.dataTask(with: url){ data , response , error in
            do{
                let cevap = try JSONDecoder().decode(KisilerCevap.self, from: data!)
                if let liste = cevap.kisiler {
                    self.kisilerListesi.onNext(liste)//Tetikleme
                }
            }catch{
                print(error.localizedDescription)
            }
        }.resume()
    }
}
