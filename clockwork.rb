require 'clockwork'
module Clockwork

  every(1.hour, 'process_latest') {
    `rake process_latest`
  }
  
end