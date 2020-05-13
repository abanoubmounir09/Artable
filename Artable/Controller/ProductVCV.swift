//
//  ProductVCV.swift
//  Artable
//
//  Created by pop on 5/12/20.
//  Copyright © 2020 pop. All rights reserved.
//

import UIKit
import FirebaseFirestore
class ProductVCV: UIViewController {
    //OUtlets
    @IBOutlet weak var tableView: UITableView!
  
    //Variables
    var category:Category!
    var products = [Product]()
    var db:Firestore!
    var listener:ListenerRegistration!
    override func viewDidLoad() {
        super.viewDidLoad()
         initTableView()
         db = Firestore.firestore()
         navigationItem.title = category.name
        setProductListner()
    }
    
    func initTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: identefiers.ProductCell, bundle: nil), forCellReuseIdentifier: identefiers.ProductCell)
    }

    func setProductListner(){
        listener = db.collection("products").whereField("category", isEqualTo: category.id).addSnapshotListener({ (snap, error) in
            if let error = error{
                self.simpleAlert(title: "error", message: error.localizedDescription)
                return
            }
            snap?.documentChanges.forEach({ (change) in
                let data = change.document.data()
                let product = Product.init(data: data)
                switch change.type{
                case .added:
                  self.onDecomentAdded(change: change, product: product)
                case .modified:
                  self.onDecomentUpdated(change: change, product: product)
                case .removed:
                  self.onDecomentRemoved(change: change)
                }
            })
        })
    }
 
}// END CLASS




extension ProductVCV:UITableViewDelegate,UITableViewDataSource{
    
    func onDecomentAdded(change:DocumentChange,product:Product){
        let newIndex = Int(change.newIndex)
        products.insert(product, at: newIndex)
        tableView.insertRows(at: [IndexPath(row: newIndex, section: 0)], with: UITableView.RowAnimation.left)
    }
    func onDecomentUpdated(change:DocumentChange,product:Product){
        if change.oldIndex == change.newIndex{
            let index = Int(change.oldIndex)
            products[index] = product
            tableView.reloadRows(at:[IndexPath(row: index, section: 0)], with: UITableView.RowAnimation.left)
           
        }else{
            let oldIndex = Int(change.oldIndex)
            let newIndex = Int(change.newIndex)
            products.remove(at: oldIndex)
            products.insert(product, at: newIndex)
            tableView.moveRow(at: IndexPath(row: oldIndex, section: 0), to: IndexPath(row: newIndex, section: 0))
        }
    }
    
    func onDecomentRemoved(change:DocumentChange){
        let oldIndex = Int(change.oldIndex)
        products.remove(at: oldIndex)
        tableView.deleteRows(at: [IndexPath(row: oldIndex, section: 0)], with: UITableView.RowAnimation.left)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: identefiers.ProductCell, for: indexPath) as? ProductCell{
            cell.configureCell(product: products[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedproduct = products[indexPath.row]
        let vc = ProductDetailVC()
        vc.product = selectedproduct
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
}
