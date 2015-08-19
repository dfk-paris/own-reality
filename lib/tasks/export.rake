namespace :or do

  task :frame do
    less = File.read("app/assets/stylesheets/article.css.less")
    style = Less::Parser.new.parse(less).to_css(:compress => true)
    doc = File.read("app/views/tpl/synthese.html.erb")
    doc = ""

    tpl = ERB.new File.read("app/views/tpl/frame.html.erb")
    File.open "/home/schepp/Desktop/or_frame.html", "w" do |f|
      f.write tpl.result(binding)
    end
  end

end