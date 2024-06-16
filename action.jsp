<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html >
<html>
<head>
    <title>Action Page</title>
</head>
<body>
<%
    int item_id = Integer.parseInt(request.getParameter("item_id"));
    int id = Integer.parseInt(request.getParameter("id"));
    int type = Integer.parseInt(request.getParameter("type"));
    try {
    	Connection conn = DriverManager.getConnection("jdbc:mysql://172.20.10.2/ordering?", "root", "12345678");

        PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM Menu_Items WHERE item_id = ?");
        pstmt.setInt(1, item_id);
        ResultSet rs = pstmt.executeQuery();

        if (rs.next()) {
            String status = rs.getString("status");
            String newStatus = "";
            if (status.equals("Available")) {
                newStatus = "Unavailable";
            } else {
                newStatus = "Available";
            }

            PreparedStatement updateStmt = conn.prepareStatement("UPDATE Menu_Items SET status = ? WHERE item_id = ?");
            updateStmt.setString(1, newStatus);
            updateStmt.setInt(2, item_id);
            updateStmt.executeUpdate();

            updateStmt.close();
        }

        conn.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }

    String redirectURL = "typeManagement.jsp?id=" + id + "&type=" + type;
    response.sendRedirect(redirectURL);
%>
</body>
</html>
