//Aqui vamos a configurar el StoreDataProvider que es quien nos va a facilitar realizar las acciones de cara a la BBDD

import CoreData
import OSLog

class StoreDataProvider {
    
    //Usamos el patrón singleton para asegurarnos de usar siempre una misma instancia de StoreDataProvider para toda la app
    static var shared: StoreDataProvider = .init()
    
    let logger = Logger(subsystem: "com.JorgeNavi.TaskReminder", category: "StoreDataProvider")
    
    private let store: NSPersistentContainer
    private var context: NSManagedObjectContext {
        store.viewContext /* viewContext
                           
                           •    viewContext es una propiedad de NSPersistentContainer que proporciona un contexto de objetos gestionado (NSManagedObjectContext). Este contexto está configurado para ser usado en el hilo principal de la aplicación, lo que lo hace ideal para tareas relacionadas con la interfaz de usuario, como mostrar datos y responder a interacciones del usuario.
                           •    Utilizar viewContext asegura que todas las operaciones de datos que impactan directamente en la interfaz de usuario se realicen de manera segura y eficiente, evitando problemas de rendimiento o bloqueos de la aplicación.

                       Uso común

                           •    Típicamente, viewContext se utiliza para realizar consultas, insertar nuevos objetos, y actualizar o eliminar objetos existentes que serán mostrados directamente en la interfaz de usuario. Por ejemplo, si tu aplicación muestra una lista de elementos que los usuarios pueden editar, esos cambios se manejarían a través del viewContext para asegurar que la interfaz se actualice de manera fluida y reactiva. */
    }
    
    init() {
        self.store = NSPersistentContainer(name: "TaskReminder") //informamos el modelo de datos que tiene que trabajar la BBDD
        self.store.loadPersistentStores { _, error in //Nos aseguramos de que la BBDD pueda cargar, si no, lanzará un error
            if let error {
                fatalError("Error loading persistent stores: \(error)")
            }
        }
    }
    
    func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                logger.debug("Error saving context: \(error)")
            }
        }
    }
}

//vamos a extender nuestro StoreDataProvider para trabajar con nuestros datos:
extension StoreDataProvider {
    
    func addtask(title: String, dueDate: Date) {
        guard let entityDescrition = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return }
        let task = MOTask(entity: entityDescrition, insertInto: context)
        task.title = title
        task.dueDate = dueDate
        save()
    }
    
    // Define la función fetchTasks que retorna un arreglo opcional de MOTask.
    // Retorna nil si ocurre un error al intentar recuperar las tareas.
    func fetchTasks() -> [MOTask]? {
        // Crea una solicitud de búsqueda para la entidad MOTask.
        // Esto prepara la consulta para obtener los datos almacenados de esta entidad.
        let request = MOTask.fetchRequest() //está usando NSFetchRequest por detrás. Por eso dispone de ese método por defecto
        
        // Intenta ejecutar la solicitud en el contexto de Core Data.
        // La función fetch() devuelve un arreglo de objetos que cumplen con la solicitud.
        // El uso de 'try?' permite manejar errores de forma elegante, retornando nil si la operación falla.
        return try? context.fetch(request)
    }
    
    func deleteTask(task: MOTask) {
        context.delete(task)
        save()
    }
}
