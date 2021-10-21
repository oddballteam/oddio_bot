class SlackObserver

  ODDBALL_SLACK_URL = 'https://oddball.slack.com'
  ODDBALL_TEST_CHANNEL_URL = 'https://app.slack.com/client/T1ZD0UBMZ/C02HQQMN8J1'

  def initialize
    @browser = Watir::Browser.new
  end

  def observe!
    browser.goto(ODDBALL_SLACK_URL)
    sign_in
    go_to_music_channel
    observe_huddle_element_for_members
    join_huddle

    # emit 'joined' event or stream music
  end

  private

  attr_accessor :browser

  def sign_in
    browser.text_field(name: "email").set "testuser@oddball.io"
    browser.text_field(name: "password").set "testuserpassword"
    browser.button(id: "signin_btn").click

    if browser.div(id: 'password_error').exists?
      raise InvalidAuthenticationError
    end
  end

  def go_to_music_channel
    browser.goto(ODDBALL_TEST_CHANNEL_URL)
  end

  def observe_huddle_element_for_members
    # TODO find correct id for member count
    browser.div(id: 'huddle_member_count').wait_until do |div|
      div.value >= 1
    end
  end

  def join_huddle
    browser.button(id: 'huddle_toggle').click
  end


  class InvalidAuthenticationError < StandardError; end
end
