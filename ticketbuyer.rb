require 'rubygems'
require 'mechanize'

# USE THIS SCRIPT AT YOUR OWN RISK - GMs have mentioned banning people for using scripts to purchase tickets
# Do not try to run this like a regular lich script, this has to be run from the command prompt.
  # This script must be renamed to ticketbuyer.rb and ran from the command prompt - it was saved as a lic file to allow for uploading to repo
# You will need the mechanize library - google for instructions on getting it and installing it - it's relatively easy
# Do not bother me with questions, I'm not supporting this script, just providing it as a bandaid until simu makes things fair


accountname = 'hammibal' 		#change me - your account
accountpassword = '8th' 	#change me - your password
accountType = 'premium'				#change me - 'premium' or 'standard'
questID = '227'						#change me  - obtained from ticket page - this will be determined by the html link of quest (should be 230+) - will become available a couple days prior to ticket sales
questSlotID = '12'					#change me - batch of tickets being sold - this will be the lot of tickets you're trying for 1-4 if next round stays consistent with previous ticket sales - will become available a couple days prior to ticket sales


a = Mechanize.new
a.get('http://www.play.net/gs4/quests/') do |mainpage|

	page = a.click(mainpage.link_with(:text => 'Return to Coraesine Field'))

	repeat = 0
	# Submit the login form
	while (repeat < 1)
		begin
		available_tickets_page = page.form_with(:action => '/includes/common/login/login.asp') do |f|
			f.account_name  = accountname		
			f.account_password  = accountpassword
		end.click_button
		repeat = 1
		rescue
			puts 'server error 1'
			repeat = 0
		end
	end

	puts 'I logged in'

   #puts '---------FIRST PAGE------------------'
   #puts available_tickets_page.parser
   #puts '---------END FIRST PAGE------------------'

	
	br = available_tickets_page.form_with(:action => 'group_details.asp')
	
	br['questDetailsOnly'] = 'false'   #change me - determines sign up versus details - false means sign up for ticket
	br['questSlotSubscription'] = 'premium'  
	br['questSlotID'] = questSlotID		
	br['questID'] = questID			
	
	Ishouldkeepgoing = true
	incrm = 1

    
	while (incrm < 5000 && Ishouldkeepgoing)
	
		puts 'Attemping to purchase'
		
		# identify the quest being changed
		begin
		purchase_tickets_page = br.submit
		rescue
		puts '500 error'
		end

#puts '---------SECOND PAGE------------------'
#puts purchase_tickets_page.parser
   #purchase_tickets_page.forms.each do |link|
    #text = link.text.strip
    #next unless text.length > 0
    #puts link
  #end		
#puts '---------END SECOND PAGE------------------'  		
	
		if (purchase_tickets_page.code == '200')
			
			puts 'valid page'
			
			begin
			chk = purchase_tickets_page.form_with(:action => 'purchase_results.asp')
			rescue
			puts '500 error on last page'
			end
			if chk != nil
				puts 'Made it to the second screen!'
				purchase_tickets_page['questSlotSubscription'] = accountType
				purchase_tickets_page['questSlotID'] = questSlotID			
				purchase_tickets_page['questID'] = questID			
	
				successcode = purchase_tickets_page.submit
				if (successcode.code == '200')
					puts 'YAY YOU GOT ONE! - cntrl+C to stop'
					incrm = 4995
				end
			end
		end
		
		incrm = incrm + 1
		
	end		

end