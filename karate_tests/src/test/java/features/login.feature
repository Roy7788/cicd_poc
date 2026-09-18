Feature: Login API functional testing (POC)
  # Public mock API (reqres.in) use kiya hai POC ke liye
  # Apne real backend API se replace kar dena jab actual app pe apply karo

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
