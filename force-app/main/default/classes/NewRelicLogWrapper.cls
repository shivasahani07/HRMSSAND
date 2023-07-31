public class NewRelicLogWrapper {
    
    public class User {
        public String id;
        public String name;
    }
    
    public Common common;
    public List<Logs> logs;
    
    public class Attributes_Z {
        public String logId;
    }
    
    public class Attributes {
        public String logtype;
        public String service;
        public String hostname;
        public String action;
        public User user;
    }
    
    public class Logs {
        public String timestamp;
        public String message;
        public Attributes_Z attributes;
    }
    
    public class Common {
        public Attributes attributes;
    }
    
    
    public static List<NewRelicLogWrapper> parse(String json) {
        return (List<NewRelicLogWrapper>) System.JSON.deserialize(json, List<NewRelicLogWrapper>.class);
    }
}