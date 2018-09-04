//
//  PJCoreDataHelper.swift
//  PFollow
//
//  Created by pjpjpj on 2018/8/18.
//  Copyright © 2018年 pjpjpj. All rights reserved.
//

import UIKit
import CoreData

class PJCoreDataHelper: NSObject {
    
    // 单例
    static let shared = PJCoreDataHelper()
    
    private let delegate = UIApplication.shared.delegate as! AppDelegate
    private let context: NSManagedObjectContext?
    
    
    // MAEK: life Cycle
    override init() {
        context = delegate.persistentContainer.viewContext
    }
    
    
    func addAnnotation(model: AnnotationModel) -> Bool {
        let annotationEntity = NSEntityDescription.insertNewObject(forEntityName: "Annotation", into: context!) as! Annotation
        annotationEntity.created_time = model.createdTimeString
        annotationEntity.weather = model.weatherString
        annotationEntity.environment = model.environmentString
        annotationEntity.latitude = model.latitude
        annotationEntity.longitude = model.longitude
        annotationEntity.altitude = model.altitude
        annotationEntity.stepCount = model.stepCount
        annotationEntity.city = model.city
        annotationEntity.formatterAddress = model.formatterAddress
        annotationEntity.markerName = model.markerName
        
        do {
            try context?.save()
            print("保存成功")
            return true
        } catch {
            print("不能保存：\(error)")
            return false
        }
    }
    
    
    func allAnnotation() -> [AnnotationModel] {
        var annotationArray = [AnnotationModel]()
        let fetchRequest = NSFetchRequest<Annotation>(entityName:"Annotation")
        do {
            let fetchedObjects = try context?.fetch(fetchRequest)
            for info in fetchedObjects!{
                let data = [
                    "createdTimeString": info.created_time,
                    "weatherString": info.weather,
                    "environmentString": info.environment,
                    "latitude": info.latitude,
                    "longitude": info.longitude,
                    "altitude": info.altitude,
                    "stepCount": info.stepCount,
                    "city": info.city,
                    "formatterAddress": info.formatterAddress,
                    "markerName": info.markerName,
                ]
                
                if let json = try? JSONSerialization.data(withJSONObject: data, options: []) {
                    if let annotationModel = try? JSONDecoder().decode(AnnotationModel.self, from: json) {
                        annotationArray.append(annotationModel)
                    }
                }
            }
            print("查询成功")
            return annotationArray
        }
        catch {
            print("查询失败：\(error)")
            return []
        }
    }
    
    
    func updateAnnotation(formatString: String, updateTime: String) -> Bool {
        let fetchRequest = NSFetchRequest<Annotation>(entityName:"Annotation")
        let predict = NSPredicate(format: formatString, argumentArray: nil)
        fetchRequest.predicate = predict
        do {
            let annotation = try context?.fetch(fetchRequest)[0]
            annotation?.created_time = updateTime
            do {
                try context?.save()
                print("保存成功")
                return true
            } catch {
                print("不能保存：\(error)")
                return false
            }
        } catch {
            print("查询成功")
            return false
        }
    }
    
    
    func deleteAnnotation(model: AnnotationModel) {
        let fetchRequest = NSFetchRequest<Annotation>(entityName:"Annotation")
        let coordinate = NSPredicate(format: "longitude=\(model.longitude) and latitude=\(model.latitude)")
        fetchRequest.predicate = coordinate
        do {
            let fetchedObjects = try context?.fetch(fetchRequest)
            for instance in fetchedObjects! {
                context?.delete(instance)
            }
        } catch {
            print("删除查询出错：\(error)")
            print("查询成功")
        }
        do {
            try context?.save()
            print("删除成功")
        } catch {
            print("删除出错:\(error)")
        }
    }
    
    
    func annotationContent(model: AnnotationModel) -> String {
        let fetchRequest = NSFetchRequest<AnnotationContent>(entityName:"AnnotationContent")
        let contentPredicate = NSPredicate(format: "longitude=\(model.longitude) and latitude=\(model.latitude)")
        fetchRequest.predicate = contentPredicate
        do {
            let fetchedObjects = try context?.fetch(fetchRequest)
            print("查询成功")
            return fetchedObjects?.first?.content ?? ""
        }
        catch {
            print("查询失败：\(error)")
            return ""
        }
    }
    
    
    func addAnnotationContent(content: String, model: AnnotationModel) -> Bool {
        let fetchRequest = NSFetchRequest<AnnotationContent>(entityName:"AnnotationContent")
        let contentPredicate = NSPredicate(format: "longitude=\(model.longitude) and latitude=\(model.latitude)")
        fetchRequest.predicate = contentPredicate
        do {
            let fetchedObjects = try context?.fetch(fetchRequest)
            print("查询成功")
            
            let object = fetchedObjects?.first
            
            if object?.content != nil {
                context?.delete(object!)
            }
            
            let annotationEntity = NSEntityDescription.insertNewObject(forEntityName: "AnnotationContent", into: context!) as! AnnotationContent
            annotationEntity.content = content
            annotationEntity.longitude = model.longitude
            annotationEntity.latitude = model.latitude
            
            do {
                try context?.save()
                print("保存成功")
                return true
            } catch {
                print("不能保存：\(error)")
                return false
            }
        }
        catch {
            print("查询失败：\(error)")
            return false
        }
    }
    
    
    func addAnnotationPhoto(photoImage: UIImage, model: AnnotationModel) -> Bool {
        
        _ = deleteAnnotationImage(model: model)
        
        let annotationEntity = NSEntityDescription.insertNewObject(forEntityName: "AnnotationImage", into: context!) as! AnnotationImage
        annotationEntity.image = UIImageJPEGRepresentation(photoImage, 1)
        annotationEntity.longitude = model.longitude
        annotationEntity.latitude = model.latitude
        
        do {
            try context?.save()
            print("保存成功")
            return true
        } catch {
            print("不能保存：\(error)")
            return false
        }
    }

    
    func annotationImage(model: AnnotationModel) -> UIImage? {
        let fetchRequest = NSFetchRequest<AnnotationImage>(entityName:"AnnotationImage")
        let contentPredicate = NSPredicate(format: "longitude=\(model.longitude) and latitude=\(model.latitude)")
        fetchRequest.predicate = contentPredicate
        do {
            let fetchedObjects = try context?.fetch(fetchRequest)
            print("查询成功")
            if fetchedObjects?.first != nil {
                return UIImage(data: fetchedObjects!.first!.image!)!
            } else {
                return nil
            }
        }
        catch {
            print("查询失败：\(error)")
            return nil
        }
    }
    
    
    func deleteAnnotationImage(model: AnnotationModel) -> Bool {
        let fetchRequest = NSFetchRequest<AnnotationImage>(entityName:"AnnotationImage")
        let contentPredicate = NSPredicate(format: "longitude=\(model.longitude) and latitude=\(model.latitude)")
        fetchRequest.predicate = contentPredicate
        do {
            let fetchedObjects = try context?.fetch(fetchRequest)
            for instance in fetchedObjects! {
                context?.delete(instance)
            }

            print("查询成功")
            return true
        }
        catch {
            print("查询失败：\(error)")
            return false
        }
    }
}
