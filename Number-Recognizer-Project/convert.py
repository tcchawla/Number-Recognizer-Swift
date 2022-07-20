import tensorflow as tf
import coremltools as ct

model = tf.keras.models.load_model("model")
mlmodel = ct.convert(model)
mlmodel.save("MNIST_IMG_RECOGNIZER")
