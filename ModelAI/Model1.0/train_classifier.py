import pickle  # Importa el módulo "pickle" para serialización de objetos.
from sklearn.ensemble import RandomForestClassifier  # Importa la clase RandomForestClassifier del módulo sklearn.ensemble.
from sklearn.model_selection import train_test_split  # Importa la función train_test_split del módulo sklearn.model_selection.
from sklearn.metrics import accuracy_score  # Importa la función accuracy_score del módulo sklearn.metrics.
import numpy as np  # Importa el módulo numpy para manipulación de arreglos.

data_dict = pickle.load(open('./data.pickle', 'rb'))  # Carga los datos y las etiquetas desde el archivo 'data.pickle'.

data = np.asarray(data_dict['data'])  # Convierte los datos a un arreglo numpy.

labels = np.asarray(data_dict['labels'])  # Convierte las etiquetas a un arreglo numpy.


# Divide los datos y las etiquetas en conjuntos de entrenamiento y prueba.
# x_train: Conjunto de datos de entrenamiento.
# x_test: Conjunto de datos de prueba.
# y_train: Etiquetas correspondientes al conjunto de entrenamiento.
# y_test: Etiquetas correspondientes al conjunto de prueba.
# data: Datos a dividir en conjuntos de entrenamiento y prueba.
# labels: Etiquetas correspondientes a los datos.
# test_size: Proporción del conjunto de datos a reservar para pruebas (0.2 indica el 20%).
# shuffle: Indica si se deben mezclar los datos antes de dividir (True para mezclar aleatoriamente).
# stratify: Distribuye las etiquetas de manera uniforme entre los conjuntos de entrenamiento y prueba basado en las etiquetas originales.
x_train, x_test, y_train, y_test = train_test_split(data, labels, test_size=0.2, shuffle=True, stratify=labels)


model = RandomForestClassifier()  # Inicializa un modelo de clasificación de Bosques Aleatorios.


model.fit(x_train, y_train)  # Entrena el modelo con los datos de entrenamiento.


y_predict = model.predict(x_test)  # Realiza predicciones en el conjunto de prueba.


score = accuracy_score(y_predict, y_test)  # Calcula la precisión del modelo.


# Imprime el porcentaje de muestras clasificadas correctamente.
print('{}% de las muestras se clasificaron correctamente !'.format(score * 100))


f = open('model.p', 'wb')  # Abre un archivo llamado 'model.p' en modo de escritura binaria.

pickle.dump({'model': model}, f)  # Serializa el modelo y lo guarda en el archivo utilizando el módulo pickle.

f.close()  # Cierra el archivo después de escribir el modelo.