# PollEV_to_Canvas
A simple script to convert Poll Everywhere results into Canvas friendly csv files that reward students for answering questions and answering them correctly.

Basics of Grading

This Ruby script uses Poll Everywhere gradebook csv files to create a canvas grade = Total points earned + Total answered.  This script automatically sets the Canvas Points Possible equal to the maximum score from the class.  

Line 70 can be easily modified if you prefer to give correct responses a different weight relative to questions answered. 

Setup

Using this script requires a little bit of setup.  

Each class requires a lightly modified version of the standard canvas gradebook upload.  Download the blank canvas gradebook for each class and label it with the course number (217 or 319).  Add a column labeled Email that contains the email for each student as it is registered to Poll Everywhere.  

You must install ruby (if you have a Mac, it is installed by default) and be comfortable with using the Terminal.  This script requires the smarter_csv gem which can be installed by 'running gem install smarter_csv'

Running the Script

There are two ways to use the script.  If you setup your reports in Poll Everywhere so that the report is named "XXX Gradename" the ouput file will be "XXX-Gradename_xxxxxxx.csv".  The script pulls the XXX and the Gradename and merges the grades with the students in class XXX and creates a grade collumn named Gradename.  The ouptut fille will be "GradenameXXX.csv".

If you prefer, you can input the class and module name directly when you run the script:

ruby pev2canvas.rb nameoffiledownloadedfrompev.csv Grade_name_for_canvas XXX ZZ

The module name cannot have spaces, if you want it to be two words, use an underscore for the space.  XXX is the course number of the csv file and ZZ is the max score on the assignment.
