Ballistic flight from planets or moon's point1 to point2
# Ballistinen elliptinen lentorata
# planeetan pinnalla olevasta lähtöpaikasta pinnalla olevaan maaliin
# polttopiste F1 pallomaisen massakeskuksen keskipisteessä
# polttopiste F2 on lähtöpaikan ja maalin yhdysjanan puolivälissä
# näin saadaan minimienergiarata lähtöpaikasta maaliin
# laskee projektiilille tarvittavan lähtönopeuden ja lähtökulman 
# ja antaa ellipsiradan parametreja
# ei ilmanvastusta
# Testaa lentorata Kuun Copernicus -> Tycho
# komennolla ballistic(1738000,1623000,4.9028001e12)
# jossa R=1738000 m, S = 1623000 m, GM = 4.9028001e12
# Kuun Apollo 11 -> Apollo 17 laskeutumispaikkojen välillä 630.1 km lentorata:
# ballistic(1738000,630100,4.902800118e12)
# 100 m heitto Kuussa: ballistic(1738000,100,4.902800118e1)
# (antaa samat arvot kuin Kuun pinnalla g=1.623 ptutouskiihtyvyyden
# perinteinen vino heittoliike)
# Lentorata Merkuriuksessa pohjoisnavalta etelänavalle:
# ballistic(3439700,3831800,2.2031868551e13)
# Juhani Kaukoranta 11.6.2024
