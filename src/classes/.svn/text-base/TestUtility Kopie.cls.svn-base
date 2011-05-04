public with sharing class TestUtility {
    
    
    public static User createTestUser(Profile p) {
        
        String namePrefix = createRandomWord();
        
        AggregateResult[] userCount = [Select count(id) userCount From user where username like :namePrefix];
        
        Object users = userCount[0].get('userCount');

        
        
        User testUser = new User();
        testUser.Email = 'test@test.com';
        testUser.Username = namePrefix+users+'@testuser.com';
  
        if (p.name == 'Customer Portal Manager')
        {
            //Won't work w/o customer portal  
            Contact c = new Contact(LastName = 'D');
            insert c;
            testUser.contactId = c.id;
        }
            
        testUser.LastName = 'test';
        testUser.Alias = 'test';
        testUser.ProfileId = p.Id;
        testUser.LanguageLocaleKey = 'en_US';
        testUser.LocaleSidKey = 'en_US';
        testUser.TimeZoneSidKey = 'America/Chicago';
        testUser.EmailEncodingKey = 'UTF-8';
        insert testUser;
        return testUser;
    }
    
    public static String createRandomWord() {
        
        String ret = 'word' + math.rint(math.random() * 100000);
        
        return ret;
        
    }



}