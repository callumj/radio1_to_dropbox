require 'dropbox-api'

module Radio1ToDropbox
  module Tools

    def self.show_list
      client = Radio1ToDropbox.dropbox_client

      file = client.find 'shows.txt'

      return [] if file.nil?

      contents = file.download
      contents.strip.split(/\s+/)
    end

    def self.download_latest_show
      client = Radio1ToDropbox.dropbox_client
      show_list.each do |show_url|
        show = RadioKeeper::Providers::BBC::Show.new show_url

        unless show.nil?
          puts "Processing #{show.title}"

          latest_episode = show.latest_episode
          folder_name = show.title

          folder_exists = begin
                            !(client.find(folder_name).nil?)
                          rescue Exception => e
                            false
                          end

          client.mkdir(folder_name) unless folder_exists

          unless latest_episode.nil?
            file_name = latest_episode.file_name
            path = "#{folder_name}/#{file_name}"

            existing_file = begin
                              client.find(path)
                            rescue Exception => err
                              nil
                            end

            if existing_file.nil?
              m4a_file = latest_episode.as_m4a
              m4a_file.seek(0)

              client.upload path, m4a_file
            end
          end
        end
      end
    end
  end
end