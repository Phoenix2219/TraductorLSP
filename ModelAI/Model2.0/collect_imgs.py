import os  # Para interactuar con el sistema operativo (En este caso para manejo de directorios).
import sys  # Para usar métodos del sistema

import cv2  # Para procesamiento de imágenes y videos.
import tkinter as tk  # Importa Tkinter para la interfaz gráfica
from tkinter import messagebox  # Para mostrar mensajes en ventana

base_dir = os.path.dirname(os.path.abspath(__file__))  # Obtiene la ruta del directorio base
DATA_DIR = os.path.join(base_dir, 'data')  # Ruta de los videos e imágenes

if not os.path.exists(DATA_DIR):  # Verifica si el directorio no existe.
    os.makedirs(DATA_DIR)  # Crea el directorio si no existe.

def start_data_collection():  # Recolecta datos de una nueva clase
    cap = cv2.VideoCapture(0)  # Inicia la captura de video desde la cámara web.
    dataset_size = int(dataset_size_entry.get())  # Se almacena el valor del tamaño del set de datos
    labelin = label_entry.get()  # Etiqueta introducida

    if os.path.exists(os.path.join(DATA_DIR, str(labelin))):  # Verifica si el directorio de la clase actual existe.
        messagebox.showerror("Error", "¡Ya existe esa etiqueta en el set de datos, ingrese nuevamente!")
        return

    root_win.withdraw()  # Oculta la segunda ventana

    print('Recopilando datos para la clase {}'.format(labelin))

    while True:  # Bucle para capturar el inicio de la recolección de datos de la clase actual.

        ret, frame = cap.read()  # Ret es True si fue captura exitosa o False si no, frame almacena la captura.

        cv2.putText(frame, 'Click en "c" para empezar a capturar :)',
                    (10, 50), cv2.FONT_HERSHEY_SIMPLEX, 0.9, (10, 10, 10), 3,
                    cv2.LINE_AA)  # Agrega texto al fotograma en la parte superior.

        cv2.imshow('frame', frame)  # Muestra el fotograma.

        if cv2.waitKey(1) == ord('c'):  # Espera la tecla 'Q' para empezar a capturar datos.

            break  # Sale del bucle.

    os.makedirs(os.path.join(DATA_DIR, str(labelin)))  # Crea el directorio para la clase actual.
    counterd = 0  # Inicializa el contador de datos capturados.

    while counterd < dataset_size:  # Bucle para capturar el número deseado de datos.

        ret, frame = cap.read()  # Captura un fotograma.

        cv2.imshow('frame', frame)  # Muestra el fotograma.

        cv2.waitKey(25)  # Espera un corto tiempo.

        cv2.imwrite(os.path.join(DATA_DIR, str(labelin), '{}.jpg'.format(counterd)),
                       frame)  # Guarda el fotograma como una imagen en el directorio correspondiente.

        counterd += 1  # Incrementa el contador de datos.

    option = messagebox.askyesno("Continuar", "¿Desea seguir recopilando datos para otra etiqueta?")
    if not option:
        sys.exit()

    label_entry.delete(0, 'end')  # Borra el contenido de la entrada de datos de la etiqueta
    root_win.deiconify()  # Muestra la segunda ventana

    cap.release()  # Libera los recursos de la cámara.

    cv2.destroyAllWindows()  # Cierra todas las ventanas de visualización de imágenes.


# ________________________________ #
# _______INTERFAZ GRÁFICA_________ #
# ________________________________ #

def show_meaning_win():
    # Verifica si el valor ingresado es un número entero positivo
    if not dataset_size_entry.get().isdigit() or int(dataset_size_entry.get()) < 0:
        # No es un número entero positivo
        messagebox.showerror("Error", "¡El valor ingresado no es un número entero positivo!")
        return

    # Borra el contenido de la entrada de datos
    label_entry.delete(0, 'end')

    # Oculta los elementos de la primera interfaz
    dataset_size_label.grid_forget()
    dataset_size_entry.grid_forget()
    next_button.grid_forget()

    # Muestra los elementos de la segunda interfaz
    label_meaning.grid(row=0, column=0, padx=5, pady=5)
    label_entry.grid(row=1, column=0, padx=10, pady=10)
    start_button.grid(row=2, columnspan=2, padx=5, pady=10)
    # Configurar la geometría de la ventana
    root_win.geometry(f'{435}x{150}')

def center_win(root_win):
    # Obtiene el ancho y alto de la pantalla
    width_screen = root_win.winfo_screenwidth()
    height_screen = root_win.winfo_screenheight()

    # Obtiene el ancho y alto de la ventana
    root_win.update()  # Asegura que la ventana se haya mostrado completamente
    width_window = root_win.winfo_width()
    height_window = root_win.winfo_height() + 10

    # Calcular las coordenadas para centrar la ventana
    x_pos = ((width_screen - width_window) // 2)
    y_pos = ((height_screen - height_window) // 2) - 50

    # Configurar la geometría de la ventana
    root_win.geometry(f'{width_window}x{height_window}+{x_pos}+{y_pos}')

# Crea estilo para las etiquetas
label_style = {'font': ('Arial', 10), 'padx': 10, 'pady': 5}

# Crea ventana en donde se solicita al usuario un número entero para el tamaño del dataset
root_win = tk.Tk()
root_win.title("Recolección de Imagenes")

# Crea y posiciona los elementos de la interfaz
dataset_size_label = tk.Label(root_win,
                              text="¿Con cuantas imagenes desea que el sistema entrene? Escriba un numero: ",
                              **label_style)
dataset_size_label.grid(row=0, column=0, padx=5, pady=5)

dataset_size_entry = tk.Entry(root_win, width=60)
dataset_size_entry.grid(row=1, column=0, padx=10, pady=10)

next_button = tk.Button(root_win, text="Siguiente", command=show_meaning_win, **label_style)
next_button.grid(row=2, columnspan=2, padx=5, pady=10)

# Crea la ventana en donde pregunta al usuario el significado de las imagenes a recolectar (inicialmente ocultos)
label_meaning = tk.Label(root_win,
                         text="Ingrese el significado de las imagenes a recolectar (Algun caracter):", **label_style)
label_entry = tk.Entry(root_win, width=50)
start_button = tk.Button(root_win, text="Iniciar recolección de datos", command=start_data_collection,
                         **label_style)

center_win(root_win)

root_win.mainloop()







