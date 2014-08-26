avon-fire-incidents
===================

Scripts to parse and load into BathHacked Datastore the CSV data stored at the [Avon Fireservice website](http://www.avonfire.gov.uk) which document the Incidents attended by the Avon Fire and Rescue service.

# The Data

This script is able to parse the monthy and yearly [Incident Report](http://www.avonfire.gov.uk/documents/category/100-current-year) and generate a number of different sub-sets for use in more specialised reporting. 

# Troubleshooting

If you have problems installing the proj4rb gem, you may need to install the proj4 binaries.

On ubuntu this can be done using

    $ sudo apt-get install proj-bin libproj-dev

