require 'rails_helper'

RSpec.describe AdBooking, type: :model do

	let(:admin_user) {
		FactoryBot.create(:user)
	}

	let(:agent_user) {
		FactoryBot.create(
			:user,
			email: 'agent_user@example.com',
			category: "ad_space_agent"
		)
	}

	let(:slot) {
		FactoryBot.create(:slot, user_id: admin_user.id)
	}

	let(:ad_booking) {
		FactoryBot.create(
			:ad_booking,
			user_id: agent_user.id,
			slot_id: slot.id
		)
	}

  context 'Validations' do
  	it { should validate_presence_of(:title) }
  	it { should validate_presence_of(:description) } 
  	it { should validate_uniqueness_of(:title) }
  end

  context 'Scopes' do
	end

	context 'Association' do
		it { should belong_to(:slot) }
		it { should belong_to(:user) }
		it { should have_many(:org_bookings) }
	end

	context 'Delegations' do
		it { should delegate_method(:name).to(:slot) }
	end

	context 'Instance methods' do
		describe '#run_agent_booking_expiration_job' do
			context 'When bid is accepted for an agent booking' do
				before do
					ad_booking.run_agent_booking_expiration_job(Date.today)
				end
				it 'should create delayed job entry to vacant agent booking on booking expiration' do
					expect(Delayed::Job.last.handler).to include("AgentBookingExpirationJob")
				end
			end
		end
	end
end
