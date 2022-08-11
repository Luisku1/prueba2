//
//  ViewController.swift
//  YourScheduleFit
//
//  Created by UNAM FCA 24 on 07/04/22.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
   
    var foods : [Food] = [Food]()
    var food : Food = Food()
    
    var action : String = "add"
    var type = "Mon"
    var totalCalories : Float = 0.0
     
    
    
    @IBOutlet weak var tableViewFoodAdd: UITableView!
    
    @IBOutlet weak var segFiltro: UISegmentedControl!
    
    
    @IBOutlet weak var lblTotalCalories: UILabel!
    
    
    
    @IBOutlet weak var lblDate: UILabel!
    
    var date : Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewFoodAdd.delegate = self
        tableViewFoodAdd.dataSource = self
        
        // aqui se seleccciona dependiendo el dìa del sistema a donde lo va a mandar
        segFiltro.selectedSegmentIndex = 0
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        recoverFood(type: type)
        resetTotalCalories()
        tableViewFoodAdd.reloadData()
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        formatter.locale = .current
        
        lblDate.text = formatter.string(from: Date())
    }
    
    
    @IBAction func segFilter(_ sender: UISegmentedControl) {
        
        switch segFiltro.selectedSegmentIndex {
            
        case 0...6:
            type = segFiltro.titleForSegment(at: segFiltro.selectedSegmentIndex)!
            break
        
        default:
            break
        }
        
        recoverFood(type: type)
        resetTotalCalories()
        tableViewFoodAdd.reloadData()
        
    }
    
    func recoverFood(type : String){
        
        
        let context = getContext()
        let fetchRequest : NSFetchRequest<Food> = Food.fetchRequest()
        
        if type == "*" {
            
            fetchRequest.predicate = NSPredicate(format: "type LIKE %@ OR type == nil", type)
            
        } else {
            
            fetchRequest.predicate = NSPredicate(format: "type LIKE %@", type)
            
        }
        
        
        do{
            foods = try context.fetch(fetchRequest)
        
        } catch let error as NSError {
            
            print("No se pudo recuperar \(error), \(error.userInfo)")
        }
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return foods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Celda", for: indexPath) as! TableViewCell
        
        
        
        let food = foods[indexPath.row]
        
        
        
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        
        cell.lblNameFood.text = food.nameFood
        cell.lblFoodTime.text = formatter.string(from: food.dateFood!)
        cell.lblCalories.text = String(food.caloriesFood) + " Kcal"
        cell.lblQuantity.text = String(food.quantityFood) + " g"
        cell.lblIcon.text = "🍽"
        cell.backgroundColor = Array(backGroundColours)[Int(food.colorCell!)!].value
        
        
        
        
        return cell
    }
    
    func tableView (_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let deleteAction = UIContextualAction(style: .destructive, title: nil){ [self]
            (_, _, completionHandler) in
            print("delet food")
            let food = self.foods[indexPath.row]
            self.deleteEntityFood(food)
            
            self.recoverFood(type: self.segFiltro.titleForSegment(at: segFiltro.selectedSegmentIndex)!)
                             
            resetTotalCalories()
            
            self.tableViewFoodAdd.reloadData()
            completionHandler(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return configuration
    }
    
    func getContext() -> NSManagedObjectContext{
        
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    

    func recoverData(){

        
        let context = getContext()
        let fetchRequest : NSFetchRequest<Food> = Food.fetchRequest()
        
        do{
            foods = try context.fetch(fetchRequest)
        
        } catch let error as NSError {
            
            print("could not be recovered \(error), \(error.userInfo)")
        }
        
    }
    
    @IBAction func showEscene(_ sender: UIBarButtonItem) {
        action = "add"
        performSegue(withIdentifier: "seguePrincipalToEdit", sender: nil)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let food = self.foods[indexPath.row]
        self.food = food
        
        action = "edit"
        
        performSegue(withIdentifier: "seguePrincipalToEdit", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seguePrincipalToEdit" {
            
            if action == "edit"
            {
                let viewControllerNew = segue.destination as! ViewControllerNewFood
                viewControllerNew.food = food
            }
        }
    }
    
    func deleteEntityFood(_ food: Food)
    {
        let context = getContext()
        context.delete(food)
        
        do{
            try context.save()
            
        } catch let error as NSError {
            
            print("No se pudo recuperar \(error), \(error.userInfo)")
        }
    }
    
    @IBAction func unwindToTable(_ sender: UIStoryboardSegue)
    {
        print("Comming from new food")
    }

    func resetTotalCalories(){
        totalCalories = 0
        lblTotalCalories.text = String(totalCalories)
        
        foods.map({ food in totalCalories += food.caloriesFood })
        
        lblTotalCalories.text = String(totalCalories)
    }
    
        
    }

    



