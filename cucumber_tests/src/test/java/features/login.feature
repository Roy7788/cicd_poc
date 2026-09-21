Feature: Login API functional testing (Cucumber)
  # Uses public mock API (reqres.in) - replace with your real backend when applying this to a real app

  Scenario: Successful login with valid credentials
    Given the login API base url
    When I send a login request with email "eve.holt@reqres.in" and password "cityslicka"
    Then the response status should be 200
    And the response should contain a token

  Scenario: Login fails when password is missing
    Given the login API base url
    When I send a login request with email "eve.holt@reqres.in" and no password
    Then the response status should be 400
    And the response error should be "Missing password"

  Scenario: Fetch a valid user by ID
    Given the login API base url
    When I request the user with id 2
    Then the response status should be 200
    And the response user id should be 2

  Scenario: Home screen loads user profile data after successful login
    Given the login API base url
    When I send a login request with email "eve.holt@reqres.in" and password "cityslicka"
    Then the response status should be 200
    And the response should contain a token
    When I request the user with id 2
    Then the response status should be 200
    And the home screen should show the user's name and avatar
