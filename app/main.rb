require_relative 'works_parser'
require_relative 'works_html_generator'

abort('Please run again with arguments <filename> <output directory>') if ARGV.count != 2

def absolute_path(filename)
  return filename if filename.start_with? '/'
  File.join(Dir.pwd, filename)
end

xml_file = absolute_path ARGV[0]
output_dir = absolute_path ARGV[1]

puts 'Parsing XML file...'
wp = WorksParser.new(File.read(xml_file))
wp.parse

puts "Parsed #{wp.makes.count} makes, #{wp.models.count} models, #{wp.works.count} works"
wp.errors.each { |e| puts e }

puts '-------------'
puts ''
generator = WorksHtmlGenerator.new(wp.makes, output_dir)
puts "Writing HTML files to #{output_dir}..."
generator.generate_tree

