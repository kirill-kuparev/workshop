require 'rails_helper'

RSpec.feature 'Draft events', :type => :feature do
  before(:each) do
    login(:organizer)
    @event = FactoryGirl.create(:event, published: false)

    visit new_event_path
    fill_in 'event_name', :with => @event.name
    fill_in 'event_description', :with => @event.description
    fill_in 'event_max_participants', :with => @event.max_participants
    fill_in 'event_application_deadline', :with => @event.application_deadline
    fill_in "event[date_ranges_attributes][][start_date]", with: Date.current.next_day(2)
    fill_in "event[date_ranges_attributes][][end_date]", with: Date.current.next_day(3)
    choose I18n.t 'events.type.public'
  end

  scenario 'User creates event and publishes it' do
    click_button I18n.t 'events.form.draft.publish'

    expect(page).to have_css(".alert-success")

    # The event should be visible in the events list
    login(:pupil)
    visit events_path
    expect(page).to have_text(@event.name)
  end

  scenario "User saves a draft event, but doesn't publish it" do
    click_button I18n.t 'events.form.draft.save'

    # Show success alert
    expect(page).to have_css('.alert-success')

    # The event should not be visible in the events list
    login(:pupil)
    visit events_path
    expect(page).to_not have_text(@event.name)
  end

  scenario 'User revisits a saved draft event and publishes it' do
    click_button I18n.t 'events.form.draft.save'

    visit edit_event_path(@event)
    click_button I18n.t 'events.form.draft.publish'

    expect(page).to have_css('.alert-success')

    # The event should now be visible in the events list
    login(:pupil)
    visit events_path
    expect(page).to have_text(@event.name)
  end

  scenario 'User updates a saved draft event, but does not publish it' do
    click_button I18n.t 'events.form.draft.save'

    visit edit_event_path(@event)
    click_button I18n.t 'events.form.draft.update'

    expect(page).to have_css(".alert-success")

    # The event should still not be visible in the events list
    login(:pupil)
    visit events_path
    expect(page).to_not have_text(@event.name)
  end

  def login(role)
    @profile = FactoryGirl.create(:profile)
    @profile.user.role = role
    login_as(@profile.user, :scope => :user)
  end
end
