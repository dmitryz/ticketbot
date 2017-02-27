require 'capybara/poltergeist'
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, js_errors: false)
end
Capybara.default_driver = :poltergeist

def get_count(type)
  @browser.find("[id=ts_res]").find("[title=#{type}]").find("b").text rescue 0
end
