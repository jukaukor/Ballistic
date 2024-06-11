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
# Juhani Kaukoranta 7.4.2023
function ballistic(R,S,GM)
    # R = massakeskuksen (planeetta, kuu tms) säde m
    # S = lähtöpaikan ja maalin kaarivälimatka m
    # GM massakeskuksen (planeetta,kuu jne) painovoimavakio*massa SI-yksiköissä
    θ = S/(2*R) # keskuskulman puolisko rad, true anomaly
    L = 2*R*sin(θ)  # lähdön ja maalin suora välimatka (m)
    a = (R/2 + L/4) # rataellipsin iso puoliakseli m
    p = L/2 # rataellipsin semi-latus rectum
    hmom = sqrt(p*GM) # rataliikemäärämomentti, vakio
    # hmom = R*v0*cos(alfarad) = vakio = r*v*cos(Φ), Φ=flight path angle
    # saatu polttopisteista laskettujen etäisyyksien summa=2a
    eks = R*cos(θ)/(2*a) # radan eksentrisyys e=c/a
    b = a*sqrt(1 - eks^2) # rataellipsin pieni puoliakseli
    v0 = sqrt(GM*(2/R - 1/a)) # lähtönopeus m/s
    alfarad = pi/4 -θ/2 # lähtökulma (rad),massakeskuksen pinnan suhteen
    alfadeg = 45 - θ/2*180/pi # lähtökulma asteina
    hmax = a*(1+eks)-R # lakikorkeus planeetan pinnasta
    vlaki = R*v0*cos(alfarad)/(a*(1+eks)) # nopeus lakipisteessä
    # lentoajan laskeminen, lakipiste apopapsis, ei periapsis
    E = acos((eks-cos(θ))/(1-eks*cos(θ))) #eksentrinen anomalia lakipisteessä
    tlaki = sqrt(a^3/GM)*(pi-E+eks*sin(E)) # lentoaika lakipisteeseen
    tmaali = 2*tlaki # lentoaika maaliin
    n = 10 # ratapisteiden lukumäärä  plottausta yms varten
    dist = θ/(n-1);
    #φ = reverse(0:dist:θ)) # kulmaväli  θ -> 0 jaettuna n osaan, true anomaliat
    φ = reverse(0:dist:θ);
    # φ massakeskuksesta (rataellipsin polttopiste) lähtöpaikan ja ratapisteen välinen kulma
    # φ sanotaan myös true anomalia, normaalisti polttopisteiden välin suoralla φ=0 
    # nyt φ=θ lähtöpisteessä, siksi reverse 
    E = @. acos((eks-cos(φ))/(1-eks*cos(φ))); # true anomaliaa φ vastaava eksentrinen anomalia
    tφ = @. sqrt(a^3/GM)*(pi-E+eks*sin(E)); # lentoajat true anomaliaan φ asti
    r = @. p/(1 - eks*cos(φ)); # nousuradan ratapisteiden etäisyydet massakeskuksesta (planeetta,kuu tms)
    h = @. (r - R); # nousuradan korkeudet massakeskuksen pinnasta
    h2 = reverse(h); # laskuradan korkeudet massakeskuksen pinnasta
    htotal = [h; h2[2:end]]; # koko lentoradan korkeudet lähtöpisteesta maaliin
    r2 = reverse(r); # laskuradan etäisyydet massakeskuksesta
    rr = [r; r2[2:end]]; # kaikki etäisyydet massakeskuksesta lähtöpisteestä maaliin
    tφ2 = reverse(tφ); # lentoajat lakipisteesta maaliin
    s = tφ[1] # lentoaika lakipisteeseen
    for i=1 : length(tφ)-1
        s += abs.(diff(tφ)[i])
        tφ2[i] = s
    end
    nousuajat = reverse(tφ);
    laskuajat = tφ2[1:end-1];
    lentoajat = [nousuajat; laskuajat];
    v = @. sqrt(GM*(2/rr-1/a));
    Φ = @. acos(hmom/(rr*v))*180/pi # flight path angles
    # fligthpath angle = r:n normaalin ja nopeusvektorin välinen kulma

    println("Projektiili lentää lähtöpaikasta maaliin")
    println("Lentorata on osa ellipsiä, jonka polttopisteenä on planeetan keskipiste")
    println("Toinen polttopiste on lähtöpaikan ja maalin yhdysjanan puolivälissä")
    println("Näin muodostuva rataellipsi on minimienergiarata")
    println("Projektiilin lähtökulma planeetan pinnan tangentin suhteen = ",round(alfadeg,digits=2),"°")
    println("Projektiilin lähtökulma planeetan pinnan normaalin suhteen = ",round(90-alfadeg,digits=2),"°")
    println("Lähtönopeus m/s = ",round(v0,digits=2)," m/s")
    println("Projektiilin kantaman kaari S = ",round(S)," m")
    println("Lakikorkeus planeetan pinnasta hmax = ",round(hmax)," m")
    println("Lakipisteen etäisyys planeetan keskipisteestä = ",round(a*(1+eks))," m")
    println("Lakipisteessä nopeus = ",round(vlaki,digits=2)," m/s")
    println("Nousuaika lakikorkeuteen = ",round(tlaki,digits=2)," s")
    println("Lentoaika maaliin = ",round(tmaali,digits=2)," s")
    println("Maaliin iskeytymisen nopeus ",round(v0,digits=2)," m/s")
    println("Maaliin iskeytymiskulma pinnan tangentin suhteen ",round(alfadeg,digits=2)," °")
    println("Maaliin iskeytymiskulma pinnan normaalin suhteen ",round(90-alfadeg,digits=2)," °")
    println("Projektiilin liikemäärämomentti massayksikköä kohti = ",round(hmom)," m²/s")
    println("Liikemäärämomentti pysyy vakiona koko lennon ajan")
    println("Tietoa rataellipsistä:")
    println("Rataellipsin iso puoliakseli a = ",round(a)," m")
    println("Rataellipsin pieni puoliakseli b = ",round(b)," m")
    println("Rataellipsin semi-latus rectum = ",round(p)," m")
    println("Rataellipsin eksentrisyys = ",round(eks,digits=5)," m")
    println("Rataellipsin polttopisteiden väli 2c = ",round(R*cos(θ))," m")
end