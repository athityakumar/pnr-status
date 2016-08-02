require 'mechanize'
mechanize = Mechanize.new
mechanize.history_added = Proc.new { sleep 3 }
mechanize.follow_meta_refresh = true 
mechanize.verify_mode = OpenSSL::SSL::VERIFY_NONE
puts ""
print "Enter PNR # : "
pnr = gets.chomp.to_i
begin
  page = mechanize.get("http://www.indianrail.gov.in/pnr_Enq.html")
  page.forms[0]['lccp_pnrno1'] = pnr
  details = page.forms[0].submit.search(".table_border").search("td")
  details = details[1..details.count-4]
  puts ""
  for i in (0..7)
    puts "#{details[i].text} : #{details[i+8].text}"
  end
  puts "#{details[details.count-2].text} : #{details.last.text}"
  puts ""
  details = details[19..details.count-3]
  while details.count != 0
    puts "#{details[0].text} status: #{details[2].text.strip} (current)"
    details.delete(details.first)
    details.delete(details.first)
    details.delete(details.first)
  end
  puts ""
rescue Exception => e
  puts "Error - couldn't retrieve PNR status. Please check your PNR number."
end