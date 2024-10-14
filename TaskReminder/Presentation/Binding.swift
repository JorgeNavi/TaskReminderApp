import Foundation

//El binding nos servirá para notificar los cambios de estado de las pantallas:

final class Binding <State> {
    
    //typealias a la que llamamos completion que va a ser de tipo State
    typealias Completion = (State) -> Void
    
    //variable completion que sera de tipo State (de nuestro typealias):
    var completion: Completion?
    
    /* Función bind(Completion:)
     Esta función se usa para “enlazar” o “asignar” la función de Completion (una función que recibe un State) a la variable completion de la clase.
     La palabra clave @escaping significa que la función que se pasa como parámetro (completion) podría ser usada más tarde, después de que la función bind termine de ejecutarse.
     */
    func bind(completion: @escaping Completion) {
        self.completion = completion
    }
    
    /* Función update(newValue: State)
     Esta función es la que actualiza el estado con un nuevo valor (newValue) del tipo State.
     Dentro de esta función, se usa DispatchQueue.main.async para asegurarse de que cualquier cambio que se haga, se haga en el hilo principal. Esto es importante en aplicaciones móviles porque las actualizaciones de la interfaz de usuario deben hacerse en el hilo principal, y no en hilos de fondo que puedan estar ejecutándose en paralelo.
     El bloque de código dentro de DispatchQueue.main.async usa [weak self] para evitar que se cree un ciclo de retención en la memoria. Básicamente, esto es una forma de prevenir posibles fugas de memoria al hacer referencia a self dentro de un bloque de código que puede ejecutarse en el futuro.
     Finalmente, se ejecuta la función completion (si es que tiene algún valor), pasándole el nuevo valor newValue.
     */
    func update(newValue: State) {
        DispatchQueue.main.async { [weak self] in
            self?.completion?(newValue) //Cada vez que tenga un newValue, automáticamente me lo refresca por dentro
        }
    }

}
