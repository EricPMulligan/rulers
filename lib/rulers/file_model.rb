require 'multi_json'

module Rulers
  module Model
    class FileModel
      def initialize(filename)
        @filename = filename

        # If filename is "dir/37.json", @id is 37
        basename = File.split(filename)[-1]
        @id = File.basename(basename, '.json').to_i

        obj = File.read(filename)
        @hash = MultiJson.load(obj)
      end

      def [](name)
        @hash[name.to_s]
      end

      def []=(name, value)
        @hash[name.to_s] = value
      end

      def to_h
        @hash
      end

      def self.find(id)
        begin
          FileModel.new("db/quotes/#{id}.json")
        rescue
          return nil
        end
      end

      def self.all
        files = Dir['db/quotes/*.json']
        files.map { |f| FileModel.new f }
      end

      def self.create(attrs)
        hash = {}
        hash['submitter'] = attrs['submitter'] || ''
        hash['quote'] = attrs['quote'] || ''
        hash['attribution'] = attrs['attribution'] || ''

        files = Dir['db/quotes/*.json']
        names = files.map { |f| f.split('/')[-1] }
        highest = names.map { |b| b.to_i }.max
        id = highest + 1

        File.open("db/quotes/#{id}.json", 'w') do |f|
          f.write <<TEMPLATE
{
  "submitter": "#{hash['submitter']}",
  "quote": "#{hash['quote']}",
  "attribution": "#{hash['attribution']}"
}
TEMPLATE
        end

        FileModel.new "db/quotes/#{id}.json"
      end

      def self.save(id, attrs = {})
        puts "Saving '#{attrs.to_s}' to id=#{id}"
        fm = FileModel.find(id)
        fm['submitter'] = attrs['submitter'] if attrs.has_key?('submitter') && fm['submitter'] != attrs['submitter']
        fm['quote'] = attrs['quote'] if attrs.has_key?('quote') && fm['quote'] != attrs['quote']
        fm['attribution'] = attrs['attribution'] if attrs.has_key?('attribution') && fm['attribution'] != attrs['attribution']

        File.open("db/quotes/#{id}.json", 'w') do |f|
          puts 'Hello'
          json = MultiJson.dump(fm.to_h, pretty: true)
          puts "Writing '#{json}' to #{id}.json"
          f.write json
        end

        fm
      end

      def self.find_all_by_submitter(submitter)
        files = self.all
        files.find_all { |file| file['submitter'] == submitter }
      end
    end
  end
end
