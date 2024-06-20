.ifndef LAYERS_S
.equ LAYERS_S, 0x000000

// Indice de Registros
	// x0, x1, x2, x3, x4 coordenadas
	// x10 color
	// x16, x17 auxiliares
	// x20 dirección base del framebuffer

// Registros por Funciones
    // plot: { (x, y) = (x1, x2), x10 = color }
    // draw_pixel: { (x, y) = (x1, x2), x10 = color }
    // draw_rectangle:  {    (x, y) = (x1, x2)     ,   (x', y') = (x3, x4)  , x10 = color }
                    //  | pixel superior izquierdo | pixel inferior derecho |

pelota:
	 // push
        sub sp, sp, 56
        stur x0, [sp]
        stur x1, [sp, 8]
        stur x2, [sp, 16]
        stur x3, [sp, 24]
        stur x4, [sp, 32]
        stur x10, [sp, 40]
        stur x30, [sp, 48]

	//seteo color
	movz x10, 0xff, lsl 16
	movk x10, 0x5200, lsl 00

	//seteo coordenadas
	mov x1, 346
	mov x2, 234
	mov x3, 349
	mov x4, 237
	
	bl draw_rectangle
	
	//pop!
        ldur x30, [sp, 48]
        ldur x10, [sp, 40]
        ldur x4, [sp, 32]
        ldur x3, [sp, 24]
        ldur x2, [sp, 16]
        ldur x1, [sp, 8]
        ldur x0, [sp]
        add sp, sp, 56

mesa_ping_pong:

    // push
    sub sp, sp, 80
    stur x0, [sp]
    stur x1, [sp, 8] 
    stur x2, [sp, 16] 
    stur x3, [sp, 24] 
    stur x4, [sp, 32] 
    stur x10, [sp, 40] 
    stur x16, [sp, 48] 
    stur x17, [sp, 56] 
    stur x18, [sp, 64] 
    stur x30, [sp, 72] 
    
    bl mesa

    bl linea_blanca_medio_mesa
    
    bl bordes_mesa

    bl patas_mesa

    bl red_mesa

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


    

