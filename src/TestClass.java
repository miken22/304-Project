import java.sql.*;
/**
 * @author Mike Nowicki
 *
 */
public class TestClass {

	public static void main(String[] args) throws Exception {
		Class.forName("com.mysql.jdbc.Driver");
		String url = "jdbc:mysql://cosc304.ok.ubc.ca/db_test";
		String uid = "test";
		String pw = "test";
		
		Connection con = DriverManager.getConnection(url, uid, pw);
		Statement stmt = con.createStatement();
		ResultSet rst = stmt.executeQuery("SELECT ename,salary FROM Emp");
		
		while(rst.next()){
			System.out.println(rst.getString("ename"));
		}
		
		con.close();
	}
	
}
