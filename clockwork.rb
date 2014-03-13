require 'clockwork'
module Clockwork

  every(1.hour, 'process_latest') {
    IO.popen("rake process_latest").each do |line|
      puts line.chomp
    end
  }
  
end