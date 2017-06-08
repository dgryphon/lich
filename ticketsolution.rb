require 'rubygems'
require 'mechanize'

# USE THIS SCRIPT AT YOUR OWN RISK
# Do not try to run this like a regular lich script, this has to be run from the command prompt.
# You will need the mechanize library - google for instructions on getting it and installing it - it's relatively easy
# Do not bother me with questions, I'm not supporting this script, just providing it as a bandaid until simu makes things fair

accountname = 'youraccount' 		#change me - your account
accountpassword = 'yourpassword' 	#change me - your password
accountType = 'premium'				#change me - 'premium' or 'standard'
questID = '228'						#change me  - obtained from ticket page - this will be determined by the html link of quest (should be 230+)
questSlotID = '2'					#change me - batch of tickets being sold - this will be the lot of tickets you're trying for 1-4 if next round stays consistent with previous ticket sales

a = Mechanize.new
a.get('http://www.play.net/gs4/quests/') do |mainpage|

	page = a.click(mainpage.link_with(:text => /Return to Coraesine Field/))

	# Submit the login form
	available_tickets_page = page.form_with(:action => '/includes/common/login/login.asp') do |f|
		f.account_name  = accountname		
		f.account_password  = accountpassword
	end.click_button

	puts 'I logged in'
  
	br = available_tickets_page.form_with(:action => 'group_details.asp')

	br['questDetailsOnly'] = 'false'   #change me - determines sign up versus details - false means sign up for ticket
	br['questSlotSubscription'] = accountType  
	br['questSlotID'] = questSlotID		
	br['questID'] = questID			
	
	Ishouldkeepgoing = true
	incrm = 1
	
	while (incrm < 10000 && Ishouldkeepgoing)
	
		puts 'Attemping to purchase'
	
		# identify the quest being changed
		purchase_tickets_page = br.submit
	
		if (purchase_tickets_page.code == '200')
						
			chk = purchase_tickets_page.form_with(:action => 'purchase_results.asp')
			if chk != nil
				puts 'Made it to the second screen!'
				purchase_tickets_page['questSlotSubscription'] = accountType
				purchase_tickets_page['questSlotID'] = questSlotID			
				purchase_tickets_page['questID'] = questID			
	
				successcode = purchase_tickets_page.submit
				if (successcode.code == '200')
					puts 'YAY YOU GOT ONE! - cntrl+C to stop'
				end
			end
		end
		
		incrm = incrm + 1
		
	end		

end