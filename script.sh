#!/usr/bin/env bash
# crear_proyecto_java_doble.sh
# Script para crear un scaffold de lista doble en Java
# Uso: ./crear_proyecto_java_doble.sh

set -e

echo "== Scaffold Java: Lista doble =="
read -p "Nombre del directorio/proyecto (ej: ListaPersonasDobles): " PROJ
if [ -z "$PROJ" ]; then
  echo "Debes ingresar un nombre. Abortando."
  exit 1
fi

read -p "Paquete (dejar vacío si no quieres paquete, ej: com.miempresa.lista): " PKG

read -p "¿Deseas crear una clase entidad (ej: Persona)? Si/No: " CREA_ENT
CREA_ENT=${CREA_ENT,,} # lowercase
if [[ "$CREA_ENT" == "si" || "$CREA_ENT" == "s" || "$CREA_ENT" == "y" ]]; then
  read -p "Nombre de la clase entidad (ej: Persona): " ENT
  if [ -z "$ENT" ]; then
    echo "No pusiste nombre de entidad. Se omitirá."
    ENT=""
  fi
else
  ENT=""
fi

# crear directorio
mkdir -p "$PROJ"
cd "$PROJ"

# package line si aplica
if [ -n "$PKG" ]; then
  PACKAGE_LINE="package $PKG;"
  PKG_PATH="${PKG//./\/}"
  mkdir -p "$PKG_PATH"
  DEST="$PKG_PATH"
else
  PACKAGE_LINE=""
  DEST="."
fi

# Crear NodoDoble.java
cat > "$DEST/NodoDoble.java" <<EOF
$PACKAGE_LINE

/**
 * Nodo genérico para lista doble.
 */
public class NodoDoble<T> {
    public T dato;
    public NodoDoble<T> siguiente;
    public NodoDoble<T> anterior;

    public NodoDoble(T dato) {
        this.dato = dato;
        this.siguiente = null;
        this.anterior = null;
    }
}
EOF

# Crear GestionDoble.java
cat > "$DEST/GestionDoble.java" <<'EOF'
__PKG__

import java.util.NoSuchElementException;

/**
 * Gestión de lista doble genérica.
 */
public class GestionDoble<T> {
    private NodoDoble<T> cabeza;
    private NodoDoble<T> cola;

    public GestionDoble() {
        this.cabeza = null;
        this.cola = null;
    }

    public void insertarAlInicio(T dato) {
        NodoDoble<T> nuevo = new NodoDoble<>(dato);
        if (cabeza == null) {
            cabeza = cola = nuevo;
        } else {
            nuevo.siguiente = cabeza;
            cabeza.anterior = nuevo;
            cabeza = nuevo;
        }
    }

    public void insertarAlFinal(T dato) {
        NodoDoble<T> nuevo = new NodoDoble<>(dato);
        if (cola == null) {
            cabeza = cola = nuevo;
        } else {
            cola.siguiente = nuevo;
            nuevo.anterior = cola;
            cola = nuevo;
        }
    }

    public T eliminarPrimero() {
        if (cabeza == null) throw new NoSuchElementException("Lista vacía");
        T dato = cabeza.dato;
        cabeza = cabeza.siguiente;
        if (cabeza != null) cabeza.anterior = null;
        else cola = null;
        return dato;
    }

    public T eliminarUltimo() {
        if (cola == null) throw new NoSuchElementException("Lista vacía");
        T dato = cola.dato;
        cola = cola.anterior;
        if (cola != null) cola.siguiente = null;
        else cabeza = null;
        return dato;
    }

    public boolean buscar(T dato) {
        NodoDoble<T> actual = cabeza;
        while (actual != null) {
            if ((actual.dato == null && dato == null) || 
                (actual.dato != null && actual.dato.equals(dato))) {
                return true;
            }
            actual = actual.siguiente;
        }
        return false;
    }

    public void mostrarAdelante() {
        NodoDoble<T> actual = cabeza;
        if (actual == null) {
            System.out.println("Lista vacía.");
            return;
        }
        System.out.println("Contenido (inicio → fin):");
        while (actual != null) {
            System.out.println(" - " + actual.dato);
            actual = actual.siguiente;
        }
    }

    public void mostrarAtras() {
        NodoDoble<T> actual = cola;
        if (actual == null) {
            System.out.println("Lista vacía.");
            return;
        }
        System.out.println("Contenido (fin → inicio):");
        while (actual != null) {
            System.out.println(" - " + actual.dato);
            actual = actual.anterior;
        }
    }

