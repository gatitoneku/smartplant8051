;##########################################################################################
;# Proyek Akhir Sistem Berbasis Komputer - Program Penyiram Tanaman Otomatis
;# 	M. Yusuf Irfan H. - 1406569415
;# 	Izzan Dienurrahman - 1406531952
;# 	Rifqi Muhammad - 1406532021
;# 	Umar Abdul Aziz - 1406532085
;# Ini adalah program 8051 untuk penyiram tanaman otomatis
;# Sensor kelembaban tanah terhubung pada IC ADC0804 yang di-interface ke 8051
;# Jika nilai kelembaban tanah dari ADC lebih rendah dari nilai threshold, artinya tanah kering
;# Dan sistem akan menyalakan aktuator (katup solenoid) untuk menyiram tanaman
;# User juga dapat menekan push button yang akan langsung mengaktifkan aktuator untuk menyiram
;##########################################################################################

	rd equ P1.0           ;Pin RD pada ADC
	wr equ P1.1           ;Pin WR pada ADC
	cs equ P1.2           ;Pin CS pada ADC
	intr equ P1.3         ;Pin INTR pada ADC
	act equ P3.0	      ;Aktuator di Port 3.0	
 	
	adc_port equ P2       ;Sensor terhubung pada ADC di port P2
	adc_val equ 30H       ;Alamat memori untuk menyimpan hasil ADC
	push_but equ P3.3	;Pushbutton untuk langsung mengaktifkan aktuator
;################################################################################################	
	org 0H
	ljmp main

	org 013h		;ISR INT1 (jika pushbutton ditekan)
	mov tmod, #10h		;set mode 1 timer 1
	mov th1, #0h
	mov tl1, #0h		;set time delay tertinggi untuk timer 1
	setb tr1		;nyalakan timer1
	setb act		;nyalakan aktuator
	back1: jnb tf1, back1	;tunggu sebentar untuk aktuator menyiram tanaman
	clr tr1			; matikan timer 1
	clr tf1			; clear timer 1 flag
	clr act			; matikan aktuator
	reti
;################################################################################################	
	org 030h		;Main program mulai disini
main:
	mov IE, #10000100b 	;Mengenable external interrupt (INT1) dari pushbutton
	mov P2,#11111111B 	; Inisiasi P2 sebagai input
	setb p3.3		; Inisiasi P3 sebagai input
	setb P1.3 		; Inisiasi P1.3 sebagai input
	;mov P2, #00001111B
start:                    
	acall conv            ;memulai konversi ADC
	acall read            ;membaca nilai ADC
	acall compare	      ;bandingkan nilai read ADC dan threshold value	
	sjmp start            ;looping
 
conv:                         ;konversi adc
	clr cs                
	clr wr               
	nop
	setb wr               
	setb cs              
wait:
	jb intr,wait          ;Tunggu sinyal INTR dari ADC
	ret                   ;konversi selesai
 
read:                         ;baca nilai adc
	clr cs                
	clr rd                
	mov a,adc_port        ;Membaca nilai ADC
	mov adc_val,a         ;Masukkan nilai ADC ke variabel
	setb rd               
	setb cs               
	ret                   ;membaca ADC selesai

compare:
	clr psw.7		;clear carry
	mov a, adc_val		;masukkan nilai ADC terakhir ke A
	subb a, #10000000b	;Kurangi nilai ADC dengan threashold (128)
	jc spray		;Jika C=1 artinya nilai ADC kurang dari threshold, maka akan menyiram
	ret			;Jika ADC lebih dari threshold, maka program akan mengulang

	spray: 
	mov tmod, #10h		;set mode 1 timer 1
	mov th1, #0h
	mov tl1, #0h		;set time delay tertinggi untuk timer 1
	setb tr1		;nyalakan timer1
	setb act		;nyalakan aktuator
	back: jnb tf1, back	;tunggu sebentar untuk aktuator menyiram tanaman
	clr tr1			; matikan timer 1
	clr tf1			; clear timer 1 flag
	clr act			; matikan aktuator
	ret

end
	