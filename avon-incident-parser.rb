require 'optparse'
require 'yaml'
require 'csv'
require 'date'
require 'proj4' # So we can convert OS Grid eastings/northings (osgb36)  to latlong (wgs84)
require 'logger'
require 'json'

# List of fields that should be stripped from the 
# incident data before submitting to socrata
blacklist_fields = [ 'Time of Call', 'Day', 'Month', 'Year' ]
logger = Logger.new($stdout).tap do |log|
  log.progname = 'avon-incident-parser'
end

class String
  def underscore
    self.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("- ", "_").    
    gsub(/\W?/, "").
    downcase
  end
end

logger.level = Logger::DEBUG

logger.info("Loading configuration")
# Load up some default options
options = YAML.load_file('cfg.yml')


OptionParser.new do |opts|
  opts.banner = "Usage: avon-incident-parser.rb [options]"

  opts.on('-f', '--sourcefile Filename', 'Source File') { |v| options[:source] = v }  
  opts.on('-r', '--rta', 'Road Traffic Incidents') { |v| options[:datagroup] = "rta" }  

end.parse!

if options[:source].nil?
	logger.fatal "-f required - Please provide a filename to load"
	exit 1
end


def to_latlong(easting, northing)
	# logger.debug("Converting %s,%s to LatLong" % 	[easting, northing])
	easting = easting.to_i
	northing = northing.to_i
	srcPoint = Proj4::Point.new(easting, northing)

	srcProj = Proj4::Projection.new('+proj=tmerc +lat_0=49 +lon_0=-2 +k=0.9996012717 +x_0=400000 +y_0=-100000 +ellps=airy +datum=OSGB36 +units=m +no_defs')
	dstProj = Proj4::Projection.new('+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs')

	dstPoint = srcProj.transform(dstProj, srcPoint)

	dstPoint.lat = dstPoint.lat * (180 / Math::PI)
	dstPoint.lon = dstPoint.lon * (180 / Math::PI)
	# logger.debug("Converted coordinates: [%s,%s]" % [dstPoint.lat, dstPoint.lon])
    return dstPoint
end


logger.info("Reading %s " % options[:source])
#CSV.foreach(options[:source], headers:true, :encoding => 'windows-1251:utf-8') do |row|
CSV.foreach(options[:source], headers: true,encoding: 'iso-8859-1:UTF-8') do |row|
	logger.debug("Reading row")
	unless row['Unitary Authority']=="BANES" 
		logger.debug("Skipping non BANES location...")
		next
	end	
	logger.debug(row.inspect)

    # Extrapolate a normal Date object
    timeString = "%s-%s-%sT%s" % [ row['Year'],row['Month'],row['Day'], row['Time of Call'] ]    
	realDate = DateTime.strptime(timeString, '%Y-%B-%dT%H:%M:%S')

	# The incident data provides a reduced accuracy for the easting/northing location
	# by replacing the last three digits with asterixs (*) 
	# Assuming the values are simply replaced out, put back a "500" so that the
	# returned position is the middle of the possible coordinate error range
	position = to_latlong(row['X Coordinate'].sub("***","500"), row['Y Coordinate'].sub("***","500"))

	# logger.debug( "Position: %s, %s" % [position.lat, position.lon] )
	
	type_list = row['Property Type'].split(">")

	socrata_data_row = {}

	type_list.each.with_index{ |d,i| socrata_data_row["type_%d"% i] = d.strip}

	socrata_data_row['latitude'] = position.lat
	socrata_data_row['longitude'] = position.lon
	socrata_data_row['datetime'] = realDate.to_s
	socrata_data_row.merge!( row.to_hash )

    # Remove blacklisted fields
    socrata_data_row.delete_if{ |k,v| blacklist_fields.include?(k) }
 
 	#I don't like spaces or capitals
 	socrata_data_row.keys.each{ |k| 
 		logger.debug("Renaming %s to %s" % [k, k.underscore])
 		socrata_data_row[k.underscore] = socrata_data_row.delete(k)
 	}

	logger.debug( socrata_data_row )
	
	#TODO: Write socrata_data_row to socrata :-)
end

logger.info("Finished CSV Loop")
