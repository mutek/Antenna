#!/usr/bin/env sh
# Calcola SNR
# SNR = Prx - N
# n:
# 2		free space
# 2.7 - 3.5	urban
# 3 - 5		suburban
# 1.6 - 1.8 	indoor LOS
# 2 - 6		indoor NLOS
#
# energie in dBm
# frequenze in Hz
# distanze in metri
# velocita in m/s
# tempi in secondi
#
# Prx: 	received signal power
# N:		noise
# fbw:	Bandwith (Hz)
# NF:	Noise Figure
# Ptx:	Transmit signal power
# Lfs:	Free space loss
# Gtx,Grx:	Gain of tx/rx antenna
# n:		Path loss exponent
# d:		Distance between antenna
# f:		Frequency
# c:		Speed of light

# FSPL(dB): Free Space Path Loss:
# 10*log((4*pi/c  *  d*f)^2) = 20*log(d) + 20*log(f) - 147.55 

# Friis:
# Pr/Pt = Gt*Gr * (lamda / 4*pi*d)^2

# Attenuazione di spazio libero (dB) -> [R]=[Km], [f]=[MHz], [Gt||Gr]=[dB]
# Pt/Pr = log( (4*pi*R / lamda)^2 * 1/Gr*Gt) = 32.4 + 20*log(R) + 20*log(f) - Gt - Gr

# Bilancio di collegamento - link budget -> A(d) attenuazione f(d), G guadagni (amplificazioni)
# Pr = Pt*G / A(d)
# su canale radio:
# Pr = Pt*Gtx*Grx / A  * (lamda / 4*pi*d)^2

# speed of light
c=$(echo "2.99792450*(10^8)"| bc -l)
# free space scenario
#n=3

# indoor NLOS worst scenario
n=6

# antenna distance 100 mt
d=100
# Gtx: i.e patch panel 14 dBm
Gtx=9
# Grx: i.e patch panel 10 dBm
Grx=9
# Ptx 20 dBm EIRP
Ptx=20
# Frequency 2,4Ghz
f=2400000000
# Channel width (20 or 40 Mhz) non overlapping channels in 2,4 Ghz 1,6,11
fbw=20000000

# Sensitivity min and max in dBm (i.e. TP-LINK TL-WR841ND 270M@-68dBm10%PER - 1M@-90dBm8%PER)
SensRxMin=-68
SensRxMax=-90

# +/- 4 dB
NF=10
#
dfc=$(echo "$d*$f/$c" | bc -l)


echo "Distanza tra le due antenne = "$d" metri"
echo "Canale da "$(echo "scale=0;$fbw / 1000000" | bc -l)" MHz"
echo "Sulla frequenza base di "$(echo "scale=1;$f/1000000000" | bc -l)" GHz"
echo ""
echo "Attenuazioni e guadagni in Decibel [dB]"
echo ""
# conversione logaritmo da naturale a base 10
# bc lavora sono con i naturali
# Log_10(x) = Log_e(x) / Log_e(10)

Lfs=$(echo "$n*(10*(l($dfc)/l(10)))" | bc -l)

echo "Attenuazione di spazio libero (Lfs) = "$(echo "scale=1;$Lfs/1" | bc -l)" dB"

Prx=$(echo "$Ptx-$Lfs+$Gtx+$Grx" | bc -l)

echo "Potenza in ricezione (Prx) = "$(echo "scale=1;$Prx/1" | bc -l)" dB"

N=$(echo "-174+10*(l($fbw)/l(10))+$NF" | bc -l)

echo "Rumore (N) = "$(echo "scale=1;$N/1" | bc -l)" dB"

# bc non legge scale per le differenze...quindi dividere per 1!!!
SNR=$(echo "scale=1;($Prx-($N))/1" | bc -l)

echo "Rapporto Segnale/Rumore (SNR) = "$SNR" dB"
echo "Sens Rx Min = "$SensRxMin
echo "Sens Rx Max = "$SensRxMax
# regulator:
# ifconfig wlan0 down
# iw reg set BO
# iw reg get
# iwconfig wlan0 txpower 30
# ifconfig wlan0 up
