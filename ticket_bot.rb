#!/usr/bin/env ruby

require_relative 'setup-capybara.rb'
require_relative 'mail.rb'

STATIONS = { 'Одесса' => '2208001', 'Ивано-Франковск' => '2218200' }

dt = ARGV[0] || '07.03.2017'
from = ARGV[1] || 'Одесса'
to = ARGV[2] || 'Ивано-Франковск'
lux_treshold = ARGV[3] || 4
coupe_treshold = ARGV[4] || 20

from_id = STATIONS[from]
to_id = STATIONS[to]

@browser = Capybara.current_session
url = "http://booking.uz.gov.ua/ru/"
@browser.visit url
@browser.fill_in 'station_from', with: from
@browser.find("input[name=station_id_from]", visible: false).set from_id
@browser.fill_in 'station_till', with: to
@browser.fill_in 'date_dep', with: dt
@browser.find("input[name=station_id_till]", visible: false).set to_id
@browser.find("[name=search]").click
sleep 1
not_found = @browser.find("[id=ts_res_not_found]") rescue false
if not_found
  puts "No any trains"
else
  coupe_count = get_count('Купе')
  lux_count = get_count('Люкс')
  plac_count = get_count('Плацкарт')
  text = "#{dt}, #{from} -> #{to}\n"
  text += "Coupe=#{coupe_count}, Lux=#{lux_count}, Plac=#{plac_count}\n"
  if lux_count.to_i > lux_treshold.to_i || coupe_count.to_i > coupe_treshold.to_i
    mail_notify("New tickets (#{dt}, #{from} -> #{to})", text, "#{dt}_#{from_id}_#{to_id}.lock")
  end
  puts text
end
