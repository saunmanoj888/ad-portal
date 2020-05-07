Rails.application.routes.draw do
	get '/ad_bookings/vacant_slots', to: "ad_bookings#vacant_slots", as: :vacant_slots
	get '/ad_bookings/:id/accept_bid/:org_booking_id', to: "ad_bookings#accept_bid", as: :accept_bid
	get '/org_bookings/pending_request', to: "org_bookings#pending_request", as: :pending_request
	get '/org_bookings/accepted_request', to: "org_bookings#accepted_request", as: :accepted_request
	get '/org_bookings/rejected_request', to: "org_bookings#rejected_request", as: :rejected_request
	get '/org_bookings/previously_booked', to: "org_bookings#previously_booked", as: :previously_booked
	resources :org_bookings
	resources :ad_bookings
	resources :slots
  devise_for :users
	root to: "public#main"	
end
