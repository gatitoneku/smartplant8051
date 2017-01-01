# smartplant8051
Ini adalah penyiram tanaman otomatis berbasis mikrokontroler 8051. 8051 membaca nilai analog dari sensor kelembaban tanah yang terlebih dahulu dikonversi ke digital menggunakan IC ADC0804. Jika nilai yang terbaca dari ADC adalah dibawah 128 (Kelembaban 50%), maka 8051 akan mengaktifkan actuator berupa katup solenoid 12V untuk beberapa waktu, lalu menutupnya kembali. Pengguna juga dapat menekan pushbutton untuk mengaktifkan actuator secara langsung.

Skema hardware:
![alt tag](http://puu.sh/t7C5n/95ac81e969.png)
