# frozen_string_literal: true 

# see https://groups.google.com/forum/#!topic/rubyonrails-security/zRNVOUhKHrg

ActionDispatch::Request.prepend(Module.new do 
    def formats 
      super().select do |format| 
        format.symbol || format.ref == "*/*" 
      end
    end 
  end) 