# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'csv'

CSV.foreach('db/seeds/oremap.csv') do |row|
	User.create(
		:title => row[0],
		:address => row[1],
		:tel => row[2],
		:url => row[3],
		:latitude => row[4],
		:longitude => row[5]
	)
end