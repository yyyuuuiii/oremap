class MapController < ApplicationController
  def index
  	@mygmaps = User.all
	@hash = Gmaps4rails.build_markers(@mygmaps) do |mygmap, marker|
		marker.lat mygmap.latitude
		marker.lng mygmap.longitude
		marker.infowindow mygmap.address
		marker.json({
		 title: mygmap.title
		})
	end
  end
 end