.equ SCREEN_WIDTH,   640
.equ SCREEN_HEIGH,   480

.global plot

.global draw_pixel 

.global draw_rectangle

.global draw_line

.global copy_pixel

.global delay

.global draw_pelota

.global read_display

.global tapar_frame


// (x, y) -> fbinit + 4 * (y * (ancho_pantalla) + x)


// { PRE = (x, y) = (x1, x2), x10 = color }
plot:

    // push
    sub sp, sp, 48
    stur x1, [sp]
    stur x2, [sp, 8]
    stur x10, [sp, 16]
    stur x16, [sp, 24]
    stur x17, [sp, 32]
    stur x30, [sp, 40]

    mov x17, SCREEN_WIDTH
    madd x16, x2, x17, x1 // x16 = x2 * x17 + x1
    lsl x16, x16, 2
    add x16, x16, x20
    
    stur w10, [x16]

    // pop!
    ldur x30, [sp, 40]
    ldur x17, [sp, 32]
    ldur x16, [sp, 24]
    ldur x10, [sp,16]
    ldur x2, [sp, 8]
    ldur x1, [sp]
    add sp, sp, 48

    ret
// { POS = (x1, x2) pintado de color x10 }


// { PRE = (x, y) = (x1, x2), x10 = color }
draw_pixel:

    // push

    // stack:
    //            ___
    //       sp-> ___


    sub sp, sp, 32
    stur x1, [sp]
    stur x2, [sp, 8]
    stur x10, [sp, 16]
    stur x30, [sp, 24]
    
    // stack:
    //            ______
    //            |x1  |
    //            |x2  |
    //            |x10 |
    //       sp-> |x30 |
    //            ______


    bl plot

    add x1, x1, 1

    bl plot

    sub x1, x1, 1
    add x2, x2, 1

    bl plot

    add x1, x1, 1

    bl plot



    // stack:
    //            ______
    //            |x1  |
    //            |x2  |
    //            |x10 |
    //       sp-> |x30 |
    //            ______


    // pop!
    ldur x30, [sp, 24]
    ldur x10, [sp,16]
    ldur x2, [sp, 8]
    ldur x1, [sp]
    add sp, sp, 32

    
    // stack:
    //            ___
    //       sp-> ___
    //            |x1  |
    //            |x2  |
    //            |x10 |
    //            |x30 |


    ret
// { POS = (x1, x2), (x1 + 1, x2), (x1, x2 + 1), (x1 + 1, x2 + 1) pintados de color x10 }


// { PRE =   (x, y) = (x1, x2)    ,  (x', y') = (x3, x4) , x10 = color }
//       | esquina sup. izquierda | esquina inf. derecha |

draw_rectangle:
    
    // push
    sub sp, sp, 80
    stur x0, [sp]
    stur x1, [sp, 8] // coordenada x de la esq. sup. izq
    stur x2, [sp, 16] // coordenada y de la esq. sup. izq
    stur x3, [sp, 24] // coordenada x de la esq. inf. derecha
    stur x4, [sp, 32] // coordenada y de la esq. inf. derecha
    stur x10, [sp, 40] // color
    stur x16, [sp, 48] 
    stur x17, [sp, 56] // aux
    stur x18, [sp, 64] // aux
    stur x30, [sp, 72] // aux para guardar el ancho del rectangulo

    mov x0, x1 // Seteamos el pixel de inicio de fila

    // Seteo la altura del rectangulo = y' - y + 1
    sub x16, x4, x2
    add x16, x16, 1

    sub x18, x3, x1
    add x18, x18, 1

    loop1:
        // Seteo el ancho del rectangulo = x' - x + 1
	    mov x17, x18    
        mov x1, x0

    loop0:
	    bl plot  // Colorear el pixel N bien
	    add x1,x1,1    // Siguiente pixel de la fila
	    sub x17,x17,1    // Decrementar contador X
	    cbnz x17,loop0  // Si no terminó la fila, salto ----    while(x1 != 0)
        
        add x2,x2,1 // Si termino la fila, bajo un pixel
	    sub x16,x16,1    // Decrementar contador Y
	    cbnz x16,loop1  // Si no es la última fila, salto

    // pop!
    ldur x30, [sp, 72]
    ldur x18, [sp, 64]
    ldur x17, [sp, 56]
    ldur x16, [sp, 48]
    ldur x10, [sp, 40]
    ldur x4, [sp, 32]
    ldur x3, [sp, 24]
    ldur x2, [sp, 16]
    ldur x1, [sp, 8]
    ldur x0, [sp]
    add sp, sp, 80

    ret



//{ PRE = (x, y) = (x1, x2), (x', y') = (x3, x4),  x < x', x10 color}

draw_line:

    // push
    sub sp, sp, 80
    stur x0, [sp]
    stur x1, [sp, 8] // coordenada x de la esq. sup. izq
    stur x2, [sp, 16] // coordenada y de la esq. sup. izq
    stur x3, [sp, 24] // coordenada x de la esq. inf. derecha
    stur x4, [sp, 32] // coordenada y de la esq. inf. derecha
    stur x10, [sp, 40] // color
    stur x16, [sp, 48] 
    stur x17, [sp, 56] // aux
    stur x18, [sp, 64] // aux
    stur x30, [sp, 72] // aux para guardar el ancho del rectangulo

    // y = ax + b // x5 = a, x6 = b, x1= x, x2 = y

    sub x16, x4, x2
    sub x17, x3, x1
    
    lsl x16, x16, 1
    
    sdiv x16, x16, x17

    
    

    
   
