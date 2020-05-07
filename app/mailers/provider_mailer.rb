class ProviderMailer < ApplicationMailer

	def slot_creation_mail slot, provider
		@provider = provider
		@slot = slot
		if @provider.present?
			mail to: @provider.email, message: "You have created a new Slot"
		end
	end

end