    public boolean actualizar(T datoAntiguo, T datoNuevo) {
        NodoDoble<T> actual = cabeza;
        while (actual != null) {
            if ((actual.dato == null && datoAntiguo == null) || 
                (actual.dato != null && actual.dato.equals(datoAntiguo))) {
                actual.dato = datoNuevo;
                return true;
            }
            actual = actual.siguiente;
        }
        return false;
    }
}
EOF

# Reemplazar marcador de paquete
if [ -n "$PKG" ]; then
  sed -i "s|__PKG__|$PACKAGE_LINE|g" "$DEST/GestionDoble.java"
else
  sed -i "s|__PKG__||g" "$DEST/GestionDoble.java"
fi

# Crear Main.java
cat > "$DEST/Main.java" <<'EOF'
__PKG__

import java.util.Scanner;

/**
 * Main con menú de ejemplo para probar la lista doble.
 */
public class Main {
    public static void main(String[] args) {
        GestionDoble<Object> gestion = new GestionDoble<>();
        Scanner sc = new Scanner(System.in);
        int opt = -1;

        while (opt != 0) {
            System.out.println("\n--- Menú Lista Doble ---");
            System.out.println("1) Insertar al inicio (String ejemplo)");
            System.out.println("2) Insertar al final (String ejemplo)");
            System.out.println("3) Eliminar primero");
            System.out.println("4) Eliminar último");
            System.out.println("5) Mostrar adelante");
            System.out.println("6) Mostrar atrás");
            System.out.println("7) Buscar (String)");
            System.out.println("8) Actualizar");
            System.out.println("0) Salir");
            System.out.print("Opción: ");
            try {
                opt = Integer.parseInt(sc.nextLine());
            } catch (Exception e) {
                opt = -1;
            }

            switch (opt) {
                case 1:
                    System.out.print("Texto a insertar al inicio: ");
                    gestion.insertarAlInicio(sc.nextLine());
                    break;
                case 2:
                    System.out.print("Texto a insertar al final: ");
                    gestion.insertarAlFinal(sc.nextLine());
                    break;
                case 3:
                    try {
                        System.out.println("Eliminado: " + gestion.eliminarPrimero());
                    } catch (Exception e) {
                        System.out.println("Lista vacía.");
                    }
                    break;
                case 4:
                    try {
                        System.out.println("Eliminado: " + gestion.eliminarUltimo());
                    } catch (Exception e) {
                        System.out.println("Lista vacía.");
                    }
                    break;
                case 5:
                    gestion.mostrarAdelante();
                    break;
                case 6:
                    gestion.mostrarAtras();
                    break;
                case 7:
                    System.out.print("Texto a buscar: ");
                    System.out.println("¿Encontrado? " + gestion.buscar(sc.nextLine()));
                    break;
                case 8:
                    System.out.print("Dato a actualizar: ");
                    String viejo = sc.nextLine();
                    System.out.print("Nuevo valor: ");
                    String nuevo = sc.nextLine();
                    if (gestion.actualizar(viejo, nuevo)) {
                        System.out.println("Dato actualizado.");
                    } else {
                        System.out.println("Elemento no encontrado.");
                    }
                    break;
                case 0:
                    System.out.println("Saliendo...");
                    break;
                default:
                    System.out.println("Opción inválida.");
            }
        }
        sc.close();
    }
}
EOF

# Reemplazar paquete en Main.java
if [ -n "$PKG" ]; then
  sed -i "s|__PKG__|$PACKAGE_LINE|g" "$DEST/Main.java"
else
  sed -i "s|__PKG__||g" "$DEST/Main.java"
fi

# Crear entidad si aplica
if [ -n "$ENT" ]; then
  cat > "$DEST/$ENT.java" <<EOF
$PACKAGE_LINE

/**
 * Clase $ENT: ejemplo con nombre y edad.
 */
public class $ENT {
    private String nombre;
    private int edad;

    public $ENT() {}

    public $ENT(String nombre, int edad) {
        this.nombre = nombre;
        this.edad = edad;
    }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public int getEdad() { return edad; }
    public void setEdad(int edad) { this.edad = edad; }

    @Override
    public String toString() {
        return "[$ENT: " + nombre + ", " + edad + " años]";
    }
}
EOF
fi

# Mensaje final
echo "Done. Archivos creados en: $(pwd)/$DEST"
echo ""
echo "Sugerencia de uso:"
echo "1) Ve al directorio: cd $PROJ/$( [ -n \"$PKG\" ] && echo \"$PKG_PATH\" )"
echo "2) Compila: javac *.java"
echo "3) Ejecuta: java Main   (si usaste paquete, ejecuta: java $PKG.Main )"

echo ""
echo "Archivos generados:"
ls -1 "$DEST"
