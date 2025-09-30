  GNU nano 8.6                                                                                                                                                       README.md                                                                                                                                                                
## Archivos generados

- `NodoDoble.java`: Nodo genérico de la lista doble.
- `GestionDoble.java`: Operaciones principales (insertar, eliminar, buscar, mostrar, actualizar).
- `Main.java`: Ejemplo con menú interactivo.
- `[Entidad].java`: Clase entidad opcional (ejemplo: `Persona`).

## Uso

1. Ejecuta el script en terminal:
```

./crear_proyecto_java.sh

```

El script te pedirá:
- Nombre del proyecto/directorio
- Paquete Java (opcional)
- Creación de clase entidad (opcional)

2. Compila y ejecuta los archivos generados:
```

cd NombreDelProyecto/[ruta_del_paquete_si_existe]
javac *.java
java Main           \# O bien: java com.miempresa.lista.Main (si agregaste paquete)

```

## Características

- Scaffold genérico para listas dobles en Java.
- Menú interactivo con opciones:
- Insertar al inicio
- Insertar al final
- Eliminar primero
- Eliminar último
- Mostrar lista (inicio a fin)
- Mostrar lista (fin a inicio)
- Buscar elemento
- Actualizar elemento
- Salir
- Clase entidad personalizable
- Incluye `getters`, `setters`, y `toString`

## Requisitos

- **Bash**
- **Java JDK 8** o superior

## Ejemplo de estructura

```

MiProyecto/
├── NodoDoble.java
├── GestionDoble.java
├── Main.java
└── Persona.java # Solo si eliges entidad

```

## Notas

- El scaffold es ideal para estudiantes y entornos académicos.
- Puedes modificar las clases generadas según tus necesidades.
