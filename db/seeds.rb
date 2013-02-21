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
    aa.each do |c|
      c=c.gsub!(/<.*?>/,"")
      c=c.gsub!(/&amp;#160;/,"")
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

