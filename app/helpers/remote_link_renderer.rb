# app/helpers/remote_link_renderer.rb

class RemoteLinkRenderer < WillPaginate::LinkRenderer
   def prepare(collection, options, template)
      @remote = options.delete(:remote) || {}
      super
   end

   protected
   # TODO LOCALE!
   def page_link(page, text, attributes = {})
      @template.link_to_remote(text, {:url => url_for(page), :method => :get}.merge(@remote), {
            :title => "Jdi na stránku",
            :href => url_for(page)
         }.merge(@remote))
   end
end
