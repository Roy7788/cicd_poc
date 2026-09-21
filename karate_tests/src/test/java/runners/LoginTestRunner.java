package runners;

import com.intuit.karate.junit5.Karate;


class LoginTestRunner {

    @Karate.Test
    Karate testLogin() {
        return Karate.run("classpath:features/login.feature");
    }
}
