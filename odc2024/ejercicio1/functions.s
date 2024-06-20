.equ SCREEN_WIDTH,   640
.equ SCREEN_HEIGH,   480

.global plot

.global draw_pixel 

.global draw_rectangle

.global draw_line

.global copy_pixel

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

