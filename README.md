# soal-shift-sisop-modul-1-E11-2021

## Nama Anggota
```
1. Aimar Wibowo 05111940000034
2. Refaldyka Galuh Pratama 05111940000209
3. Adam Hadi Prasetyo 05111940000224
```
## Penjelasan Soal Nomor 1A, 1B , dan 1D
Ryujin diminta untuk menampilkan semua pesan error yang muncul beserta jumlah kemunculannya. Untuk merealisasikan jumlah kemunculannya kami menggunakan command dibawah ini.

```
tr ' ' '\n' < syslog.log | grep "" | wc -l
```

Pada command tersebut dapat kita lihat terdapat command `tr ' ' '\n' < syslog.log` yaitu mentranslate spasi menjadi newline pada file syslog.log kemudian dilanjutkan oleh command `grep ""` yang mengambil kata kunci khusus dan yang terakhir `wc -l` yang artinya menghitung setiap kata yang muncul pada file syslog.log. Setelah itu, agar command dapat lebih mudah dipanggil kami menjadikan command tersebut variabel untuk setiap macam error yang muncul yaitu seperti dibawah ini.


```
ticketmodi="$(tr ' ' '\n' < syslog.log | grep "modified" | wc -l)"
permiden="$(tr ' ' '\n' < syslog.log | grep "Permission" | wc -l)"
triedadd="$(tr ' ' '\n' < syslog.log | grep "Tried" | wc -l)"
timeout="$(tr ' ' '\n' < syslog.log | grep "Timeout" | wc -l)"
doesnt="$(tr ' ' '\n' < syslog.log | grep "exist" | wc -l)"
connect="$(tr ' ' '\n' < syslog.log | grep "Connection" | wc -l)"
```

Setelah itu menggunakan `Echo` untuk mengenampilkan pesan errornya dan memanggil `$` untuk variable jumlah banyaknya kemunculan pesan error tersebut. Selanjutnya, kita menggunakan command `sort` untuk mengurutkan. Tidak lupa menambahkan `-n` yang tertuju hanya pada numeric atau angka dan `-r` yaitu dari yang terbesar hingga ke yang terkecil dan untuk menujukkan mana bagian numerik atau angkanya kita butuh delimitir dengan command `-t` serta dengan `-k`untuk menunjukkan bagian mana angka itu berada. Untuk header kami menggunakan  command `sed '1i'` yang artinya memasukkan kata - kata pada line pertama.Tidak hanya itu, setelahnya disimpan dalam file `error_message.csv` Dengan penjelasan ini, didapatkan hasil seperti berikut.

```
echo "The ticket was modified while updating,$ticketmodi 
Permission denied while closing ticket,$permiden
Tried to add information to closed ticket,$triedadd
Timeout while retrieving information,$timeout 
Ticket doesn't exist,$doesnt 
Connection to DB failed,$connect" |
sort -n -r -t',' -k2 | sed '1i Error,Count' > error_message.csv
```

## Penjelasan Soal Nomor 1C, dan 1E
Ryujin diminta untuk menampilkan jumlah kemunculan `ERROR` dan `INFO` untuk setiap usernya dan disimpan pada file `user_statistic.csv` secara yang terkecil hingga yang terbesar dan tidak lupa header `Username,INFO,ERROR`.

```
echo "Username,INFO,ERROR" > user_statistic.csv |
tr ' ' '\n' < syslog.log > tmp1.txt
grep -o "(.*)" tmp1.txt | tr -d "(" | tr -d ")" | sort | uniq >> tmp2.txt
```

Seperti yang dapat dilihat diatas pertama kami memasukkan header `Username,INFO,ERROR` kedalam file `user_statistic.csv` terlebih dahulu kemudian seperti nomor 1 yang lain kami menggunakan command `tr ' ' '\n' < syslog.log` untuk mengganti spasi menjadi newline dan disimpan pada file temporary yang bernamakan `tmp1.txt`. Kemudian, menggunakan command `grep -o "(.*)" tmp1.txt` yang artinya mengambil kata kunci khusus yang spesifik ( dengan menggunakan `-o` ) dari dalam file `tmp1.txt` dan yang ada pada dalam tanda `()`. 

Dengan menggunakan command `tr -d""` kita dapat menghapus tanda kurung tersebut. Kemudian,untuk mengurutkannya kami menggunakan command `sort` dan untuk mengelompokkannya kami menggunakan command `uniq`. Setelah itu, disimpan dalam file temporary kedua yang bernamakan `tmp2.txt`.

Memasukki bagian perulangan kami menggunakan command `while read line` agar data yang didapatkan diiterasi setiap linenya. Untuk setiap `user`yang ada pada `while` dilakukan hal dibawah ini.
```
do
info=$(grep "INFO.*($user)" syslog.log | wc -l)
error=$(grep "ERROR.*($user)" syslog.log | wc -l)
echo "$user,$info,$error" >> user_statistic.csv 
done < tmp2.txt 
```
Yaitu pada saat kemunculan tiap tiap pesan `INFO` atau `ERROR` dihitung jumlah kemunculannya dengan command `wc -l` dan dimasukkan kedalam variabel. Setelah perulangan selesai, kami tampilkan `Username,INFO,ERROR` dengan command `echo "$user,$info,$error""`. Diakhir, kami menyimpan semua `Username,INFO,ERROR` pada file `user_statistic.csv`.
