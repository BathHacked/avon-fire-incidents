
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
    end

    def write( hash ) 
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
        exit 1
    end
end