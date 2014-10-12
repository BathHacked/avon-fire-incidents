#!/bin/bash

    curl -XDELETE localhost:9200/avonfire
    curl -XPOST localhost:9200/avonfire -d @es-incident.mapping
    ruby avon-incident-parser-elasticsearch.rb -f data/afrs\ attended\ incidents\ april\ 2009-march-2010\ csv\ 3596\ kb.csv 
    ruby avon-incident-parser-elasticsearch.rb -f data/afrs\ attended\ incidents\ april\ 2010-march-2011\ csv\ 3441\ kb.csv 
    ruby avon-incident-parser-elasticsearch.rb -f data/afrs\ attended\ incidents\ april\ 2011-march-2012\ csv\ 3253\ kb.csv 
    ruby avon-incident-parser-elasticsearch.rb -f data/afrs\ attended\ incidents\ april\ 2012-march-2013\ csv\ 3031\ kb.csv 
    ruby avon-incident-parser-elasticsearch.rb -f data/afrs\ attended\ incidents\ april\ 2013-march-2014\ csv\ 2947\ kb.csv 
    ruby avon-incident-parser-elasticsearch.rb -f data/afrs\ attended\ incidents\ april\ 2014\ csv\ 252\ kb.csv 
    ruby avon-incident-parser-elasticsearch.rb -f data/afrs\ attended\ incidents\ may\ 2014\ csv\ 245\ kb.csv 
    ruby avon-incident-parser-elasticsearch.rb -f data/afrs\ attended\ incidents\ june\ 2014\ csv\ 247\ kb.csv 
    ruby avon-incident-parser-elasticsearch.rb -f afrs_attended_incidents_july_2014.csv 
    ruby avon-incident-parser-elasticsearch.rb -f data/afrs\ attended\ incidents\ august\ 2014\ csv\ 229\ kb.csv 
  
