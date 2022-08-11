//
//  ViewControllerNewFood.swift
//  YourScheduleFit
//
//  Created by UNAM FCA 24 on 07/04/22.
//

import UIKit
import CoreData

class ViewControllerNewFood: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    
    
    var food : Food?
    
    @IBOutlet weak var txtNameFood: UITextField!
    
    @IBOutlet weak var txtFoodCalories: UITextField!
    
    @IBOutlet weak var segFilter: UISegmentedControl!
    
    @IBOutlet weak var txtQuantityFood: UITextField!
    
    @IBOutlet weak var txtFoodSchedule: UITextField!
    
    var color: String = "7"
    
    @IBOutlet weak var pickerViewButton: UIButton!
    let screenWidth = UIScreen.main.bounds.width - 10
    let screenHeight = UIScreen.main.bounds.height / 2
    var selectedRow = 0
    
    
    
    @IBAction func popUpPicker(_ sender: Any) {
        
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: screenWidth, height: screenHeight)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        pickerView.dataSource = self
        pickerView.delegate = self
        
        pickerView.selectRow(selectedRow, inComponent: 0, animated: false)
        vc.view.addSubview(pickerView)
        pickerView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        pickerView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
        
        let alert = UIAlertController(title: "Select Backgroung colour celd", message: "", preferredStyle: .actionSheet)
        
        alert.popoverPresentationController?.sourceView = pickerViewButton
        alert.popoverPresentationController?.sourceRect = pickerViewButton.bounds
        
        alert.setValue(vc , forKey: "contentViewController")
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction)
            in
        }))
        
        alert.addAction(UIAlertAction(title: "Select", style: .default, handler: { (UIAlertAction)
            in
            self.selectedRow = pickerView.selectedRow(inComponent: 0)
            let selected = Array(backGroundColours)[self.selectedRow]
            self.color = String(self.selectedRow)
            let name = selected.key
            //self.view.backgroundColor = colour
            self.pickerViewButton.setTitle(name, for: .normal)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 30))
        label.text = Array(backGroundColours)[row].key
        label.sizeToFit()
        return label
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        backGroundColours.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
    
    let timePicker = UIDatePicker()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        
        createTimePicker()
        
        if food != nil
        {
            navigationItem.title = "🔥Edit Food🥦"
            txtNameFood.text = food?.nameFood
            txtFoodCalories.text = String(food!.caloriesFood)
            txtQuantityFood.text = String(food!.quantityFood)
            txtFoodSchedule.text = formatter.string(from: food!.dateFood!)
            
            if food?.type == "Mon" {
                
                segFilter.selectedSegmentIndex = 0
                
            } else {
                
                if food?.type == "Tues"
                {
                    segFilter.selectedSegmentIndex =  1
                    
                } else {
                    
                    if food?.type == "Wed"{
                        segFilter.selectedSegmentIndex =  2
                    } else {
                        
                        if food?.type == "Thurs"{
                            segFilter.selectedSegmentIndex = 3
                        } else{
                            if food?.type == "Fri"{
                                segFilter.selectedSegmentIndex = 4
                            } else{
                                if food?.type == "Sat"{
                                    segFilter.selectedSegmentIndex = 5
                                } else {
                                    segFilter.selectedSegmentIndex = 6
                                }
                            }
                        }
                    }
                    
                    
                }

            }
                
        } else {
            
            navigationItem.title = "🥩Add Food🥦"
        }
        
    }
    
    @IBAction func addEditFood(_ sender: UIButton) {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        
        if let nameFood = txtNameFood.text, let caloriesFood = txtFoodCalories.text, let quantityFood = txtQuantityFood.text,let dateFood = txtFoodSchedule.text, let type = segFilter.titleForSegment(at: segFilter.selectedSegmentIndex) {
            if !nameFood.isEmpty && !quantityFood.isEmpty && !dateFood.isEmpty && !caloriesFood.isEmpty
            {
                if navigationItem.title == "🔥Edit Food🥦"
                {
                    
                    validateQantityCalories(quantity: quantityFood, calories: caloriesFood) { [self] validate in
                        
                        if validate{
                            
                            updateEntityFood(food : self.food!, nameFood : nameFood, caloriesFood: caloriesFood, quantityFood : quantityFood, dateFood : dateFood,type : type, color)
                            
                            self.food = nil
                            
                            self.navigationController?.popViewController(animated: true)
                            
                        } else {
                            
                            self.sendError(title: "Error", message: "Usa números para expresar las calorías y la cantidad")
                            
                        }
                            
                            
                    }
                
                } else {
                    
                   
                    validateQantityCalories(quantity: quantityFood, calories: caloriesFood) { [self] validate in
                        
                        if validate
                        {
                            saveEntityFood(nameFood, Float(caloriesFood)! ,Float(quantityFood)! , dateFood, type, color)
                            
                            self.navigationController?.popViewController(animated: true)
                        
                        } else {
                            
                            sendError(title: "Error", message: "Usa números para expresar las calorías y la cantidad")
                        }
                        
                        
                    }
                        
                    
                }
            
            } else {
                
                sendError(title: "Error", message: "Fill all the fields")
                
            }
        }
            
           
        
    }
    
    func validateQantityCalories(quantity : String, calories : String, completion: @escaping (Bool) -> Void)
    {
        if let _ = Float(quantity), let _ = Float(calories)
        {
            completion(true)
            
        } else {
            
            completion(false)
        }
    }
    
    func sendError(title : String, message: String){
        
        let alertCrontoller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertCrontoller.addAction(UIAlertAction(title: "YES", style: .default))
        self.present(alertCrontoller, animated: true, completion: nil)
        
    }
    
    func getContext() -> NSManagedObjectContext{
        
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func saveEntityFood(_ nameFood : String, _ caloriesFood : Float, _ quantityFood : Float,_ dateFood : String , _ type : String, _ color : String)
    {
        let context = getContext()
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        
        let entityFood = NSEntityDescription.entity(forEntityName: "Food", in: context)!
        let personManaged = NSManagedObject(entity: entityFood, insertInto: context) as! Food
                
        personManaged.nameFood = nameFood
        personManaged.caloriesFood = caloriesFood
        personManaged.dateFood = formatter.date(from: dateFood)!
        personManaged.quantityFood = quantityFood
        personManaged.type = type
        personManaged.colorCell = color
       
        
        do{
            try context.save()
        
        } catch let error as NSError {
            
            print("Could not be saved: \(error), \(error.userInfo)")
        }
        
        
    }

    
    func updateEntityFood(food : Food, nameFood : String, caloriesFood: String, quantityFood : String, dateFood : String,type : String, _ color: String)
    {
        let context = getContext()
        let personManaged = food as NSManagedObject
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        
        personManaged.setValue(nameFood, forKey: "nameFood")
        
        personManaged.setValue(Float(caloriesFood)!, forKey: "caloriesFood")
        personManaged.setValue(Float(quantityFood)!, forKey: "quantityFood")
        personManaged.setValue(formatter.date(from: dateFood)!, forKey: "dateFood")
        
        personManaged.setValue(type, forKey: "type")
        personManaged.setValue(color, forKey: "colorCell")
        
        do{
            try context.save()
            
        } catch let error as NSError {
            
            print("No se pudo actualizar: \(error), \(error.userInfo)")
        }
    }
    
    
    func createToolBar() -> UIToolbar
    {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneBtnPressed))
        toolbar.setItems([doneBtn, ], animated: true)
        return toolbar
        
    }
    
    func createTimePicker(){
        
        timePicker.preferredDatePickerStyle = .wheels
        
        txtFoodSchedule.textAlignment = .center
        txtFoodSchedule.inputAccessoryView = createToolBar()
        txtFoodSchedule.inputView = timePicker
        timePicker.datePickerMode = .time
        
        
        
    }
    
    @objc func doneBtnPressed(){
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        
        txtFoodSchedule.text = formatter.string(from: timePicker.date)
        self.view.endEditing(true)
    }

   

}


