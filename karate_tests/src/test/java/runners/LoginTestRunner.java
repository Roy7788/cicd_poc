package runners;

import com.intuit.karate.junit5.Karate;

// Ye runner Karate ko batata hai ki kaunsi .feature file chalani hai
class LoginTestRunner {

    @Karate.Test
    Karate testLogin() {
        return Karate.run("classpath:features/login.feature");
    }
}
