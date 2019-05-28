//
//  SnapsViewController.swift
//  Snapchat
//
//  Created by MAC13 on 16/05/19.
//  Copyright © 2019 luis huarachi. All rights reserved.
//

import UIKit
import Firebase

class SnapsViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var tablaSnaps: UITableView!
    var snaps:[Snap] = []
    @IBAction func cerrarSesionTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snaps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let snap = snaps[indexPath.row]
        cell.textLabel?.text = snap.from
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snap = snaps[indexPath.row]
        performSegue(withIdentifier: "versnapsegue", sender: snap)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "versnapsegue"{
            let siguienteVC = segue.destination as! VerSnapViewController
            siguienteVC.snap = sender as! Snap
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tablaSnaps.delegate = self
        tablaSnaps.dataSource = self
        
        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("snaps")
            .observe(DataEventType.childAdded, with: {(snapshot) in
                let snap = Snap()
                snap.imagenURL = (snapshot.value as! NSDictionary)["imagenURL"] as! String
                snap.from = (snapshot.value as! NSDictionary)["from"] as! String
                snap.descrip = (snapshot.value as! NSDictionary)["descripcion"] as! String
                snap.id = snapshot.key
                snap.imagenID = (snapshot.value as! NSDictionary)["imagenID"] as! String
                self.snaps.append(snap)
                self.tablaSnaps.reloadData()
            })
        
        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!)
            .child("snaps").observe(DataEventType.childRemoved,with: { (snapshot ) in
                var iterator = 0
                for snap in self.snaps{
                    if snap.id == snapshot.key{
                        self.snaps.remove(at: iterator)
                    }
                    iterator += 1
                }
                self.tablaSnaps.reloadData()
            })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
