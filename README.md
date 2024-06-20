# lab_odc
Image and video generated in Assembly emulating a RPi3 (with Clemente Ivetta &amp; Ignacio Hernandez)

The first thing we did was understand how the frame buffer works and design the image to replicate using Legv8 code.
Once completed we went on to create the basic functions we needed and define our way of working separately on the project, we learned GIT in the process. Then each one finished his part and we assembled

Introducción al uso del framebuffer
En términos generales, se denomina framebuffer al método de acceso de dispositivos
gráficos de un sistema computacional, en el cual se representa cada uno de los píxeles de
la pantalla como ubicaciones de una porción específica del mapa de memoria de acceso
aleatorio (sistema de memoria principal).
En particular, la plataforma Raspberry Pi 3 soporta este método de manejo gráfico en su
Video Core (VC). Para esto, hay que realizar una inicialización del VC por medio de un
servicio implementado para comunicar el CPU con el VC llamado mailbox. Un mailbox es
uno o varios registros ubicados en direcciones específicas del mapa de memoria (en zona
de periféricos) cuyo contenido es “enviado” a los registros correspondientes de control/status
de algún periférico del sistema. Este método simplifica las tareas de inicialización de
hardware (escrito en código de bajo nivel), previos al proceso de carga de un Sistema
Operativo en el sistema.
Luego del proceso de inicialización del VC vía mailbox, los registros de control y status
del VC pueden ser consultados en una estructura de memoria cuya ubicación puede ser
definida (en rigor “virtualizada”) por el usuario. Entre los parámetros que se pueden
consultar se encuentra la dirección de memoria (puntero) donde se ubica el comienzo del
FrameBuffer.
Para la realización del presente trabajo, se adjunta un código ejemplo donde se realizan
todas las tareas de inicialización de VC explicadas anteriormente. Este código inicializa el
FrameBuffer con la siguiente configuración:
- Tamaño en X = 640 píxeles
- Tamaño en Y = 480 píxeles
- Formato de color: ARGB de 32 bits
El formato de colores se denomina ARGB, donde A es el alpha (transparencia), R es Red
(rojo), G es Green (verde) y B es Blue (azul), el orden de la siglas determina el orden en que
se ubican estos bits dentro de los 32 bits. Para cada uno de los componentes, el estándar
ARGB le otorga 8 bits de resolución, es decir, existen 256 rojos, 256 verdes y 256 azules,
más todas las combinaciones posibles entre estos tres colores.
El color del píxel será el resultado de la combinación aditiva de los tres colores (rojo, verde y
azul). De esta forma el color negro se representa con el valor 0x00, el blanco con
0xFFFFFF, el rojo con 0xFF0000, el verde con 0x00FF00, y el azul con 0x0000FF y, por
ejemplo, 0xC71585 es “medium violet red” [ref].
En base a esta configuración, el FrameBuffer queda organizado en palabras de 32 bits (4
bytes) cuyos valores establecen el color que tomará cada píxel de la pantalla. La palabra
contenida en la primera posición del FrameBuffer determina el color del primer píxel,
ubicado en el extremo superior izquierdo, incrementando el número de píxel hacia la
derecha en eje X hasta llegar al píxel 639. De esta forma, el pixel 640 representa el primer
píxel de la segunda línea. 
