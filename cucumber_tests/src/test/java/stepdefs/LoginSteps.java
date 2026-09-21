package stepdefs;

import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.restassured.RestAssured;
import io.restassured.response.Response;

import static io.restassured.RestAssured.given;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

public class LoginSteps {

    private static final String BASE_URL = "https://reqres.in/api";
    private static final String API_KEY = "reqres-free-v1";

    private Response response;

    @Given("the login API base url")
    public void setBaseUrl() {
        RestAssured.baseURI = BASE_URL;
    }

    @When("I send a login request with email {string} and password {string}")
    public void sendLoginRequest(String email, String password) {
        String body = String.format("{\"email\": \"%s\", \"password\": \"%s\"}", email, password);
        response = given()
                .header("x-api-key", API_KEY)
                .header("Content-Type", "application/json")
                .body(body)
                .post("/login");
    }

    @When("I send a login request with email {string} and no password")
    public void sendLoginRequestWithoutPassword(String email) {
        String body = String.format("{\"email\": \"%s\"}", email);
        response = given()
                .header("x-api-key", API_KEY)
                .header("Content-Type", "application/json")
                .body(body)
                .post("/login");
    }

    @When("I request the user with id {int}")
    public void requestUserById(int id) {
        response = given()
                .header("x-api-key", API_KEY)
                .get("/users/" + id);
    }

    @Then("the response status should be {int}")
    public void checkStatusCode(int statusCode) {
        assertEquals(statusCode, response.statusCode());
    }

    @Then("the response should contain a token")
    public void checkTokenPresent() {
        assertNotNull(response.jsonPath().getString("token"));
    }

    @Then("the response error should be {string}")
    public void checkErrorMessage(String errorMessage) {
        assertEquals(errorMessage, response.jsonPath().getString("error"));
    }

    @Then("the response user id should be {int}")
    public void checkUserId(int id) {
        assertEquals(id, response.jsonPath().getInt("data.id"));
    }

    @Then("the home screen should show the user's name and avatar")
    public void checkHomeScreenData() {
        String firstName = response.jsonPath().getString("data.first_name");
        String avatar = response.jsonPath().getString("data.avatar");
        assertNotNull(firstName);
        assertNotNull(avatar);
    }
}
