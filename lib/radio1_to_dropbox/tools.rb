module Radio1ToDropbox
  module Tools

    def self.show_list
      bucket = Radio1ToDropbox.s3_bucket

      file = bucket.objects["shows.txt"]

      return [] if file.nil?

      contents = file.read
      contents.strip.split(/\s+/)
    end

    def self.download_latest_show
      bucket = Radio1ToDropbox.s3_bucket
      show_list.each do |show_url|
        show = RadioKeeper::Providers::BBC::Show.new show_url

        unless show.nil?
          puts "Processing #{show.title}"

          latest_episode = show.latest_episode
          folder_name = show.title

          unless latest_episode.nil?
            file_name = latest_episode.file_name
            path = "#{folder_name}/#{file_name}"

            pntr = bucket.objects[path]
            info = bucket.objects["#{path}.txt"]

            if !pntr.exists?
              puts "\tDownloading episode #{file_name}"
              m4a_file = latest_episode.as_m4a
              m4a_file.seek(0)

              puts "\tUploading info #{file_name}"
              tracks_played = latest_episode.tracks_played
              string = ""
              tracks_played.each do |track|
                string << "#{track[:track]} - #{track[:artist]}\r\n"
              end
              info.write string

              puts "\tUploading episode #{file_name}"
              pntr.write m4a_file

              puts "\tCompleted #{file_name}"

              generate_rss folder_name
            end
          end
        end
      end
    end

    def self.generate_rss(show)
      bucket = Radio1ToDropbox.s3_bucket

      files = []
      bucket.objects.with_prefix("#{show}/").each do |object|
        next unless object.key.match(/m4a$/)
        files << [object.last_modified, object]
      end

      newest = files.sort.reverse.first(10)

      builder = Builder::XmlMarkup.new
      builder.instruct! :xml, version: "1.0" 
      res = builder.rss version: "2.0" do |rss|
        rss.channel do |channel|
          channel.lastBuildDate newest.first.try :[], 0
          channel.title show
          channel.description "Files for #{show}"
          channel.link "http://bbc.co.uk" 

          newest.each do |(modified_at, object)|
            channel.item do |item|
              name = object.key.gsub("#{show}/", "")
              description = begin
                counterpart = bucket.objects["#{object.key}.txt"]
                if counterpart.exists?
                  counterpart.read.to_s
                else
                  ""
                end
              rescue
                ""
              end

              item.link        object.public_url
              item.title       name
              item.pubDate     modified_at
              item.description { item.cdata! description }
              item.enclosure(url: object.public_url, length: object.content_length, type: "audio/mp4")
            end
          end
        end
      end

      newest.each { |(modified_at, object)| object.acl = :public_read }

      rss_file = bucket.objects["#{show}.rss"]
      rss_file.write(res)
      rss_file.acl = :public_read
    end
  end
end