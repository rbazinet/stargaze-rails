# coding: UTF-8
require 'open-uri'

puts "Constellations"
open("http://en.wikipedia.org/w/api.php?format=xml&action=parse&page=List_of_constellations&prop=text&section=1") do |c|
  a=c.read
  a=a.gsub!(/&lt;/, "<")
  a=a.gsub!(/&gt;/, ">")
  a=a.gsub!(/<.*?>/,"")
  a=a.gsub!(/\[\d\]/,"")
  a=a.split("\n\n\n")
  i=0
  a.each do |b|
    if i>1 and i<90
      b=b.split("\n")
      con=Astro::Constellation.new
      con.name=b[0]
      con.abb1=b[2]
      con.abb2=b[3]
      con.genitive=b[4]
      con.origin=b[6]
      con.meaning=b[7]
      con.save!
    end
    i+=1
  end
end

puts "Stars"
Astro::Constellation.all.each do |con|
  if con.name.match(" ")
    con.name=con.name.gsub!(" ","_")
  end
  
  open(URI.encode("http://en.wikipedia.org/w/api.php?format=xml&action=parse&page=List_of_stars_in_#{con.name}&prop=text&section=0")) do |c|
    puts "  Stars in #{con.name}"
    a=c.read
    a=a.gsub!(/&lt;/, "<")
    a=a.gsub!(/&gt;/, ">")
    aa=a.scan(/<tr>\n<td>.*<\/td>\n<td>.*<\/td>\n<td>.*<\/td>\n<td>.*<\/td>\n<td>.*<\/td>\n<td>.*<\/td>\n<td>.*<\/td>\n<td>.*<\/td>\n<td>.*<\/td>\n<td>.*<\/td>\n<td>.*<\/td>\n<td.*<\/td>\n<\/tr>/)
    aaa=a.scan(/<tr>\n<td>.*<\/td>\n<td>.*<\/td>\n<td>.*<\/td>\n<td>.*<\/td>\n<td>.*<\/td>\n<td>.*<\/td>\n<td>.*<\/td>\n<td>.*<\/td>\n<td>.*<\/td>\n<td>.*<\/td>\n<td>.*<\/td>\n<td>.*<\/td>\n<td.*<\/td>\n<\/tr>/)
    puts aa.count
    puts aaa.count
    aaa.each do |c|
      c=c.gsub!(/<.*?>/,"")
      c=c.gsub!(/&amp;#160;/,"")
      unless c==nil
        c=c.split("\n")
        star=Astro::Star.new
        star.constellation_id=con.id
        star.name=c[1]
        star.right_ascension=c[7]
        star.declination=c[8]
        star.apparent_magnitude=c[9]
        star.stellar_class=c[12]
        if c.size>13
          star.info=c[13]
        end
        star.save
      end
    end
    aa.each do |c|
      c=c.gsub!(/<.*?>/,"")
      c=c.gsub!(/&amp;#160;/,"")  
      unless c==nil
        c=c.split("\n")
        star=Astro::Star.new
        star.constellation_id=con.id
        star.name=c[1]
        star.right_ascension=c[6]
        star.declination=c[7]
        star.apparent_magnitude=c[8]
        star.stellar_class=c[11]
        if c.size>12
          star.info=c[12]
        end
        star.save
      end
    end
  end
end

puts "Ngc"
ngc_addresses=[
  "http://en.wikipedia.org/w/api.php?format=xml&action=parse&page=List_of_NGC_objects_(1%E2%80%931000)&prop=text",
  "http://en.wikipedia.org/w/api.php?format=xml&action=parse&page=List_of_NGC_objects_(1001%E2%80%932000)&prop=text",
  "http://en.wikipedia.org/w/api.php?format=xml&action=parse&page=List_of_NGC_objects_(2001%E2%80%933000)&prop=text",
  "http://en.wikipedia.org/w/api.php?format=xml&action=parse&page=List_of_NGC_objects_(3001%E2%80%934000)&prop=text",
  "http://en.wikipedia.org/w/api.php?format=xml&action=parse&page=List_of_NGC_objects_(4001%E2%80%935000)&prop=text",
  "http://en.wikipedia.org/w/api.php?format=xml&action=parse&page=List_of_NGC_objects_(5001%E2%80%936000)&prop=text",
  "http://en.wikipedia.org/w/api.php?format=xml&action=parse&page=List_of_NGC_objects_(6001%E2%80%937000)&prop=text",
  "http://en.wikipedia.org/w/api.php?format=xml&action=parse&page=List_of_NGC_objects_(7001%E2%80%937840)&prop=text"
]

ngc_addresses.each do |adress|
  puts adress.split("_")[4].split("&")[0].gsub!(/%E2%80%93/,"-")
  open(adress) do |c|
    a=c.read
    a=a.gsub!(/&lt;/, "<")
    a=a.gsub!(/&gt;/, ">")
    a=a.scan(/<tr>\n<td>.*<\/td>\n<td>.*<\/td>\n<td>.*<\/td>\n<td>.*<\/td>\n<td>.*<\/td>\n<td>.*<\/td>\n<td>.*<\/td>\n<\/tr>/)
    a.each do |c|
      c=c.gsub!(/<.*?>/,"")
      if c.match(/&amp;#160;/)
        c=c.gsub!(/&amp;#160;/,"")
      end
      if c.match(/\[.*\]/)
        c=c.gsub!(/\[.*\]/,"")
      end
      c=c.split("\n")
      if not (c[4]=="" or c[4]==nil)
        n=Astro::Ngc.new
        if c[4]=="toward Leo"
          n.constellation_id=Astro::Constellation.find_by_name("Leo").id
        elsif c[4]== "Serpens Cauda"
          n.constellation_id=Astro::Constellation.find_by_name("Serpens").id
        else
          n.constellation_id=Astro::Constellation.find_by_name(c[4]).id  
        end
        n.ngc_number=c[1]
        n.names=c[2]
        n.object_type=c[3]
        n.right_ascension=c[5]
        n.declination=c[6]
        n.apparent_magnitude=c[7]
        n.save
      end
    end
  end
end

open("http://en.wikipedia.org/w/api.php?format=xml&action=parse&page=List_of_NGC_objects_(7001%E2%80%937840)&prop=text") do |c|
  puts "additional from 7000+"
  a=c.read
  a=a.gsub!(/&lt;/, "<")
  a=a.gsub!(/&gt;/, ">")
  a=a.scan(/<tr>\n<td>.*<\/td>\n<td>.*<\/td>\n<td>.*<\/td>\n<td>.*<\/td>\n<td>.*<\/td>\n<td>.*<\/td>\n<td>.*<\/td>\n<td>.*<\/td>\n<\/tr>/)
  a.each do |c|
    c=c.gsub!(/<.*?>/,"")
    if c.match(/&amp;#160;/)
      c=c.gsub!(/&amp;#160;/,"")
    end
    if c.match(/&quot;/)
      c=c.gsub!(/&quot;/,"\"")
    end
    if c.match(/\[.*\]/)
      c=c.gsub!(/\[.*\]/,"")
    end
    c=c.split("\n")
    n=Astro::Ngc.new
    if c[6]=="Cefeusz"
      n.constellation_id=Astro::Constellation.find_by_name("Cepheus").id
    elsif c[6]=="Lisek"
      n.constellation_id=Astro::Constellation.find_by_name("Vulpecula").id
    elsif c[6]=="Żuraw"
      n.constellation_id=Astro::Constellation.find_by_name("Grus").id
    elsif c[6]=="Oktant"
      n.constellation_id=Astro::Constellation.find_by_name("Octans").id
    else
      n.constellation_id=Astro::Constellation.find_by_name(c[6]).id  
    end
    n.ngc_number=c[1].split(" ")[1]
    n.object_type=c[2]
    n.right_ascension=c[3].gsub!(" ", "")
    n.declination=c[4].gsub!(" ", "")
    n.apparent_magnitude=c[5]
    n.save
  end
end

puts "Messier"
open("http://en.wikipedia.org/w/api.php?format=xml&action=parse&page=List_of_Messier_objects&prop=text&section=1") do |c|
  a=c.read
  a=a.gsub!(/&lt;/, "<")
  a=a.gsub!(/&gt;/, ">")
  a=a.scan(/<tr.*>\n<td.*>.*<\/td>\n<td.*>.*<\/td>\n<td.*>.*<\/td>\n<td.*>.*<\/td>\n<td.*>.*<\/td>\n<td.*>.*<\/td>\n<td.*>.*<\/td>\n<td.*>.*<\/td>\n<\/tr>/)
  a.each do |c|
    c=c.gsub!(/<.*?>/,"")
    if c.match(/&amp;#160;/)
      c=c.gsub!(/&amp;#160;/,"")
    end
    if c.match(/\[.*\]/)
      c=c.gsub!(/\[.*\]/,"")
    end
    c=c.split("\n")
    if not c[1]=="M102"
      mes=Astro::Messier.new
      mes.messier_number=c[1].split("M")[1]
      mes.ngc_number=c[2].split(" ")[1]
      mes.common_name=c[3]
      mes.object_type=c[5]
      mes.distance_kly=c[6]
      mes.constellation_id=Astro::Constellation.find_by_name(c[7]).id
      mes.apparent_magnitude=c[8]
      mes.save
    end
   end
end

puts "Solar system"
  puts "  sun"
  a=Astro::Solar.new
  a.name="Sun"
  a.position=0
  a.size=1392000
  a.size_earth=109
  a.mass=1989100000
  a.mass_earth=332950
  a.distance=0
  a.distance_earth=0
  a.orbital_period="0"
  a.trading_period="25d 9h 7m"
  a.moons=0
  a.type="Star"
  a.info="The Sun is the star at the center of the Solar System. It is almost perfectly spherical and consists of hot plasma interwoven with magnetic fields. It has a diameter of about 1,392,684 km, about 109 times that of Earth, and its mass (about 2×1030 kilograms, 330,000 times that of Earth) accounts for about 99.86% of the total mass of the Solar System. Chemically, about three quarters of the Sun's mass consists of hydrogen, while the rest is mostly helium. The remainder (1.69%, which nonetheless equals 5,628 times the mass of Earth) consists of heavier elements, including oxygen, carbon, neon and iron, among others."
  a.save

  puts "  mercury"
  a=Astro::Solar.new
  a.name="Mercury"
  a.position=1
  a.size=4879
  a.size_earth=0.3825
  a.mass=330.2
  a.mass_earth=0.0552
  a.distance=57909170
  a.distance_earth=0.3871
  a.orbital_period=87.969
  a.trading_period="58d 15h 26m"  
  a.moons=0
  a.type="Rocky"
  a.info="Mercury is the innermost planet in the Solar System, named after the Roman god Mercury, the messenger to the gods. It is the smallest of the eight planets in the Solar System. It orbits the Sun once in about 88 Earth days. Since is has almost no atmosphere to retain heat, Mercury's surface experiences the greatest temperature variation of all the planets, ranging from 100 K (−173 °C; −280 °F) at night to 700 K (427 °C; 800 °F) during the day. Mercury's axis has the smallest tilt of any of the Solar System's planets (less than 1⁄30 of a degree), but it has the largest orbital eccentricity. At aphelion, Mercury is about 1.5 times as far from the Sun as it is at perihelion. Mercury's surface is heavily cratered and similar in appearance to Earth's Moon, indicating that it has been geologically inactive for billions of years."
  a.save

  puts "  venus"
  a=Astro::Solar.new
  a.name="Venus"
  a.position=2
  a.size=12104
  a.size_earth=0.9489
  a.mass=4868.5
  a.mass_earth=0.8149
  a.distance=108208926
  a.distance_earth=0.7233
  a.orbital_period=224.701
  a.trading_period="243d 0h 27m"
  a.moons=0
  a.type="Rocky"
  a.info="Venus is the second planet from the Sun, orbiting it every 224.7 Earth days. The planet is named after the Roman goddess of love and beauty. After the Moon, it is the brightest natural object in the night sky, reaching an apparent magnitude of −4.6, bright enough to cast shadows. Because Venus is an inferior planet from Earth, it never appears to venture far from the Sun: its elongation reaches a maximum of 47.8°. Venus reaches its maximum brightness shortly before sunrise or shortly after sunset, for which reason it has been referred to by ancient cultures as the Morning Star or Evening Star."
  a.save

  puts "  earth"
  a=Astro::Solar.new
  a.name="Earth"
  a.position=3
  a.size=12756
  a.size_earth=1
  a.mass=5974.2
  a.mass_earth=1
  a.distance=149597887
  a.distance_earth=1
  a.orbital_period=365.256
  a.trading_period="23h 56m 04s"
  a.moons=1
  a.type="Rocky"
  a.info="Earth is the third planet from the Sun, and the densest and fifth-largest of the eight planets in the Solar System. It is also the largest of the Solar System's four terrestrial planets. It is sometimes referred to as the world or the Blue Planet. Earth formed approximately 4.54 billion years ago, and life appeared on its surface within one billion years. Earth's biosphere then significantly altered the atmospheric and other basic physical conditions, which enabled the proliferation of organisms as well as the formation of the ozone layer, which together with Earth's magnetic field blocked harmful solar radiation, and permitted formerly ocean-confined life to move safely to land. The physical properties of the Earth, as well as its geological history and orbit, have allowed life to persist. Estimates on how much longer the planet will be able to continue to support life range from 500 million years (myr), to as long as 2.3 billion years (byr)."
  a.save

puts "  mars"
  a=Astro::Solar.new
  a.name="Mars"
  a.position=4
  a.size=6805
  a.size_earth=0.5335 
  a.mass=641.9
  a.mass_earth=0.1074
  a.distance=227936637
  a.distance_earth=1.5237
  a.orbital_period=686.960
  a.trading_period="24h 37m 23s"
  a.moons=2
  a.type="Rocky"
  a.info="Mars is the fourth planet from the Sun and the second smallest planet in the Solar System. Named after the Roman god of war, it is often described as the 'Red Planet', as the iron oxide prevalent on its surface gives it a reddish appearance. Mars is a terrestrial planet with a thin atmosphere, having surface features reminiscent both of the impact craters of the Moon and the volcanoes, valleys, deserts, and polar ice caps of Earth. The rotational period and seasonal cycles of Mars are likewise similar to those of Earth, as is the tilt that produces the seasons. Mars is the site of Olympus Mons, the second highest known mountain within the Solar System (the tallest on a planet), and of Valles Marineris, one of the largest canyons. The smooth Borealis basin in the northern hemisphere covers 40% of the planet and may be a giant impact feature. Mars has two known moons, Phobos and Deimos, which are small and irregularly shaped. These may be captured asteroids, similar to 5261 Eureka, a Martian trojan asteroid."
  a.save

puts "  jupiter"
  a=Astro::Solar.new
  a.name="Jupiter"
  a.position=5
  a.size=142984
  a.size_earth=11.2092
  a.mass=1898600.8
  a.mass_earth=317.8
  a.distance=778412027
  a.distance_earth=5.2034
  a.orbital_period=4333.287
  a.trading_period="9h55m30s"
  a.moons=63
  a.type="Gas giant"
  a.info="Jupiter is the fifth planet from the Sun and the largest planet in the Solar System. It is a gas giant with mass one-thousandth that of the Sun but is two and a half times the mass of all the other planets in the Solar System combined. Jupiter is classified as a gas giant along with Saturn, Uranus and Neptune. Together, these four planets are sometimes referred to as the Jovian or outer planets. The planet was known by astronomers of ancient times, and was associated with the mythology and religious beliefs of many cultures. The Romans named the planet after the Roman god Jupiter. When viewed from Earth, Jupiter can reach an apparent magnitude of −2.94, making it on average the third-brightest object in the night sky after the Moon and Venus. (Mars can briefly match Jupiter's brightness at certain points in its orbit.)"
  a.save

  puts "  saturn"
  a=Astro::Solar.new
  a.name="Saturn"
  a.position=6
  a.size=120536
  a.size_earth=9.4494
  a.mass=568516.8
  a.mass_earth=95.1620
  a.distance=1426725413
  a.distance_earth=9.5371
  a.orbital_period=10756.200
  a.trading_period="10h 39m 22s"
  a.moons=62
  a.type="Gas giant"
  a.info="Saturn is the sixth planet from the Sun and the second largest planet in the Solar System, after Jupiter. Named after the Roman god Saturn, its astronomical symbol (♄) represents the god's sickle. Saturn is a gas giant with an average radius about nine times that of Earth. While only one-eighth the average density of Earth, with its larger volume Saturn is just over 95 times more massive than Earth."
  a.save

  puts "  uranus"
  a=Astro::Solar.new
  a.name="Uranus"
  a.position=7
  a.size=51118
  a.size_earth=4.0074 
  a.mass=86841.0
  a.mass_earth=14.5360
  a.distance=2870972220
  a.distance_earth=19.1913
  a.orbital_period=30707.490
  a.trading_period="17h 14m 24s"
  a.moons=27
  a.type="Gas-ice giant"
  a.info="Uranus is the seventh planet from the Sun. It has the third-largest planetary radius and fourth-largest planetary mass in the Solar System. Uranus is similar in composition to Neptune, and both are of different chemical composition than the larger gas giants Jupiter and Saturn. For this reason, astronomers sometimes place them in a separate category called 'ice giants'. Uranus's atmosphere, although similar to Jupiter's and Saturn's in its primary composition of hydrogen and helium, contains more 'ices' such as water, ammonia, and methane, along with traces of hydrocarbons. It is the coldest planetary atmosphere in the Solar System, with a minimum temperature of 49 K (−224 °C). It has a complex, layered cloud structure, with water thought to make up the lowest clouds, and methane thought to make up the uppermost layer of clouds. In contrast, the interior of Uranus is mainly composed of ices and rock."
  a.save

  puts "  neptune"
  a=Astro::Solar.new
  a.name="Neptune"
  a.position=8
  a.size=49528
  a.size_earth=3.8827
  a.mass=102439.6
  a.mass_earth=17.1470
  a.distance=4498252900
  a.distance_earth=30.0690  
  a.orbital_period=60223.353
  a.trading_period="16h 06m 36s"
  a.moons=13
  a.type="Gas-ice giant"
  a.info="Neptune is the eighth and farthest planet from the Sun in the Solar System. It is the fourth-largest planet by diameter and the third-largest by mass. Neptune is 17 times the mass of Earth and is somewhat more massive than its near-twin Uranus, which is 15 times the mass of Earth but not as dense. On average, Neptune orbits the Sun at a distance of 30.1 AU, approximately 30 times the Earth–Sun distance. Named for the Roman god of the sea, its astronomical symbol is ♆, a stylised version of the god Neptune's trident."
  a.save