require 'rails_helper'

RSpec.describe User, type: :model do

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

  let(:org_user) {
    FactoryBot.create(
      :user,
      email: 'org_user@example.com',
      category: "organisations"
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

  let(:org_booking) {
    FactoryBot.create(
      :org_booking,
      user_id: org_user.id,
      ad_booking_id: ad_booking.id
    )
  }

  context 'Validations' do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:category) }

    it { should validate_uniqueness_of(:email).ignoring_case_sensitivity }
  end

  context 'Enums' do
    it { should define_enum_for(:category) }
  end

  context 'Scopes' do
  end

  context 'Association' do
    it { should have_many(:slots) }
    it { should have_many(:ad_bookings) }
    it { should have_many(:org_bookings) }
  end

  context 'Instance methods' do
    describe '#full_name' do
      it 'should return full name of the user'do
        expect(admin_user.full_name).to eq("John Doe")
      end
    end

    describe '#unavailable_dates' do
      context 'When user is of type Organisations' do
        context 'When user have pending bookings' do
          before { org_booking }
          it 'should return unavailable dates' do
            expect(org_user.unavailable_dates).to eq([{ from: Date.today, to: Date.today + 5 }])
          end
        end
        context 'When user does not have pending bookings' do
          it 'should not return empty array with no dates' do
            expect(org_user.unavailable_dates).to eq([])
          end
        end
      end
    end
  end

end
