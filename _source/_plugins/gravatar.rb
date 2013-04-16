require 'digest/md5'

module Jekyll
	module GravatarFilter
		def gravatar_url(input,size=nil)
			hash = Digest::MD5.hexdigest(input)
			if size.nil? || !size.is_a?(Numeric) || size < 0
				"http://www.gravatar.com/avatar/#{hash}"
			else
				"http://www.gravatar.com/avatar/#{hash}?s=#{size}"
			end
		end
	end
end

Liquid::Template.register_filter(Jekyll::GravatarFilter)