fun_lineal:

    

    bl draw_pixel

    add x1, x1, 2  

    add x2, x2, x16 

    sub x18, x3, x1

    cbnz x18, fun_lineal


    



    // pop!
    ldur x30, [sp, 72]
    ldur x18, [sp, 64]
    ldur x17, [sp, 56]
    ldur x16, [sp, 48]
    ldur x10, [sp, 40]
    ldur x4, [sp, 32]
    ldur x3, [sp, 24]
    ldur x2, [sp, 16]
    ldur x1, [sp, 8]
    ldur x0, [sp]
    add sp, sp, 80

    ret

copy_pixel:
    sub sp, sp, 32
    stur x1, [sp]
    stur x2, [sp, 8]
    stur x10, [sp, 16]
    stur x30, [sp, 24]

    add x1, x1, x16
    add x2, x2, x17
    bl draw_pixel
    sub x1, x1, x16
    sub x2, x2, x17

    ldur x30, [sp, 24]
    ldur x10, [sp,16]
    ldur x2, [sp, 8]
    ldur x1, [sp]
    add sp, sp, 32

    ret

delay:
    sub sp, sp, 16
    stur x18, [sp]
    stur x30, [sp, 8]

    movz x18, 0x00FF, lsl 16
    movk x18, 0xFFFF, lsl 00
    

    delay_loop:
        sub x18, x18, 1
        cbnz x18, delay_loop

    ldur x30, [sp, 8]
    ldur x18, [sp]
    add sp, sp, 16

    ret


// { PRE = (x, y) = (x1, x2), x10 = color }
draw_pelota:

    // push

    // stack:
    //            ___
    //       sp-> ___


    sub sp, sp, 32
    stur x1, [sp]
    stur x2, [sp, 8]
    stur x10, [sp, 16]
    stur x30, [sp, 24]
    
    // stack:
    //            ______
    //            |x1  |
    //            |x2  |
    //            |x10 |
    //       sp-> |x30 |
    //            ______


    bl draw_pixel

    add x1, x1, 2

    bl draw_pixel

    sub x1, x1, 2
    add x2, x2, 2

    bl draw_pixel

    add x1, x1, 2

    bl draw_pixel



    // stack:
    //            ______
    //            |x1  |
    //            |x2  |
    //            |x10 |
    //       sp-> |x30 |
    //            ______


    // pop!
    ldur x30, [sp, 24]
    ldur x10, [sp,16]
    ldur x2, [sp, 8]
    ldur x1, [sp]
    add sp, sp, 32

    
    // stack:
    //            ___
    //       sp-> ___
    //            |x1  |
    //            |x2  |
    //            |x10 |
    //            |x30 |


    ret
// { POS = de (x1, x2) a (x1 + 3, x2 + 3) pintados de color x10 }

// Se guardara toda la pantalla desde posicion x7 de la memoria
read_display:
    // push
    sub sp, sp, 16
    stur x30, [sp]

    mov x5, 0 // comienzo x de lectura
    mov x6, 0 // comienzo y de lectura
    mov x12, 480 // # de filas que leeremos (altura de la pantalla)
    mov x8, SCREEN_WIDTH // ancho de la pantalla

read_outer_loop:
    mov x11, 640 // # de columnas que leeremos en cada fila (ancho de la pantalla)

read_inner_loop:
    madd x9, x6, x8, x5 // x9 = x6 * x8 + x5
    lsl x9, x9, 2
    add x9, x9, x20 // en x9 está la dirección del pixel (x5, x6)

    ldr w13, [x9] // leemos el valor del pixel (x5, x6)
    str w13, [x7] // guardamos el valor del pixel en la posición de memoria x7

    add x7, x7, 4 // avanzamos en la memoria destino
    add x5, x5, 1 // avanzamos en la columna
    sub x11, x11, 1
    cbnz x11, read_inner_loop

    // Reseteamos x5 y avanzamos a la siguiente fila
    mov x5, 0
    add x6, x6, 1
    sub x12, x12, 1
    cbnz x12, read_outer_loop

    // pop!
    ldur x30, [sp]
    add sp, sp, 16

    ret
// { POS = desde pos de memoria x7 se guarda el valor de los pixeles de donde se pintara la pelota, en intervalos de a 32 bits }

tapar_frame:

    // push
    sub sp, sp, 16
    stur x30, [sp]
   
    mov x8, SCREEN_WIDTH // ancho de la pantalla
    mov x12, 4 // # de filas que taparemos

print_outer_loop:
    mov x11, 4 // # de columnas que taparemos en cada fila

print_inner_loop:
    movz x7, 0x0040, lsl 16
    movk x7, 0x0000, lsl 00 // donde iremos guardando el "framebuffer"
    madd x9, x6, x8, x5 // x9 = x6 * x8 + x5
    lsl x9, x9, 2
    
    add x7, x7, x9
    
    ldr w13, [x7] // leemos el pixel guardado en x7

    add x9, x9, x20 // en x9 está la dirección del pixel (x5, x6)

    str w13, [x9] // lo pintamos en la pantalla

    add x7, x7, 4 // avanzamos en la memoria fuente
    add x5, x5, 1 // avanzamos en la columna
    sub x11, x11, 1
    cbnz x11, print_inner_loop

    // Reseteamos x5 y avanzamos a la siguiente fila
    mov x5, x1
    add x6, x6, 1
    sub x12, x12, 1
    cbnz x12, print_outer_loop

    // pop!
    ldur x30, [sp]
    add sp, sp, 16

    ret


