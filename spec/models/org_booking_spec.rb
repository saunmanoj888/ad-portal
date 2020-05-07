require 'rails_helper'

RSpec.describe OrgBooking, type: :model do

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

  let(:new_org_booking) {
    FactoryBot.build(
      :org_booking,
      user_id: org_user.id,
      ad_booking_id: ad_booking.id
    )
  }

  context 'Validations' do
    it { should validate_presence_of(:start_time) }
    it { should validate_presence_of(:end_time) }
    it { should validate_numericality_of(:rent_amount).only_integer.is_greater_than_or_equal_to(0) }

    describe '#end_date_after_start_date' do
      before { new_org_booking }
      context 'When end date is less than start date' do
        before do
          new_org_booking.start_time = Date.today + 1
          new_org_booking.end_time = Date.today
          new_org_booking.save
        end
        it 'should not allow prganisation to create a new bid' do
          expect(new_org_booking.errors[:end_time]).to eq(["must be after the start date"])
        end
      end
      context 'When end date is greater than start date' do
        before { new_org_booking.save }
        it 'should allow prganisation to create a new bid' do
          expect(new_org_booking.errors[:end_time]).to eq([])
        end
      end
    end

  end

  context 'Scopes' do
    describe '.pending' do
      before { org_booking }
      it 'should return org bookings with status pending' do
        expect(OrgBooking.pending.count).to eq(1)
      end
    end
  end

  context 'Association' do
    it { should belong_to(:user) }
    it { should belong_to(:ad_booking) }
  end

  context 'Instance methods' do

    describe '#run_org_booking_expiration_job' do
      context 'When a new bid is created by organisation' do
        before { org_booking }
        it 'should create delayed job entry to expire this bid on expiration day' do
          expect(Delayed::Job.last.handler).to include("OrgBookingExpirationJob")
        end
      end
    end

  end

end