mesa:
    // push
    sub sp, sp, 80
    stur x0, [sp]
    stur x1, [sp, 8] 
    stur x2, [sp, 16] 
    stur x3, [sp, 24] 
    stur x4, [sp, 32]
    stur x10, [sp, 40] 
    stur x16, [sp, 48] 
    stur x17, [sp, 56] 
    stur x18, [sp, 64] 
    stur x30, [sp, 72] 

    mov x1, 204
    mov x2, 246
    mov x0, x1
    movz x10, 0x5D8F, lsl 00

    mov x16, 119
    mov x17, 21
    mov x18, 0

    mesa_loop:
    bl draw_pixel

    add x1, x1, 2
    
    sub x16, x16, 1
    

    cbnz x16, mesa_loop 

    add x18, x18, 2
    mov x16, 119
    add x16, x16, x18
    
    mov x1, x0
    sub x1, x1, x18
    add x2, x2, 2

    sub x17, x17, 1

    cbnz x17, mesa_loop
    
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

    linea_blanca_medio_mesa:

    // push
    sub sp, sp, 80
    stur x0, [sp]
    stur x1, [sp, 8] 
    stur x2, [sp, 16] 
    stur x3, [sp, 24] 
    stur x4, [sp, 32]
    stur x10, [sp, 40] 
    stur x16, [sp, 48] 
    stur x17, [sp, 56] 
    stur x18, [sp, 64] 
    stur x30, [sp, 72] 
    
    mov x1, 188
    mov x2, 262
    mov x3, 459
    mov x4, 263
    movz x10, 0x00FF, lsl 16
    movk x10, 0xFFFF, lsl 00
    bl draw_rectangle // linea blanca medio

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

    bordes_mesa:

    sub sp, sp, 16
    stp x29, x30, [sp, #8]

    mov x1, 162
    mov x2, 288
    mov x3, 483
    mov x4, 291
    movz x10, 0x002B, lsl 16
    movk x10, 0x383D, lsl 00
    bl draw_rectangle // borde frente oscuro

    mov x1, 164
    mov x2, 292
    mov x3, 481
    mov x4, 293
    movz x10, 0x00A1, lsl 16
    movk x10, 0x9c8f, lsl 00
    bl draw_rectangle // borde frente claro

    ldp x29, x30, [sp, #8]
    add sp, sp, 16

    ret

    patas_mesa:

    sub sp, sp, 16
    stp x29, x30, [sp, #8]

    mov x1, 192
    mov x2, 294
    add x3, x1, 1
    mov x4, 359
    movz x10, 0x0058, lsl 16
    movk x10, 0x534f, lsl 00
    bl draw_rectangle // pata izquierda


    mov x1, 296
    add x3, x1, 1
    bl draw_rectangle // pata izquierda medio

    mov x1, 344
    add x3, x1, 1
    bl draw_rectangle // pata derecha medio

    mov x1, 450
    add x3, x1, 1
    bl draw_rectangle // pata derecha
    
    mov x1, 224
    add x3, x1, 1
    mov x4, 311
    bl draw_rectangle // pata atras izquierda

    mov x1, 418
    add x3, x1, 1
    bl draw_rectangle // pata atras derecha

    mov x1, 298
    mov x2, 320
    mov x3, 343
    mov x4, 341
    bl draw_rectangle // cartel gris patas medio

    mov x1, 418
    mov x2, 312
    mov x3, 450
    mov x4, 360
    bl draw_line // pata piso diagonal izquierda

    mov x1, 192
    mov x2, 360
    mov x3, 226
    mov x4, 308
    bl draw_line // pata piso diagonal derecha

    mov x16, 48 // diferencia entre ruedas
    mov x17, 0
    movz x10, 0x0034, lsl 16
    movk x10, 0x2a1e , lsl 00
    mov x1, 292
    mov x2, 352
    bl draw_pixel
    bl copy_pixel

    add x1, x1, 2
    bl draw_pixel
    bl copy_pixel

    mov x1, 290
    mov x2, 354
    bl draw_pixel
    bl copy_pixel

    mov x1, 298
    bl draw_pixel
    bl copy_pixel

    mov x1, 290
    mov x2, 356
    bl draw_pixel
    bl copy_pixel

    add x1, x1, 8
    bl draw_pixel
    bl copy_pixel


    sub x1, x1, 8

    mov x1, 290
    mov x2, 358
    bl draw_pixel
    bl copy_pixel

    add x1, x1, 8
    bl draw_pixel
    bl copy_pixel


    sub x1, x1, 8
    
    add x1, x1, 2
    add x2, x2, 2
    bl draw_pixel
    bl copy_pixel

    add x1, x1, 2
    bl draw_pixel
    bl copy_pixel // fin de ruedas

    ldp x29, x30, [sp, #8]
    add sp, sp, 16

    ret

    red_mesa:

    // push
    sub sp, sp, 80
    stur x0, [sp]
    stur x1, [sp, 8] 
    stur x2, [sp, 16] 
    stur x3, [sp, 24] 
    stur x4, [sp, 32] 
    stur x10, [sp, 40] 
    stur x16, [sp, 48] 
    stur x17, [sp, 56] 
    stur x18, [sp, 64] 
    stur x30, [sp, 72] 

    mov x1, 318
    mov x2, 272
    mov x3, 321
    mov x4, 273
    bl draw_rectangle

    mov x1, 318
    mov x2, 240
    mov x3, 321
    mov x4, 271
    movz x10, 0x00b8, lsl 16
    movk x10, 0xbcbf , lsl 00
    bl draw_rectangle

    mov x1, 318
    mov x2, 274
    mov x3, 321
    mov x4, 287
    movz x10, 0x00de, lsl 16
    movk x10, 0xd291 , lsl 00
    bl draw_rectangle

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
    

    




clemen:

    // push
    sub sp, sp, 80
    stur x0, [sp]
    stur x1, [sp, 8] 
    stur x2, [sp, 16] 
    stur x3, [sp, 24] 
    stur x4, [sp, 32] 
    stur x10, [sp, 40]
    stur x16, [sp, 48] 
    stur x17, [sp, 56] 
    stur x18, [sp, 64] 
    stur x30, [sp, 72] 

    bl estrellas

    bl piso

    //pop
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



//{ (x1, x2) = coordenadas de comienzo de estrellas, x15 = cantidad de estrellas, x10 = color}
    estrellas:

        sub sp, sp, 64
        stp x1, x2, [sp, #0]
        stp x10, x15, [sp, #16]
        stp x16, x30, [sp, #32]

        mov x1, 10
        mov x2, 5
        
        movz x10, 0x00FF, lsl 16
        movk x10, 0xFFFF, lsl 00

        mov x15, 100

        test:


            sub sp, sp, 32            // Allocate 32 bytes on the stack
            stp x1, x2, [sp, 0]       // Save x1 and x2 at sp and sp+8
            stp x10, x30, [sp, 16]    // Save x10 and x30 at sp+16 and sp+24

            bl plot // dibuja el pixel

            add x1, x1, 30
            
            add x2, x2, 60
            
            sub x10, x10, 100

            bl plot // dibuja el pixel

            
            add x1, x1, 30
            add x2, x2, 60
            
            sub x10, x10, 100

            bl plot // dibuja el pixel

            ldp x10, x30, [sp, 16]    // Restore x10 and x30 from sp+16 and sp+24
            ldp x1, x2, [sp, 0]       // Restore x1 and x2 from sp and sp+8
            add sp, sp, 32            // Deallocate 32 bytes on the stack

            add x1, x1, 50
            add x2, x2, 2


            sub x15, x15, 1

            cbnz x15, test

        ldp x16, x30, [sp, #32]
        ldp x10, x15, [sp, #16]
        ldp x1, x2, [sp, #0]
        add sp, sp, 64

    ret




    piso:

        // push
        sub sp, sp, 64
        stp x1, x2, [sp, #0]
        stp x3, x4, [sp, #16]
        stp x10, x30, [sp, #32]

        mov x1, 0
        mov x2, 228
        mov x3, 639
        mov x4, 479
        movz x10, 0x00ef, lsl 16
        movk x10, 0xe0c6, lsl 00

        bl draw_rectangle

        // pop!
        ldp x10, x30, [sp, #32]
        ldp x3, x4, [sp, #16]
        ldp x1, x2, [sp, #0]
        add sp, sp, 64

        ret




capa_nacho:

    sub sp, sp, 8
    stur x30, [sp]

        

    bl pared_ventana_fondo
    bl baranda

    ldur x30, [sp]
    add sp, sp, 8
    
    ret


pared_ventana_fondo:
    // push
    sub sp, sp, 56
    stur x0, [sp]   
    stur x1, [sp, 8]
    stur x2, [sp, 16]
    stur x3, [sp, 24]
    stur x4, [sp, 32]
    stur x10, [sp, 40]
    stur x30, [sp, 48]

    // setteo color
    movz x10, 0x362c, lsl 0  
    movk x10, 0x3c, lsl 16
    // SOMBRA RECTANGULO VERTICAL IZQ 2
    mov x1,215
    mov x2,84
    mov x3,215
    mov x4,227
    bl draw_rectangle
    
    // SOMBRA RECTANGULO VERTICAL IZQ 3
    mov x1,463
    mov x3,463
    bl draw_rectangle

     // setteo color
    movz x10, 0x9d82, lsl 0  
    movk x10, 0xad, lsl 16
    // SOMBRA RECTANGULO HORIZONTAL MEDIO
    mov x1,164
    mov x2,156
    mov x3,518
    mov x4,156

    // setteo color
    movz x10, 0xc4a3, lsl 0  
    movk x10, 0xd7, lsl 16

    // RECTANGULO DE ARRIBA
    mov x1, 160  // coordenada x del corner TL
    mov x2, 80  // coordenada y del corner TL
    mov x3, 639  // coordenada x del corner BR
    mov x4, 83  // coordenada y del corner BR
    bl draw_rectangle

    // RECTANGULO IZQUIERDA DEL TODO
    mov x3, 163  // coordenada x del corner BR
    mov x4, 227  // coordenada y del corner BR    
    bl draw_rectangle


    // RECTANGULO HORIZONTAL MEDIO
    mov x2, 157  // coordenada y del corner TL
    mov x3, 639  // coordenada y del corner BR
    mov x4, 157  // coordenada y del corner BR
    bl draw_rectangle

    // RECTANGULO VERTICAL IZQ 2
    mov x1, 216
    mov x2, 84
    mov x3, 217
    mov x4, 227
    bl draw_rectangle

    // RECTANGULO VERTICAL IZQ 3
    mov x1, 270
    mov x3, 287
    bl draw_rectangle

    // RECTANGULO VERTICAL IZQ 4
    mov x1, 394
    mov x3, 411
    bl draw_rectangle

    // RECTANGULO VERTICAL IZQ 5
    mov x1, 464
    mov x3, 465
    bl draw_rectangle


    // RECTANGULO DERECHA
    mov x1, 518
    mov x2, 80
    mov x3, 639
    mov x4, 227
    bl draw_rectangle

    //pop!
    ldur x30, [sp, 48]
    ldur x10, [sp, 40]
    ldur x4, [sp, 32]
    ldur x3, [sp, 24]
    ldur x2, [sp, 16]
    ldur x1, [sp, 8]
    ldur x0, [sp]
    add sp, sp, 56

    ret

baranda:
    // push
    sub sp, sp, 56
    stur x0, [sp]   
    stur x1, [sp, 8]
    stur x2, [sp, 16]
    stur x3, [sp, 24]
    stur x4, [sp, 32]
    stur x10, [sp, 40]
    stur x30, [sp, 48]

    // BASE:
    // RECTANGULO HORIZONTAL 1
    // setteo color amarillo oscuro en x10
    movz x10, 0x7d38, lsl 0
    movk x10, 0xab, lsl 16

    mov x1, 112
    mov x2, 182
    mov x3, 455
    mov x4, 187
    bl draw_rectangle

    // RECTANGULO HORIZONTAL 2
    mov x2, 196
    mov x4, 200
    bl draw_rectangle

    // RECTANGULO HORIZONTAL 2
    mov x2, 210
    mov x4, 213
    bl draw_rectangle

    // RECTANGULO VERTICAL 1
    mov x1, 214
    mov x2, 188
    mov x3, 219 
    mov x4, 227
    bl draw_rectangle

    // RECTANGULO VERTICAL 2
    mov x1, 450
    mov x3, 455 
    bl draw_rectangle

    // setteo color amarillo claro en x10
    movz x10, 0xb037, lsl 0 
    movk x10, 0xe4, lsl 16
    // LUZ RECTANGULO HORIZONTAL 1
    mov x1, 112
    mov x2, 182
    mov x3, 455
    mov x4, 185
    bl draw_rectangle

    // LUZ RECTANGULO HORIZONTAL 2
    mov x2, 196
    mov x4, 197
    bl draw_rectangle

    // LUZ RECTANGULO HORIZONTAL 2
    mov x2, 210
    mov x4, 211
    bl draw_rectangle

    // LUZ RECTANGULO VERTICAL 1
    mov x1, 216
    mov x2, 186
    mov x3, 219 
    mov x4, 227
    bl draw_rectangle

    // LUZ RECTANGULO VERTICAL 2
    mov x1, 452
    mov x3, 455
    bl draw_rectangle

    // BARANDA DERECHA
    mov x1, 562
    mov x2, 182
    mov x3, 579 
    mov x4, 185
    bl draw_rectangle

    mov x1, 558
    mov x2, 184
    mov x3, 561 
    mov x4, 187 
    bl draw_rectangle

    // primer rectangulo de 2x4 pixeles
    mov x1, 556
    mov x2, 186
    mov x3, 557
    mov x4, 189
    bl draw_rectangle

    mov x0, 19  // Número de iteraciones

    loop_start: // pinto otros 19 rectangulos de 2x4 descendiendo hacia la izquierda
        sub x1, x1, #2  // Restar 2 a x1
        sub x3, x3, #2  // Restar 2 a x3
        add x2, x2, #2  // Sumar 2 a x2
        add x4, x4, #2  // Sumar 2 a x4
        
        bl draw_rectangle

        subs x0, x0, #1  // Decrementar contador de iteraciones
        bne loop_start   // Volver al inicio del bucle si no se ha alcanzado el final


    // sombra escalera
    // setteo color marron en x10
    movz x10, 0x7d34, lsl 0
    movk x10, 0xad, lsl 16

    mov x1, 558
    mov x2, 182
    mov x3, 561
    mov x4, 183
    bl draw_rectangle

    mov x1, 562
    mov x2, 186
    mov x3, 579
    mov x4, 187
    bl draw_rectangle

    // primer rectangulo de 2x4 pixeles
    mov x1, 556
    mov x2, 184
    mov x3, 557
    mov x4, 185
    bl draw_rectangle

    mov x0, 19  // Número de iteraciones

    loop_start2: // pinto otros 19 rectangulos de 2x4 descendiendo hacia la izquierda
        sub x1, x1, #2  // Restar 2 a x1
        sub x3, x3, #2  // Restar 2 a x3
        add x2, x2, #2  // Sumar 2 a x2
        add x4, x4, #2  // Sumar 2 a x4
        
        bl draw_rectangle

        subs x0, x0, #1  // Decrementar contador de iteraciones
        bne loop_start2   // Volver al inicio del bucle si no se ha alcanzado el final

    //pop!
    ldur x30, [sp, 48]
    ldur x10, [sp, 40]
    ldur x4, [sp, 32]
    ldur x3, [sp, 24]
    ldur x2, [sp, 16]
    ldur x1, [sp, 8]
    ldur x0, [sp]
    add sp, sp, 56

    ret

pj_nacho:
    // push
    sub sp, sp, 56
    stur x0, [sp]   
    stur x1, [sp, 8]
    stur x2, [sp, 16]
    stur x3, [sp, 24]
    stur x4, [sp, 32]
    stur x10, [sp, 40]
    stur x30, [sp, 48]

    bl cabeza_nacho
    bl torso_nacho
    bl piernas_nacho

    //pop!
    ldur x30, [sp, 48]
    ldur x10, [sp, 40]
    ldur x4, [sp, 32]
    ldur x3, [sp, 24]
    ldur x2, [sp, 16]
    ldur x1, [sp, 8]
    ldur x0, [sp]
    add sp, sp, 56

    ret


cabeza_nacho:
    // push
    sub sp, sp, 56
    stur x0, [sp]   
    stur x1, [sp, 8]
    stur x2, [sp, 16]
    stur x3, [sp, 24]
    stur x4, [sp, 32]
    stur x10, [sp, 40]
    stur x30, [sp, 48]

    // setteo color cara en x10
    movz x10, 0x8868, lsl 0  
    movk x10, 0xb6, lsl 16

    // piel cara
    mov x1, 480
    mov x2, 178
    mov x3, 483
    mov x4, 179
    bl draw_rectangle

    mov x1, 482
    mov x2, 182
    mov x3, 485
    mov x4, 183
    bl draw_rectangle

    mov x1, 480
    mov x2, 184
    mov x3, 487
    mov x4, 185
    bl draw_rectangle

    mov x1, 478
    mov x2, 186
    mov x3, 491
    mov x4, 187
    bl draw_rectangle

    mov x1, 490
    mov x2, 182
    mov x3, 493
    mov x4, 185
    bl draw_rectangle

    mov x1, 480
    mov x2, 188
    mov x3, 495
    mov x4, 193
    bl draw_rectangle

    mov x1, 496
    mov x2, 190
    mov x3, 497
    mov x4, 193
    bl draw_rectangle

    mov x1, 482
    mov x2, 194
    mov x3, 493
    mov x4, 195
    bl draw_rectangle

    // Lentes
    // setteo color lentes en x10
    movz x10, 0xbcbf, lsl 0   
    movk x10, 0xb8, lsl 16

    mov x1, 478
    mov x2, 180
    mov x3, 479
    mov x4, 185
    bl draw_rectangle

    mov x1, 478
    mov x2, 180
    mov x3, 491
    mov x4, 181
    bl draw_rectangle
    
    mov x1, 492
    mov x2, 182
    mov x3, 493
    mov x4, 183
    bl draw_rectangle

    // Ojos
    // setteo color ojos en x10
    movz x10, 0xffff, lsl 0  
    movk x10, 0xff, lsl 16
    // movz x10, 0x7341, lsl 0  
    // movk x10, 0x00, lsl 16

    mov x1, 480
    mov x2, 182
    mov x3, 481
    mov x4, 183
    bl draw_rectangle

    //pop!
    ldur x30, [sp, 48]
    ldur x10, [sp, 40]
    ldur x4, [sp, 32]
    ldur x3, [sp, 24]
    ldur x2, [sp, 16]
    ldur x1, [sp, 8]
    ldur x0, [sp]
    add sp, sp, 56

    ret

torso_nacho:
    // push
    sub sp, sp, 56
    stur x0, [sp]   
    stur x1, [sp, 8]
    stur x2, [sp, 16]
    stur x3, [sp, 24]
    stur x4, [sp, 32]
    stur x10, [sp, 40]
    stur x30, [sp, 48]

    // setteo color cuello en x10
    movz x10, 0x775d, lsl 0  
    movk x10, 0x9c, lsl 16

    // piel cuello
    mov x1, 494
    mov x2, 194
    mov x3, 499
    mov x4, 197
    bl draw_rectangle

    mov x1, 490
    mov x2, 196
    mov x3, 499
    mov x4, 197
    bl draw_rectangle

    mov x1, 492
    mov x2, 198
    mov x3, 495
    mov x4, 201
    bl draw_rectangle

    mov x1, 492
    mov x2, 202
    mov x3, 493
    mov x4, 203
    bl draw_rectangle

    // remera
    // setteo color cuello en x10
    movz x10, 0x7341, lsl 0  
    movk x10, 0x00, lsl 16

    mov x1, 492
    mov x2, 204
    mov x3, 493
    mov x4, 231
    bl draw_rectangle

    mov x1, 494
    mov x2, 202
    mov x3, 495
    mov x4, 231
    bl draw_rectangle

    mov x1, 496
    mov x2, 198
    mov x3, 497
    mov x4, 231
    bl draw_rectangle

    mov x1, 498
    mov x2, 198
    mov x3, 507
    mov x4, 229
    bl draw_rectangle

    mov x1, 500
    mov x2, 196
    mov x3, 503
    mov x4, 197
    bl draw_rectangle


    mov x1, 508
    mov x2, 200
    mov x3, 509
    mov x4, 255
    bl draw_rectangle


    mov x1, 510
    mov x2, 202
    mov x3, 511
    mov x4, 255
    bl draw_rectangle

    mov x1, 512
    mov x2, 206
    mov x3, 513
    mov x4, 255
    bl draw_rectangle

    mov x1, 514
    mov x2, 208
    mov x3, 515
    mov x4, 255
    bl draw_rectangle

    mov x1, 516
    mov x2, 212
    mov x3, 517
    mov x4, 255
    bl draw_rectangle

    mov x1, 518
    mov x2, 218
    mov x3, 519
    mov x4, 255
    bl draw_rectangle

    mov x1, 520
    mov x2, 228
    mov x3, 521
    mov x4, 255
    bl draw_rectangle
    
    mov x1, 522
    mov x2, 244
    mov x3, 523
    mov x4, 255
    bl draw_rectangle

    mov x1, 522
    mov x2, 244
    mov x3, 523
    mov x4, 255
    bl draw_rectangle

    mov x1, 506
    mov x2, 236
    mov x3, 507
    mov x4, 255
    bl draw_rectangle

    mov x1, 500
    mov x2, 240
    mov x3, 505
    mov x4, 255
    bl draw_rectangle
    
    mov x1, 494
    mov x2, 242
    mov x3, 499
    mov x4, 249
    bl draw_rectangle

    mov x1, 496
    mov x2, 250
    mov x3, 499
    mov x4, 255
    bl draw_rectangle

    // brazo
    // setteo color brazo en x10
    movz x10, 0x8868, lsl 0  
    movk x10, 0xb6, lsl 16

    mov x1, 498
    mov x2, 228
    mov x3, 507
    mov x4, 235
    bl draw_rectangle

    mov x1, 476
    mov x2, 232
    mov x3, 505
    mov x4, 237
    bl draw_rectangle

    mov x1, 486
    mov x2, 238
    mov x3, 505
    mov x4, 239
    bl draw_rectangle

    mov x1, 496
    mov x2, 240
    mov x3, 500
    mov x4, 241
    bl draw_rectangle

    mov x1, 476
    mov x2, 238
    mov x3, 477
    mov x4, 239
    bl draw_rectangle

    mov x1, 474
    mov x2, 234
    mov x3, 475
    mov x4, 235
    bl draw_rectangle

    // reloj
    // setteo color malla reloj en x10
    movz x10, 0xbcbf, lsl 0  
    movk x10, 0xb8, lsl 16

    mov x1, 480
    mov x2, 232
    mov x3, 481
    mov x4, 237
    bl draw_rectangle

    // setteo color cuerpo reloj en x10
    movz x10, 0xffff, lsl 0  
    movk x10, 0xff, lsl 16

    mov x1, 480
    mov x2, 234
    mov x3, 481
    mov x4, 235
    bl draw_rectangle

    // paleta
    // setteo color cuerpo paleta en x10
    movz x10, 0x0606, lsl 0  
    movk x10, 0xff, lsl 16

    mov x1, 462
    mov x2, 242
    mov x3, 469
    mov x4, 247
    bl draw_rectangle

    mov x1, 464
    mov x2, 248
    mov x3, 467
    mov x4, 249
    bl draw_rectangle

    mov x1, 464
    mov x2, 240
    mov x3, 471
    mov x4, 245
    bl draw_rectangle

    mov x1, 466
    mov x2, 238
    mov x3, 469
    mov x4, 239
    bl draw_rectangle

    // setteo color mango paleta en x10
    movz x10, 0x915d, lsl 0
    movk x10, 0xe5, lsl 16

    mov x1, 472
    mov x2, 238
    mov x3, 473
    mov x4, 239
    bl draw_rectangle

    mov x1, 474
    mov x2, 236
    mov x3, 475
    mov x4, 237
    bl draw_rectangle

    //pop!
    ldur x30, [sp, 48]
    ldur x10, [sp, 40]
    ldur x4, [sp, 32]
    ldur x3, [sp, 24]
    ldur x2, [sp, 16]
    ldur x1, [sp, 8]
    ldur x0, [sp]
    add sp, sp, 56

    ret


piernas_nacho:
    // push
    sub sp, sp, 56
    stur x0, [sp]   
    stur x1, [sp, 8]
    stur x2, [sp, 16]
    stur x3, [sp, 24]
    stur x4, [sp, 32]
    stur x10, [sp, 40]
    stur x30, [sp, 48]

    // pantalon pierna adelante
    // setteo color pantalones de adelante en x10
    movz x10, 0x6d8e, lsl 0
    movk x10, 0x54, lsl 16

    mov x1, 496
    mov x2, 256
    mov x3, 523
    mov x4, 259
    bl draw_rectangle

    mov x1, 496
    mov x2, 260
    mov x3, 521
    mov x4, 261
    bl draw_rectangle

    mov x1, 496
    mov x2, 262
    mov x3, 519
    mov x4, 265
    bl draw_rectangle

    mov x1, 494
    mov x2, 264
    mov x3, 517
    mov x4, 267
    bl draw_rectangle

    mov x1, 494
    mov x2, 268
    mov x3, 515
    mov x4, 271
    bl draw_rectangle

    mov x1, 492
    mov x2, 272
    mov x3, 511
    mov x4, 275
    bl draw_rectangle

    mov x1, 492
    mov x2, 276
    mov x3, 509
    mov x4, 281
    bl draw_rectangle

    mov x1, 490
    mov x2, 278
    mov x3, 507
    mov x4, 285
    bl draw_rectangle

    mov x1, 488
    mov x2, 284
    mov x3, 505
    mov x4, 291
    bl draw_rectangle

    mov x1, 488
    mov x2, 292
    mov x3, 503
    mov x4, 299
    bl draw_rectangle

    mov x1, 488
    mov x2, 300
    mov x3, 501
    mov x4, 303
    bl draw_rectangle

    mov x1, 490
    mov x2, 304
    mov x3, 501
    mov x4, 323
    bl draw_rectangle

    mov x1, 488
    mov x2, 324
    mov x3, 501
    mov x4, 331
    bl draw_rectangle

    mov x1, 488
    mov x2, 332
    mov x3, 499
    mov x4, 333
    bl draw_rectangle

    // pantalon pierna de atras
    // setteo color pantalones de atras en x10
    movz x10, 0x476b, lsl 0 
    movk x10, 0x2c, lsl 16

    mov x1, 502
    mov x2, 300
    mov x3, 507
    mov x4, 327
    bl draw_rectangle

    mov x1, 508
    mov x2, 308
    mov x3, 509
    mov x4, 327
    bl draw_rectangle

    mov x1, 504
    mov x2, 292
    mov x3, 507
    mov x4, 299
    bl draw_rectangle

    mov x1, 506
    mov x2, 286
    mov x3, 507
    mov x4, 291
    bl draw_rectangle

    // zapatillas
    movz x10, 0xffff, lsl 0
    movk x10, 0xff, lsl 16

    mov x1, 480
    mov x2, 338
    mov x3, 497
    mov x4, 341
    bl draw_rectangle

    mov x1, 484
    mov x2, 336
    mov x3, 499
    mov x4, 339
    bl draw_rectangle
    
    mov x1, 488
    mov x2, 334
    mov x3, 501
    mov x4, 337
    bl draw_rectangle

    mov x1, 500
    mov x2, 332
    mov x3, 509
    mov x4, 333
    bl draw_rectangle

    mov x1, 502
    mov x2, 328
    mov x3, 511
    mov x4, 331
    bl draw_rectangle

    //pop!
    ldur x30, [sp, 48]
    ldur x10, [sp, 40]
    ldur x4, [sp, 32]
    ldur x3, [sp, 24]
    ldur x2, [sp, 16]
    ldur x1, [sp, 8]
    ldur x0, [sp]
    add sp, sp, 56

    ret

pj_valen:

        sub sp, sp, 8
        stur x30, [sp]

        bl lompa

        bl remera

        bl medias

        bl cara

        bl brazo_vacio

        bl brazo_paleta

        ldur x30, [sp]
        add sp, sp, 8
        ret



    lompa:
        // push
        sub sp, sp, 56
        stur x0, [sp]
        stur x1, [sp, 8]
        stur x2, [sp, 16]
        stur x3, [sp, 24]
        stur x4, [sp, 32]
        stur x10, [sp, 40]
        stur x30, [sp, 48]

        // seteo el color
        movz x10, 0x4b39, lsl 00

        // seteo coordenadas
        mov x1, 138
        mov x2, 250

        mov x3, 179
        mov x4, 256

        bl draw_rectangle

        // seteo coordenadas
        mov x1, 136
        mov x2, 257

        mov x3, 181
        mov x4, 265

        bl draw_rectangle

        // seteo coordenadas
        mov x1, 136
        mov x2, 265

        mov x3, 145
        mov x4, 321

        bl draw_rectangle

        // seteo coordenadas
        mov x1, 134
        mov x2, 268

        mov x3, 135
        mov x4, 321

        bl draw_rectangle

        // seteo coordenadas
        mov x1, 132
        mov x2, 300

        mov x3, 133
        mov x4, 321

        bl draw_rectangle

        // seteo coordenadas
        mov x1, 146
        mov x2, 266

        mov x3, 149
        mov x4, 283

        bl draw_rectangle

        // seteo coordenadas
        mov x1, 150
        mov x2, 266

        mov x3, 151
        mov x4, 277

        // seteo coordenadas
        mov x1, 150
        mov x2, 266

        mov x3, 153
        mov x4, 271

        bl draw_rectangle

        // seteo coordenadas
        mov x1, 146
        mov x2, 284

        mov x3, 147
        mov x4, 291

        bl draw_rectangle

        // seteo coordenadas
        mov x1, 168
        mov x2, 266

        mov x3, 197
        mov x4, 269

        bl draw_rectangle

        // seteo coordenadas
        mov x1, 170
        mov x2, 270

        mov x3, 197
        mov x4, 273

        bl draw_rectangle

        // seteo coordenadas
        mov x1, 172
        mov x2, 274

        mov x3, 197
        mov x4, 275

        bl draw_rectangle

        // seteo coordenadas
        mov x1, 182
        mov x2, 276

        mov x3, 197
        mov x4, 297

        bl draw_rectangle

        // seteo coordenadas
        mov x1, 184
        mov x2, 298

        mov x3, 197
        mov x4, 321

        bl draw_rectangle


        //pop!
        ldur x30, [sp, 48]
        ldur x10, [sp, 40]
        ldur x4, [sp, 32]
        ldur x3, [sp, 24]
        ldur x2, [sp, 16]
        ldur x1, [sp, 8]
        ldur x0, [sp]
        add sp, sp, 56


        ret

    remera:
        // push
        sub sp, sp, 56
        stur x0, [sp]
        stur x1, [sp, 8]
        stur x2, [sp, 16]
        stur x3, [sp, 24]
        stur x4, [sp, 32]
        stur x10, [sp, 40]
        stur x30, [sp, 48]

        // seteo el color
        movz x10, 0xff, lsl 16
        movk x10, 0x5200, lsl 00

        // seteo coordenadas
        mov x1, 138
        mov x2, 204

        mov x3, 171
        mov x4, 249

        bl draw_rectangle
        
        // seteo coordenadas
        mov x1, 131
        mov x2, 202

        mov x3, 137
        mov x4, 219

        bl draw_rectangle

        // seteo coordenadas
        mov x1, 138
        mov x2, 200

        mov x3, 149
        mov x4, 203

        bl draw_rectangle

        // seteo coordenadas
        mov x1, 130
        mov x2, 208

        mov x3, 130
        mov x4, 217

        bl draw_rectangle

        // seteo coordenadas
        mov x1, 162
        mov x2, 200

        mov x3, 171
        mov x4, 203

        bl draw_rectangle
        
        // seteo coordenadas
        mov x1, 172
        mov x2, 202

        mov x3, 179
        mov x4, 219

        bl draw_rectangle

        // seteo coordenadas
        mov x1, 180
        mov x2, 210

        mov x3, 181
        mov x4, 219

        bl draw_rectangle

        //pop!
        ldur x30, [sp, 48]
        ldur x10, [sp, 40]
        ldur x4, [sp, 32]
        ldur x3, [sp, 24]
        ldur x2, [sp, 16]
        ldur x1, [sp, 8]
        ldur x0, [sp]
        add sp, sp, 56

        ret

medias:
        // push
        sub sp, sp, 56
        stur x0, [sp]
        stur x1, [sp, 8]
        stur x2, [sp, 16]
        stur x3, [sp, 24]
        stur x4, [sp, 32]
        stur x10, [sp, 40]
        stur x30, [sp, 48]

        // seteo el color
        movz x10, 0xb8, lsl 16
        movk x10, 0xbcbf, lsl 00

        // seteo coordenadas
        mov x1, 132
        mov x2, 322

        mov x3, 143
        mov x4, 329

        bl draw_rectangle
        
        // seteo coordenadas
        mov x1, 186
        mov x2, 322

        mov x3, 199
        mov x4, 329

        bl draw_rectangle

        // seteo coordenadas
        mov x1, 200
        mov x2, 324

        mov x3, 203
        mov x4, 329

        bl draw_rectangle

        //pop!
        ldur x30, [sp, 48]
        ldur x10, [sp, 40]
        ldur x4, [sp, 32]
        ldur x3, [sp, 24]
        ldur x2, [sp, 16]
        ldur x1, [sp, 8]
        ldur x0, [sp]
        add sp, sp, 56


        ret

cara:
        // push
        sub sp, sp, 56
        stur x0, [sp]
        stur x1, [sp, 8]
        stur x2, [sp, 16]
        stur x3, [sp, 24]
        stur x4, [sp, 32]
        stur x10, [sp, 40]
        stur x30, [sp, 48]

        //CARA
        // seteo el color
        movz x10, 0xe8, lsl 16
        movk x10, 0xb997, lsl 00

        // seteo coordenadas
        mov x1, 150
        mov x2, 178

        mov x3, 163
        mov x4, 195

        bl draw_rectangle

        mov x1, 164
        mov x2, 186

        bl draw_pixel

        //CUELLO
        //seteo el color
        movz x10, 0xd6, lsl 16
        movk x10, 0xac8d, lsl 00
        
        // seteo coordenadas
        mov x1, 151
        mov x2, 196

        mov x3, 160
        mov x4, 199

        bl draw_rectangle

        // seteo coordenadas
        mov x1, 150
        mov x2, 200

        mov x3, 161
        mov x4, 203

        bl draw_rectangle

        //pelo
        //rapado
        //seteo el color
        movz x10, 0x66, lsl 16
        movk x10, 0x5453, lsl 00
        
        // seteo coordenadas
        mov x1, 150
        mov x2, 178

        mov x3, 155
        mov x4, 181

        bl draw_rectangle

        // seteo coordenadas
        mov x1, 150
        mov x2, 182

        mov x3, 153
        mov x4, 186

        bl draw_rectangle

        //rulos
        //seteo el color
        movz x10, 0x3d, lsl 16
        movk x10, 0x3332, lsl 00
        
        // seteo coordenadas
        mov x1, 146
        mov x2, 175

        mov x3, 165
        mov x4, 177

        bl draw_rectangle

        // seteo coordenadas
        mov x1, 146
        mov x2, 178

        mov x3, 149
        mov x4, 187

        bl draw_rectangle

        // seteo coordenadas
        mov x1, 148
        mov x2, 173

        mov x3, 163
        mov x4, 174

        bl draw_rectangle

        // seteo coordenadas
        mov x1, 150
        mov x2, 172

        mov x3, 161
        mov x4, 172

        bl draw_rectangle

        // seteo coordenadas
        mov x1, 148
        mov x2, 187

        mov x3, 149
        mov x4, 189

        bl draw_rectangle

        //ojo
        //color
        movz x10, 0x00, lsl 00
        // seteo coordenadas

        mov x1, 161
        mov x2, 184

        bl draw_pixel

        //pop!
        ldur x30, [sp, 48]
        ldur x10, [sp, 40]
        ldur x4, [sp, 32]
        ldur x3, [sp, 24]
        ldur x2, [sp, 16]
        ldur x1, [sp, 8]
        ldur x0, [sp]
        add sp, sp, 56


        ret

brazo_vacio:
        // push
        sub sp, sp, 56
        stur x0, [sp]
        stur x1, [sp, 8]
        stur x2, [sp, 16]
        stur x3, [sp, 24]
        stur x4, [sp, 32]
        stur x10, [sp, 40]
        stur x30, [sp, 48]

        // seteo el color
        movz x10, 0xe8, lsl 16
        movk x10, 0xb997, lsl 00

        // seteo coordenadas
        mov x1, 128
        mov x2, 218

        mov x3, 130
        mov x4, 219

        bl draw_rectangle
        
        // seteo coordenadas
        mov x1, 126
        mov x2, 220

        mov x3, 133
        mov x4, 225

        bl draw_rectangle

        // seteo coordenadas
        mov x1, 124
        mov x2, 226

        mov x3, 131
        mov x4, 229

        bl draw_rectangle

        // seteo coordenadas
        mov x1, 122
        mov x2, 230

        mov x3, 131
        mov x4, 231

        bl draw_rectangle

        // seteo coordenadas
        mov x1, 122
        mov x2, 232

        mov x3, 128
        mov x4, 235

        bl draw_rectangle

        // seteo coordenadas
        mov x1, 121
        mov x2, 236

        mov x3, 126
        mov x4, 242

        bl draw_rectangle
        
        // seteo coordenadas
        mov x1, 118
        mov x2, 243

        mov x3, 123
        mov x4, 249

        bl draw_rectangle

        // seteo coordenadas
        mov x1, 128
        mov x2, 212

        mov x3, 129
        mov x4, 217

        bl draw_rectangle


        //pop!
        ldur x30, [sp, 48]
        ldur x10, [sp, 40]
        ldur x4, [sp, 32]
        ldur x3, [sp, 24]
        ldur x2, [sp, 16]
        ldur x1, [sp, 8]
        ldur x0, [sp]
        add sp, sp, 56


        ret

brazo_paleta:
        // push
        sub sp, sp, 56
        stur x0, [sp]
        stur x1, [sp, 8]
        stur x2, [sp, 16]
        stur x3, [sp, 24]
        stur x4, [sp, 32]
        stur x10, [sp, 40]
        stur x30, [sp, 48]

        // seteo el color
        movz x10, 0xe8, lsl 16
        movk x10, 0xb997, lsl 00

        // seteo coordenadas
        mov x1, 174
        mov x2, 220

        mov x3, 181
        mov x4, 231

        bl draw_rectangle
        
        // seteo coordenadas
        mov x1, 176
        mov x2, 232

        mov x3, 181
        mov x4, 247

        bl draw_rectangle

        // seteo coordenadas
        mov x1, 176
        mov x2, 248

        mov x3, 179
        mov x4, 257

        bl draw_rectangle

        // seteo coordenadas
        mov x1, 180
        mov x2, 252

        mov x3, 181
        mov x4, 257

        bl draw_rectangle

        //paleta
        
        //color
        movz x10, 0x9b, lsl 16
        movk x10, 0x5909, lsl 00

        //coordenadas
        mov x1, 176
        mov x2, 252

        bl draw_pixel

        //coordenadas
        mov x1, 173
        mov x2, 254

        bl draw_pixel

        //coordenadas
        mov x1, 176
        mov x2, 252

        bl draw_pixel

        //color
        movz x10, 0xff, lsl 16
        movk x10, 0x0606, lsl 00

        //coordenadas
        mov x1, 168
        mov x2, 254

        mov x3, 171
        mov x4, 263

        bl draw_rectangle

        //coordenadas
        mov x1, 172
        mov x2, 256

        mov x3, 173
        mov x4, 261

        bl draw_rectangle

        //coordenadas
        mov x1, 166
        mov x2, 256

        mov x3, 167
        mov x4, 265

        bl draw_rectangle

        //coordenadas
        mov x1, 164
        mov x2, 258

        mov x3, 165
        mov x4, 263

        bl draw_rectangle

        //coordenadas

        mov x1, 168
        mov x2, 264

        bl draw_pixel

        //pop!
        ldur x30, [sp, 48]
        ldur x10, [sp, 40]
        ldur x4, [sp, 32]
        ldur x3, [sp, 24]
        ldur x2, [sp, 16]
        ldur x1, [sp, 8]
        ldur x0, [sp]
        add sp, sp, 56


        ret


capa_valen:

        sub sp, sp, 8
        stur x30, [sp]

        
     	bl techo

        bl luces_techo

		bl pared_puerta

		bl puerta

		bl puerta_manija

        //bl pared_profundidad

        bl pared_pizarron

        bl pizarron_marco

        bl pizarron_verde

        bl pizarron_hojas

        bl pj_valen

        ldur x30, [sp]
        add sp, sp, 8

        ret

    techo:
        // push
        sub sp, sp, 56
        stur x0, [sp]
        stur x1, [sp, 8]
        stur x2, [sp, 16]
        stur x3, [sp, 24]
        stur x4, [sp, 32]
        stur x10, [sp, 40]
        stur x30, [sp, 48]

        // seteo el color
        movz x10, 0xc8, lsl 16
        movk x10, 0xb4a2, lsl 00

        // seteo coordenadas
        mov x1, 0
        mov x2, 0

        mov x3, 639
        mov x4, 79

        bl draw_rectangle

        //pop!
        ldur x30, [sp, 48]
        ldur x10, [sp, 40]
        ldur x4, [sp, 32]
        ldur x3, [sp, 24]
        ldur x2, [sp, 16]
        ldur x1, [sp, 8]
        ldur x0, [sp]
        add sp, sp, 56

        ret

    luces_techo:

        // push
        sub sp, sp, 56
        stur x0, [sp]
        stur x1, [sp, 8]
        stur x2, [sp, 16]
        stur x3, [sp, 24]
        stur x4, [sp, 32]
        stur x10, [sp, 40]
        stur x30, [sp, 48]

        bl luz_1

        bl luz_2
        
        //pop!
        ldur x30, [sp, 48]
        ldur x10, [sp, 40]
        ldur x4, [sp, 32]
        ldur x3, [sp, 24]
        ldur x2, [sp, 16]
        ldur x1, [sp, 8]
        ldur x0, [sp]
        add sp, sp, 56

        ret

        luz_1:

            // push
            sub sp, sp, 56
            stur x0, [sp]
            stur x1, [sp, 8]
            stur x2, [sp, 16]
            stur x3, [sp, 24]
            stur x4, [sp, 32]
            stur x10, [sp, 40]
            stur x30, [sp, 48]
            
            // seteo el color
            movz x10, 0xff, lsl 16
            movk x10, 0xffff, lsl 00

            //LUZ IZQ

            // seteo coordenadas
            mov x1, 144
            mov x2, 28

            mov x3, 153
            mov x4, 31

            bl draw_rectangle

            //seteo las coordenadas y pinto los pixeles
            mov x1, 142
            mov x2, 30
            bl draw_pixel

            mov x1, 154
            mov x2, 30
            bl draw_pixel

            //LUZ DER

            // seteo coordenadas
            mov x1, 504
            mov x2, 28

            mov x3, 513
            mov x4, 31

            bl draw_rectangle

            //seteo las coordenadas y pinto los pixeles
            mov x1, 502
            mov x2, 30
            bl draw_pixel

            mov x1, 514
            mov x2, 30
            bl draw_pixel

            //pop!
            ldur x30, [sp, 48]
            ldur x10, [sp, 40]
            ldur x4, [sp, 32]
            ldur x3, [sp, 24]
            ldur x2, [sp, 16]
            ldur x1, [sp, 8]
            ldur x0, [sp]
            add sp, sp, 56

            ret
        
        luz_2:

            // push
            sub sp, sp, 56
            stur x0, [sp]
            stur x1, [sp, 8]
            stur x2, [sp, 16]
            stur x3, [sp, 24]
            stur x4, [sp, 32]
            stur x10, [sp, 40]
            stur x30, [sp, 48]

            // seteo el color
            movz x10, 0xff, lsl 16
            movk x10, 0xffff, lsl 00

            //LUZ IZQ

            // seteo coordenadas
            mov x1, 162
            mov x2, 38

            mov x3, 171
            mov x4, 41

            bl draw_rectangle

            //seteo las coordenadas y pinto los pixeles
            mov x1, 160
            mov x2, 40
            bl draw_pixel

            mov x1, 172
            mov x2, 40
            bl draw_pixel

            //LUZ DER

            // seteo coordenadas
            mov x1, 486
            mov x2, 38

            mov x3, 495
            mov x4, 41

            bl draw_rectangle

            //seteo las coordenadas y pinto los pixeles
            mov x1, 484
            mov x2, 40
            bl draw_pixel

            mov x1, 496
            mov x2, 40
            bl draw_pixel

            //pop!
            ldur x30, [sp, 48]
            ldur x10, [sp, 40]
            ldur x4, [sp, 32]
            ldur x3, [sp, 24]
            ldur x2, [sp, 16]
            ldur x1, [sp, 8]
            ldur x0, [sp]
            add sp, sp, 56
            
            ret
        

    pared_puerta:
        // push
        sub sp, sp, 56
        stur x0, [sp]
        stur x1, [sp, 8]
        stur x2, [sp, 16]
        stur x3, [sp, 24]
        stur x4, [sp, 32]
        stur x10, [sp, 40]
        stur x30, [sp, 48]

        // seteo el color
        movz x10, 0xc8, lsl 16
        movk x10, 0xb4a2, lsl 00

        // seteo coordenadas
        mov x1, 0
        mov x2, 80

        mov x3, 96
        mov x4, 227

        bl draw_rectangle

        //pop!
        ldur x30, [sp, 48]
        ldur x10, [sp, 40]
        ldur x4, [sp, 32]
        ldur x3, [sp, 24]
        ldur x2, [sp, 16]
        ldur x1, [sp, 8]
        ldur x0, [sp]
        add sp, sp, 56

        ret

    puerta:
        // push
        sub sp, sp, 56
        stur x0, [sp]
        stur x1, [sp, 8]
        stur x2, [sp, 16]
        stur x3, [sp, 24]
        stur x4, [sp, 32]
        stur x10, [sp, 40]
        stur x30, [sp, 48]

        // seteo el color
        movz x10, 0x9b, lsl 16
        movk x10, 0x5909, lsl 00

        // seteo coordenadas
        mov x1, 10
        mov x2, 124

        mov x3, 49
        mov x4, 227

        bl draw_rectangle

        //pop!
        ldur x30, [sp, 48]
        ldur x10, [sp, 40]
        ldur x4, [sp, 32]
        ldur x3, [sp, 24]
        ldur x2, [sp, 16]
        ldur x1, [sp, 8]
        ldur x0, [sp]
        add sp, sp, 56

        ret

    puerta_manija:
        // push
        sub sp, sp, 56
        stur x0, [sp]
        stur x1, [sp, 8]
        stur x2, [sp, 16]
        stur x3, [sp, 24]
        stur x4, [sp, 32]
        stur x10, [sp, 40]
        stur x30, [sp, 48]

        // seteo el color
        movz x10, 0xd7, lsl 16
        movk x10, 0xd7d7, lsl 00

        // seteo coordenadas
        mov x1, 42
        mov x2, 178

        mov x3, 49
        mov x4, 195

        bl draw_rectangle

        //pop!
        ldur x30, [sp, 48]
        ldur x10, [sp, 40]
        ldur x4, [sp, 32]
        ldur x3, [sp, 24]
        ldur x2, [sp, 16]
        ldur x1, [sp, 8]
        ldur x0, [sp]
        add sp, sp, 56

        ret

    pared_profundidad:
        // push
        sub sp, sp, 56
        stur x0, [sp]
        stur x1, [sp, 8]
        stur x2, [sp, 16]
        stur x3, [sp, 24]
        stur x4, [sp, 32]
        stur x10, [sp, 40]
        stur x30, [sp, 48]

        // seteo el color
        movz x10, 0x88, lsl 16
        movk x10, 0x796a, lsl 00

        // seteo coordenadas
        mov x1, 96
        mov x2, 80

        mov x3, 159
        mov x4, 227

        bl draw_rectangle

        //pop!
        ldur x30, [sp, 48]
        ldur x10, [sp, 40]
        ldur x4, [sp, 32]
        ldur x3, [sp, 24]
        ldur x2, [sp, 16]
        ldur x1, [sp, 8]
        ldur x0, [sp]
        add sp, sp, 56

        ret

    pared_pizarron:
        // push
        sub sp, sp, 56
        stur x0, [sp]
        stur x1, [sp, 8]
        stur x2, [sp, 16]
        stur x3, [sp, 24]
        stur x4, [sp, 32]
        stur x10, [sp, 40]
        stur x30, [sp, 48]

        // seteo el color
        movz x10, 0xf3, lsl 16
        movk x10, 0xe3d1, lsl 00

        // seteo coordenadas
        mov x1, 314
        mov x2, 66

        mov x3, 385
        mov x4, 227

        bl draw_rectangle

        //pop!
        ldur x30, [sp, 48]
        ldur x10, [sp, 40]
        ldur x4, [sp, 32]
        ldur x3, [sp, 24]
        ldur x2, [sp, 16]
        ldur x1, [sp, 8]
        ldur x0, [sp]
        add sp, sp, 56

        ret

    pizarron_marco:
        // push
        sub sp, sp, 56
        stur x0, [sp]
        stur x1, [sp, 8]
        stur x2, [sp, 16]
        stur x3, [sp, 24]
        stur x4, [sp, 32]
        stur x10, [sp, 40]
        stur x30, [sp, 48]

        // seteo el color
        movz x10, 0x9f, lsl 16
        movk x10, 0x612e, lsl 00

        // seteo coordenadas
        mov x1, 318
        mov x2, 110

        mov x3, 381
        mov x4, 195

        bl draw_rectangle

        //pop!
        ldur x30, [sp, 48]
        ldur x10, [sp, 40]
        ldur x4, [sp, 32]
        ldur x3, [sp, 24]
        ldur x2, [sp, 16]
        ldur x1, [sp, 8]
        ldur x0, [sp]
        add sp, sp, 56

        ret

    pizarron_verde:
        // push
        sub sp, sp, 56
        stur x0, [sp]
        stur x1, [sp, 8]
        stur x2, [sp, 16]
        stur x3, [sp, 24]
        stur x4, [sp, 32]
        stur x10, [sp, 40]
        stur x30, [sp, 48]

        // seteo el color
        movz x10, 0x4b39, lsl 00

        // seteo coordenadas
        mov x1, 322
        mov x2, 114

        mov x3, 377
        mov x4, 191

        bl draw_rectangle

        //pop!
        ldur x30, [sp, 48]
        ldur x10, [sp, 40]
        ldur x4, [sp, 32]
        ldur x3, [sp, 24]
        ldur x2, [sp, 16]
        ldur x1, [sp, 8]
        ldur x0, [sp]
        add sp, sp, 56

        ret

    pizarron_hojas:

        // push
        sub sp, sp, 56
        stur x0, [sp]
        stur x1, [sp, 8]
        stur x2, [sp, 16]
        stur x3, [sp, 24]
        stur x4, [sp, 32]
        stur x10, [sp, 40]
        stur x30, [sp, 48]
        
        bl hoja_1

        bl hoja_2

        bl hoja_3

        bl hoja_4

        bl creeper

        //pop!
        ldur x30, [sp, 48]
        ldur x10, [sp, 40]
        ldur x4, [sp, 32]
        ldur x3, [sp, 24]
        ldur x2, [sp, 16]
        ldur x1, [sp, 8]
        ldur x0, [sp]
        add sp, sp, 56

        ret

        hoja_1:

            // push
            sub sp, sp, 56
            stur x0, [sp]
            stur x1, [sp, 8]
            stur x2, [sp, 16]
            stur x3, [sp, 24]
            stur x4, [sp, 32]
            stur x10, [sp, 40]
            stur x30, [sp, 48]

            // seteo el color
            movz x10, 0xf1, lsl 16
            movk x10, 0xecd9, lsl 00

            // seteo coordenadas
            mov x1, 328
            mov x2, 122

            mov x3, 345
            mov x4, 147

            bl draw_rectangle

            // detalle
                // chinche
                //color
                movz x10, 0xff, lsl 16
                //coordenadas
                mov x1, 330
                mov x2, 124

                bl draw_pixel

                //texto
                    //primer_linea
                    movz x10, 0x0, lsl 00

                    mov x1, 330
                    mov x2, 128

                    mov x3, 339
                    mov x4, 129

                    bl draw_rectangle

                    //segunda linea
                    mov x1, 330
                    mov x2, 132

                    mov x3, 341
                    mov x4, 133

                    bl draw_rectangle

                    // tercer linea

                    mov x1, 335
                    mov x2, 137

                    mov x3, 342
                    mov x4, 138

                    bl draw_rectangle

            //pop!
            ldur x30, [sp, 48]
            ldur x10, [sp, 40]
            ldur x4, [sp, 32]
            ldur x3, [sp, 24]
            ldur x2, [sp, 16]
            ldur x1, [sp, 8]
            ldur x0, [sp]
            add sp, sp, 56

            ret

        hoja_2:

            // push
            sub sp, sp, 56
            stur x0, [sp]
            stur x1, [sp, 8]
            stur x2, [sp, 16]
            stur x3, [sp, 24]
            stur x4, [sp, 32]
            stur x10, [sp, 40]
            stur x30, [sp, 48]

            // seteo el color
            movz x10, 0xf5, lsl 16
            movk x10, 0xE6B6, lsl 00

            // seteo coordenadas
            mov x1, 344
            mov x2, 144

            mov x3, 355
            mov x4, 161

            bl draw_rectangle

            // detalle
                //chinche
                //color
                movz x10, 0xff, lsl 16
                //coordenadas
                mov x1, 352
                mov x2, 146

                bl draw_pixel
                //texto
                    //color
                    movz x10, 0x0, lsl 00

                    //linea 1
                    mov x1, 347
                    mov x2, 150

                    mov x3, 352
                    mov x4, 151

                    bl draw_rectangle

                    //puntos
                    mov x1, 346
                    mov x2, 156

                    bl draw_pixel

                    mov x1, 352
                    mov x2, 156

                    bl draw_pixel

            //pop!
            ldur x30, [sp, 48]
            ldur x10, [sp, 40]
            ldur x4, [sp, 32]
            ldur x3, [sp, 24]
            ldur x2, [sp, 16]
            ldur x1, [sp, 8]
            ldur x0, [sp]
            add sp, sp, 56

            ret

        hoja_3:

            // push
            sub sp, sp, 56
            stur x0, [sp]
            stur x1, [sp, 8]
            stur x2, [sp, 16]
            stur x3, [sp, 24]
            stur x4, [sp, 32]
            stur x10, [sp, 40]
            stur x30, [sp, 48]
        
            // seteo el color
            movz x10, 0xf5, lsl 16
            movk x10, 0xe6b6, lsl 00

            // seteo coordenadas
            mov x1, 364
            mov x2, 134

            mov x3, 375
            mov x4, 145

            bl draw_rectangle

            // detalle
                //color
                movz x10, 0x9c, lsl 16
                movk x10, 0x5a3c, lsl 00
                
                //coordenadas
                mov x1, 365
                mov x2, 143

                bl draw_pixel

                mov x1, 367
                mov x2, 141

                bl draw_pixel

                mov x1, 369
                mov x2, 139

                bl draw_pixel

                //color pico
                movz x10, 0xb7ef, lsl 00

                mov x1, 371
                mov x2, 137

                bl draw_pixel

                mov x1, 369
                mov x2, 135

                bl draw_pixel

                mov x1, 367
                mov x2, 135

                bl draw_pixel

                mov x1, 373
                mov x2, 139

                bl draw_pixel

                mov x1, 373
                mov x2, 141

                bl draw_pixel

            //pop!
            ldur x30, [sp, 48]
            ldur x10, [sp, 40]
            ldur x4, [sp, 32]
            ldur x3, [sp, 24]
            ldur x2, [sp, 16]
            ldur x1, [sp, 8]
            ldur x0, [sp]
            add sp, sp, 56

            ret

        hoja_4:

            // push
            sub sp, sp, 56
            stur x0, [sp]
            stur x1, [sp, 8]
            stur x2, [sp, 16]
            stur x3, [sp, 24]
            stur x4, [sp, 32]
            stur x10, [sp, 40]
            stur x30, [sp, 48]
        
            // seteo el color
            movz x10, 0xf8, lsl 16
            movk x10, 0xf2e4, lsl 00

            // seteo coordenadas
            mov x1, 328
            mov x2, 168

            mov x3, 339
            mov x4, 185

            bl draw_rectangle

            // detalle
                // chinche
                //color
                movz x10, 0xff, lsl 16
                //coordenadas
                mov x1, 332
                mov x2, 170

                bl draw_pixel

                //texto
                movz x10, 0x0, lsl 00

                //primer linea
                mov x1, 330
                mov x2, 174

                mov x3, 337
                mov x4, 175

                bl draw_rectangle
                //segunda linea
                mov x1, 332
                mov x2, 177

                mov x3, 337
                mov x4, 178

                bl draw_rectangle
                //tercer linea
                mov x1, 334
                mov x2, 180

                mov x3, 337
                mov x4, 181

                bl draw_rectangle


            //pop!
            ldur x30, [sp, 48]
            ldur x10, [sp, 40]
            ldur x4, [sp, 32]
            ldur x3, [sp, 24]
            ldur x2, [sp, 16]
            ldur x1, [sp, 8]
            ldur x0, [sp]
            add sp, sp, 56

            ret

        creeper:

            // push
            sub sp, sp, 56
            stur x0, [sp]
            stur x1, [sp, 8]
            stur x2, [sp, 16]
            stur x3, [sp, 24]
            stur x4, [sp, 32]
            stur x10, [sp, 40]
            stur x30, [sp, 48]
        
            //color
            movz x10, 0x120d, lsl 00;

            //ojo izq
            mov x1, 359
            mov x2, 170

            mov x3, 362
            mov x4, 173

            bl draw_rectangle

            //ojo der
            mov x1, 367
            mov x2, 170

            mov x3, 370
            mov x4, 173

            bl draw_rectangle

            //boca_diome

            mov x1, 363
            mov x2, 174

            mov x3, 366
            mov x4, 179

            bl draw_rectangle

            //boca_izq

            mov x1, 361
            mov x2, 176

            mov x3, 362
            mov x4, 181

            bl draw_rectangle

            //boca_der

            mov x1, 367
            mov x2, 176

            mov x3, 368
            mov x4, 181

            bl draw_rectangle

            //pop!
            ldur x30, [sp, 48]
            ldur x10, [sp, 40]
            ldur x4, [sp, 32]
            ldur x3, [sp, 24]
            ldur x2, [sp, 16]
            ldur x1, [sp, 8]
            ldur x0, [sp]
            add sp, sp, 56

            ret
.endif
