require 'erb'

class RootController
  def show_pages
    renderer = ERB.new(File.read('./views/main_page.erb'))
    renderer.result(binding)
  end
end