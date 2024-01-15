public class FaceBookJsonConverter {
    public Entry[] entry;
	public class Entry {
		public String id;	//120691681130372
		// public Integer time;	//1696688436
		public Changes[] changes;
	}
	public class Changes {
		public Values value;        
		public String field;	//feed
        
	}
	public class Values {
        
		// public Froms from;
		public Post post;
		public String message;	//Test comment
		public String post_id;	//120691681130372_122118391526038948
		public String comment_id;	//122118391526038948_1407753863139300
		public Integer created_time;	//1696688434
		public String item;	//comment
		public String parent_id;	//120691681130372_122118391526038948
		public String verb;	//add
	}
	public class Froms {
		public String id;	//120691681130372
		public String name;	//Integration Test
	}
	public class Post {
		public String status_type;	//mobile_status_update
		public boolean is_published;
		public String updated_time;	//2023-10-07T14:20:34+0000
		public String permalink_url;	//https://www.facebook.com/122117459096038948/posts/pfbid023neN1Kwsg1HiDWxK1mYPXdYPydmbkgbJyDBs5JxYvZ7C1SLT7UD7teEjrodEHMgYl
		public String promotion_status;	//inactive
		public String id;	//120691681130372_122118391526038948
	}
	public static FaceBookJsonConverter parse(String json){
		return (FaceBookJsonConverter) System.JSON.deserialize(json, FaceBookJsonConverter.class);
	}
}