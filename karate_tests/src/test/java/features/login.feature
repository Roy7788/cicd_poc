Feature: Login API functional testing (POC)
  # Uses public mock API (reqres.in) - replace with your real backend when applying this to a real app

  Background:
    * url 'https://reqres.in/api'
    * header x-api-key = 'reqres-free-v1'

  Scenario: Successful login with valid credentials
    Given path 'login'
    And request { email: 'eve.holt@reqres.in', password: 'cityslicka' }
    When method post
    Then status 200
    And match response.token != null

  Scenario: Login fails when password missing
    Given path 'login'
    And request { email: 'eve.holt@reqres.in' }
    When method post
    Then status 400
    And match response.error == 'Missing password'

  Scenario: Fetch a valid user by ID
    Given path 'users/2'
    When method get
    Then status 200
    And match response.data.id == 2
    And match response.data.email == '#present'
