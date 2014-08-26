avon-fire-incidents
===================

Scripts to parse and load into BathHacked Datastore the CSV data stored at the [Avon Fireservice website](http://www.avonfire.gov.uk) which document the Incidents attended by the Avon Fire and Rescue service.

# The Data

This script is able to parse the monthy and yearly [Incident Report](http://www.avonfire.gov.uk/documents/category/100-current-year) and generate a number of different sub-sets for use in more specialised reporting. 

# Troubleshooting

If you have problems installing the proj4rb gem, you may need to install the proj4 binaries.

On ubuntu this can be done using

    $ sudo apt-get install proj-bin libproj-dev



# Usage

## Setup

1. Copy the cfg.yml.sample to cfg.yml and configure the credentials
2. Run ```bundle install``` to install the needed libraries
    1. You may need to install libproj (See troubleshooting)
3. Go!


## Run
Simply run the following to get a list of options 

    $ ruby avon-incident-parser.rb  --help
    Usage: avon-incident-parser.rb [options]
        -f, --sourcefile Filename        Source File
        -r, --rta                        Road Traffic Incidents - Not Implemented yet
        -v, --verbose                    Wildly chatty debug mode!

The RTA flag is planned as some rudimentary filtering process so sub-data sets can be created with the minimum of fuss. Not sure how its going to be implemented yet. Might use something like ```--add-filter=keyname:value``` so we filter on a few parameters... 