module ApplicationHelper

	def get_page_title(title='')
		title_stub = "Reservation System"
		if title.empty?
			title_stub
		else
			title + " | " + title_stub
		end
	end
end
