#  gem install smarter_csv
#  file_name should be of the form:XXX_onewordmoduletitle_junknumbers.csv

require 'smarter_csv'
require 'csv'
Warning[:deprecated] = false

def settings(file_name, module_name, course_number, max_score)

  max_score = 0 if max_score.nil?

  if file_name.nil?
    puts 'You are missing a file name.  You need to at least give me a file name.'
    exit
  end

  if module_name.nil? | course_number.nil?
    puts 'Generating module and course number from the file name.'
    file_name_parts = file_name.split(/\-|\_/)

    course_number = file_name_parts[0]
    module_name = file_name_parts[1]
    puts "Generated module name: #{module_name.capitalize}"
    puts "Generated course number: #{course_number}"
    if max_score != 0
      puts "Max score will be #{max_score}."
    else
      puts "Max score will be equal to the highest score."
    end
  end

  puts "PEV results will be output to '#{module_name.capitalize}#{course_number}.csv'."
  settings_hash = {
    file_name: file_name,
    course_number: course_number,
    module_name: module_name,
    max_score: max_score
  }
  return settings_hash
end

def input_grades(table)
  # inputs table of grade from pev as array of hash
  CSV.read(table, headers: true)
end

def print_results(table)
  # creates the hash with email as the key and pev grade as the value
  # returns the hash
  table.each do |x|
    puts x['Email']
    puts x['Total points earned'].to_i + x['Total answered'].to_i
  end
end

def class_table(course_number)
  table = SmarterCSV.process('' + course_number + '.csv')
end

class Array
  def to_csv(csv_filename, module_name)
    require 'csv'
    # Get all unique keys into an array automatically:
    # keys = self.flat_map(&:keys).uniq
    # hard coded canvas format
    keys = [:student, :id, :sis_user_id, :sis_login_id, :section, module_name.downcase.to_sym]
    CSV.open(csv_filename, 'wb') do |csv|
      # hard coded in canvas format
      csv << ['Student', 'ID', 'SIS User ID', 'SIS Login ID', 'Section', module_name.capitalize]
      each do |hash|
        # fetch values at keys location, inserting null if not found.
        csv << hash.values_at(*keys)
      end
    end
  end
end

file_name, module_name, course_number, max_score = ARGV

params = settings(file_name, module_name, course_number, max_score)

pev_table = input_grades(params[:file_name])

canvas_array = class_table(params[:course_number])

max_score = params[:max_score]
pev_results = {}

pev_table.each do |x|
  grade = x['Total points earned'].to_i + x['Total answered'].to_i
  pev_results[x['Email']] = grade
  max_score = grade if max_score < grade
end

canvas_array.each do |x|
  if x[:student] == 'Points Possible'
    x[params[:module_name].downcase.to_sym] = max_score
  else
    x[params[:module_name].downcase.to_sym] = pev_results[x[:email]]
    x.delete(:email)
  end
end

output_file = params[:module_name].capitalize + params[:course_number] + '.csv'
canvas_array.to_csv(output_file, params[:module_name])
