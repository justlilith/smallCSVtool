#Small CSV CSVTool

##Part tool, part experiment

I use InDesign's Data Merge feature pretty often, and had gotten used to the following workflow:

Drag multiple source image files to TextEdit
Copy the resultant list to regexr.com
Transform the list through regex
Copy the list back to TextEdit
Save the file as CSV

This tool reduces that to these steps:

Drag multiple source image files to the Elm app
Download a CSV file

Caveats: This currently only works with filenames sharing a specific naming convention on a Mac/\*nix system; I haven't yet built functionality for specifying custom field extraction or usage on a Windows environment. Ideally, it'd be useful to someone who isn't me, but I'll continue to develop it over time.
