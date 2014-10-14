require 'csv'
#The SODA Bread class provides a batching read/write layer over
# the SODA system.
# It currently only really supports Batch Writing, but SODABwrite 
# isn't as fun a name as SODABread
class SODABread
	include Logging    

    def initialize( client, datastore, batch_size)
    	logger.debug("Creating new SODABread")
        @client = client
        @datastore = datastore
        @batch_size = batch_size
        @buffer = []
        @csv_output = true
    end

    def write( hash )

        if @csv_output 
            logger.info('Creating Seed CSV')
            column_names = hash.keys
            s=CSV.generate do |csv|
              csv << column_names

              csv << hash.values
              
            end
            File.write('dataset-seed.csv', s)
            puts s
            @csv_output = false
        end

        logger.debug("Adding %s" % hash.to_s)
        if @buffer.length >= @batch_size
            logger.debug("SODA Bread buffer filled(%d).. auto-flushing" % @batch_size)
        	self.flush()
        end
        @buffer << hash
    end

    def flush()
        logger.info("Writing buffer (%d records) to Socrata '%s'" % [ @buffer.length, @datastore])
    	puts @client.post(@datastore, @buffer)
    	@buffer = []
    end
end