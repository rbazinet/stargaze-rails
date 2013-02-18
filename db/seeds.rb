# coding: UTF-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'open-uri'

puts "Konstelacje"
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
      con=Object::Constellation.new
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